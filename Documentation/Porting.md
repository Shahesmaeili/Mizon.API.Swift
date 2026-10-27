# Porting notes

Reference: `Shahesmaeili/Mizon.API.DotNet` at `5e7541aac20a64315e3985d166236068c243c624`.

## Preserved contracts

- Both top-level source folders and all operation/request/response subfolders.
- 30 operation names, request/response pairings, endpoint paths and GET/POST choices.
- Unauthenticated login and automatic `accessToken` extraction.
- Request body envelope `{ "content": ... }`; explicit null fields and camelCase JSON names.
- PascalCase GET query parameters, existing query items and percent escaping.
- Six `Mizon-*` device information headers and Bearer auth.
- Endpoint cache durations and disabled cache on the same mutation/comment operations.
- Default 10-second request timeout, five-minute default cache lifetime, gzip POST compression and raw deflate option matching .NET DeflateStream.
- .NET TimeSpan string format, 100ns ticks, negative durations and Int64 limits. `DateTimeOffset` maps to an absolute `Date`; serialization uses UTC, so the original textual offset is not retained.
- NDJSON streaming search, media cache layout, chunk streaming, resumable partial files, pause/resume/cancel and six attempts with exponential backoff.
- Hub method names `JoinEntity`, `LeaveEntity`, `UpdateMusicPlayback`, `RegisterDevice`, `UnregisterDevice`, and all four source presence/viewer events.

## Native adaptations

- Swift protocols replace marker interfaces; DTOs are mutable value types conforming to Codable and Sendable.
- Actors protect token, cache, socket lifecycle and download state. Caller cancellation is native Task cancellation.
- `APIOperation` and `APIStreamOperation` wrap generic descriptors instead of inheriting from request classes.
- Swift `Int16`, `Int64`, `Float`, `UUID`, `Date`, optional values and arrays preserve source value domains. Required strings that are absent/null decode to empty strings, matching practical default-initialized model usage; malformed non-null values throw decoding errors.
- `MizonServices` composes shared instances instead of installing .NET DI services. Consumers import both Swift modules explicitly.
- Official SignalRClient 1.0.0 owns all hub protocol, transport and reconnect logic. Scalar GUID event arguments are received as String and converted to UUID because that version's JSON protocol passes primitive values through unchanged. Listener objects use a dedicated ISO8601 date codec because the dependency uses an unconfigured JSONDecoder.
- `URLSession` handles transport protocol negotiation and automatic response decompression. There is no attempt to force .NET HttpVersion behavior.
- The generic HTTP descriptor additionally supports PUT, PATCH, DELETE, HEAD and OPTIONS; existing operations retain their original methods.

## Correctness changes

- Missing auth returns error 401 rather than an untyped unexpected exception.
- Response cache keys include authorization and device headers. Token changes clear cache; old in-flight responses cannot overwrite newer credentials or populate the current account's cache.
- Login responses are never cached. This avoids retaining passwords in cache keys or failing to reapply a cached token. Error responses are not cached.
- Both enabled cache strategies behave as the source's effective implementation: first request uses the network; subsequent matching requests use the cached response until expiration. There is no in-flight request coalescing.
- Blank NDJSON lines are skipped instead of prematurely ending the stream.
- Media downloads resume at the exact byte offset, check Content-Range and exact chunk length, reject path traversal and concurrent downloads to the same destination, and publish the final path after moving the completed partial file.
- Socket disposal actually stops the official connection and finishes event subscribers; the source disposal method was empty.
- The source registers but ignores ReceiveNotification; this port exposes only the four implemented presence/viewer contracts.

## Infrastructure mapping

`.sln`, `.csproj`, .NET workload installer and NuGet publishing are replaced by SwiftPM and an Apple-platform validation workflow. These tool-specific files cannot be translated literally into Swift source. System zlib is linked from Apple SDKs; no binary framework is vendored. The Microsoft dependency's own MIT license remains in its upstream package; the source repository did not include a project license, so none is invented here.

## Validation limits

The local compiler is Apple Swift 6.4, with Swift 6 language mode and Swift tools 6.4. The package supports the current 6.4.1 patch line, and CI requests 6.4.1; that patch compiler was not installed locally. SDKs: macOS 27.0, iOS 27.1 and watchOS 27.0, using deployment minimums macOS 13/iOS 16/watchOS 9. Cross-compilation is not an on-device runtime test. Live API and hub integration requires a reachable backend and account.
