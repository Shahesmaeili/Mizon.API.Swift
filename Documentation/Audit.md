# .NET parity audit

Reference: `Mizon.API.DotNet` main at `5e7541aac20a64315e3985d166236068c243c624`, refreshed before this audit.

| Area | Result |
| --- | --- |
| File mapping | All 99 `.cs` files have corresponding Swift source files |
| Request, response and nested DTO types | 78 models; all 246 properties checked for name, type, width and optionality |
| Wire values | Every DTO decoded and re-encoded with all fields populated from a source-derived fixture, including nested objects, lists, UUIDs, dates and TimeSpan |
| Case-insensitive DTO keys | Uppercase-key fixtures decode for all 78 source DTOs |
| Operations | All 30 routes, methods, request/response pairs, auth flags, cache flags/durations, timeouts and compression defaults checked |
| Named endpoints | All 30 source endpoint members are available under configurable `clients`, `musics`, `medias`, `stories`, `search` namespaces |
| Socket | All five source hub calls and all four active source presence/viewer events accounted for; official Microsoft SignalR 1.0.0 retained |
| App composition | `MizonServices` replaces .NET service registration; the source's unused callback and metadata have no additional server behavior |
| Apple platforms | macOS tests plus iOS arm64 and watchOS arm64_32/arm64 compilation |

## Fixes made after the initial port

1. Query escaping now matches `Uri.EscapeDataString`. In particular, literal `+` is emitted as `%2B`, preventing ASP.NET from interpreting it as a space. Existing encoded queries remain intact.
2. A structured task deadline limits the entire HTTP or NDJSON transfer. Foundation's request timeout alone only limits idle time, so periodically arriving bytes could previously keep a call alive beyond the source timeout.
3. `BaseApiResponse` encoding includes the source's computed `isSuccess` field and explicit null content/error members.
4. Named endpoint namespaces were restored in native instance form, with a configurable base URL.
5. `DownloadSession.cancel()` cancels an in-flight URLSession transfer within the cancellation observer interval instead of waiting for the current network call to complete.
6. Download streams buffer at most one pending chunk and apply backpressure without dropping chunks. Slow consumers no longer accumulate an entire media file in RAM.
7. Whitespace-only media hashes/categories use the source's public-ID/`others` fallbacks. Cache path validation runs before creating nested directories.

## Reproduce

```sh
python3 Scripts/audit-dotnet.py /path/to/Mizon.API.DotNet
swift test
./Scripts/validate-apple.sh
```

`DotNetContract.json` records source field types; `Tests/Fixtures/DotNetContracts.json` records populated wire fixtures. There are 24 Swift tests, including all-model wire checks and all-operation configuration checks, plus regressions for query escaping, full-body deadlines, in-flight cancellation and download backpressure.

## Deliberate differences and limits

The native adaptations and correctness improvements described in `Porting.md` remain intentional. No model or source operation is missing. The code uses native Swift value semantics and does not reproduce .NET DI, an empty disposal implementation or known source download bugs. Registration, token refresh endpoints and a UI are absent from the source SDK and are not invented.

The initial GitHub Actions run `40389403472` was inspected through both run and job metadata: status `queued`, job `validate`, label `macos-latest`, no assigned runner, no steps and no logs. This is not a failing build result. The workflow now has a job timeout and superseded-run cancellation. A newer push triggers a new run; local validation is reported separately from remote CI. Live backend and physical-device integration testing require a service address and account.

Follow-up CI diagnosis: run #1 completed with failure before any build steps. Its `validate` job was cancelled, and GitHub reported “The job was not acquired by Runner of type hosted even after multiple attempts”, an internal server error and macOS arm64 capacity notices. The workflow was switched to the documented standard `macos-26-intel` runner to avoid that ARM capacity pool.
