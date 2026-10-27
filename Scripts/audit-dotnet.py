#!/usr/bin/env python3
"""Audit the port against a checkout of the pinned .NET reference (stdlib only)."""
import json, pathlib, re, sys
root = pathlib.Path(__file__).resolve().parents[1]
source = pathlib.Path(sys.argv[1]).resolve() if len(sys.argv) == 2 else None
if source is None:
    raise SystemExit('Usage: python3 Scripts/audit-dotnet.py /path/to/Mizon.API.DotNet')

def swift_type(value):
    if value.endswith('?'): return swift_type(value[:-1]) + '?'
    if value.startswith('List<'): return '[' + swift_type(value[5:-1]) + ']'
    return {'Guid': 'UUID', 'string': 'String', 'int': 'Int', 'long': 'Int64', 'short': 'Int16',
            'float': 'Float', 'double': 'Double', 'bool': 'Bool', 'TimeSpan': 'TimeSpan', 'DateTimeOffset': 'Date'}.get(value, value)

mapping = json.loads((root / 'Documentation/SourceMapping.json').read_text())
actual_files = {str(p.relative_to(source)) for p in source.rglob('*.cs')}
assert actual_files == {entry[0] for entry in mapping}, 'Source file inventory changed'
for old, new in mapping:
    assert (root / new).is_file(), f'Missing Swift file for {old}'
models = json.loads((root / 'Documentation/DotNetContract.json').read_text())['models']
properties = 0
for model in models:
    text = (source / model['source']).read_text(encoding='utf-8-sig')
    declaration = re.search(r'public (?:sealed )?class ' + model['name'] + r'(?:\s*:\s*\w+)?\s*\{', text)
    assert declaration, f'Missing source class: {model["name"]}'
    start = cursor = declaration.end()
    depth = 1
    while depth:
        depth += (text[cursor] == '{') - (text[cursor] == '}')
        cursor += 1
    fields = re.findall(r'public\s+([\w<>?]+)\s+(\w+)\s*\{\s*get;\s*set;', text[start:cursor-1])
    assert fields == [(p['type'], p['name']) for p in model['properties']], f'.NET contract changed: {model["name"]}'
    swift_path = root / pathlib.Path(model['source']).with_suffix('.swift')
    swift = swift_path.read_text().split('public struct ' + model['name'] + ':', 1)[1].split('\npublic struct ', 1)[0]
    actual = re.findall(r'public var (\w+): ([\w\[\]?]+)', swift)
    expected = [(name.lower() if name.isupper() else name[0].lower()+name[1:], swift_type(t)) for t, name in fields]
    assert actual == expected, f'Swift field/type mismatch: {model["name"]}'
    properties += len(fields)
operations = list((source / 'Mizon.API.Client/Operations').rglob('*Operation.cs'))
for p in operations:
    text = p.read_text(encoding='utf-8-sig')
    method = re.search(r'base\(HttpMethod\.(\w+)', text)[1]
    swift = (root / p.relative_to(source).with_suffix('.swift')).read_text()
    assert f'httpMethod: .{method}' in swift, f'HTTP method differs: {p.name}'
    assert ('NeedAuthorized = false' in text) == ('needAuthorized = false' in swift), f'Authorization differs: {p.name}'
    assert ('ClientCacheStrategy = ClientCacheStrategy.Disabled' in text) == ('clientCacheStrategy = .disabled' in swift), f'Cache strategy differs: {p.name}'
    assert ('PropertyForToken =' in text) == ('propertyForToken =' in swift), f'Token selector differs: {p.name}'
    if 'MizonApiStreamRequest' not in text:
        duration = re.search(r'MaximumClientCacheDuration = TimeSpan.From(Seconds|Minutes)\((\d+)\)', text)
        seconds = int(duration[2]) * (60 if duration[1] == 'Minutes' else 1) if duration else 300
        assert f'maximumClientCacheDuration = {seconds}\n' in swift, f'Cache duration differs: {p.name}'
print(f'PASS: {len(mapping)} source files, {len(models)} models, {properties} typed fields, {len(operations)} operations')
