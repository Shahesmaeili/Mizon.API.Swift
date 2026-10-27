# Mizon.API.Swift

نسخهٔ نیتیو Swift از [Mizon.API.DotNet](https://github.com/Shahesmaeili/Mizon.API.DotNet)، با حفظ دو ماژول و پوشه‌بندی Requests، Responses و Operations. این پروژه مانند مرجع، **SDK ارتباط با API** است؛ رابط کاربری اپلیکیشن در ریپوی مرجع وجود ندارد.

Native Swift 6 SDK for macOS, iPhone/iPad and Apple Watch. Ported from source commit [`5e7541a`](https://github.com/Shahesmaeili/Mizon.API.DotNet/commit/5e7541aac20a64315e3985d166236068c243c624).

- Swift tools 6.4+, Swift 6 strict concurrency; compatible with the Swift 6.4.1 release line.
- macOS 13+, iOS 16+, watchOS 9+.
- **Official Microsoft SignalR**: [`dotnet/signalr-client-swift`](https://github.com/dotnet/signalr-client-swift), exact version **1.0.0**, pinned in `Package.resolved`.
- Native Foundation `URLSession`, actors, `Codable`, `AsyncThrowingStream`, CryptoKit and system zlib.

## Install

In Xcode: **File → Add Package Dependencies**, enter:

```text
https://github.com/Shahesmaeili/Mizon.API.Swift
```

Choose branch `main`, then add `MizonAPI` and `MizonAPIClient` to your macOS, iOS or watchOS app target. Alternatively:

```swift
// In your Package.swift
.package(url: "https://github.com/Shahesmaeili/Mizon.API.Swift", branch: "main")

// In the consuming target's dependencies
.product(name: "MizonAPI", package: "Mizon.API.Swift"),
.product(name: "MizonAPIClient", package: "Mizon.API.Swift")
```

## Use

```swift
import Foundation
import MizonAPI
import MizonAPIClient

let endpoints = Endpoints(baseURL: URL(string: "https://api.example.com")!)
let api = MizonApi()

let login = await api.sendRequest(LoginOperation(
    LoginRequest(username: "your-username", password: "your-password"),
    endpoints: endpoints
))
if let error = login.error { throw error }
// The access token is now automatically applied to authenticated requests.
let me = await api.sendRequest(MeOperation(MeRequest(), endpoints: endpoints))
if let error = me.error { throw error }
print(me.content?.firstName ?? "")
```

Supply the actual backend URL. The original `https://localhost:5128` default is preserved, but `localhost` on an iPhone or watch refers to that device. Use a reachable HTTPS backend with a trusted certificate. No server or credentials are bundled.

### Streaming search

```swift
let operation = GlobalSearchOperation(GlobalSearchRequest(query: "موسیقی"), endpoints: endpoints)
for try await item in await api.sendStreamRequest(operation) {
    print(item.title ?? item.username ?? item.itemType)
}
```

### Real-time presence with official SignalR

```swift
let socket = MizonSocket(mizonApi: api, hubURL: endpoints.mizonHubURL)
let events = await socket.events()
let musicID = UUID() // Use a real music public ID.
try await socket.joinEntity("Music", entityPublicId: musicID)
try await socket.publishMusicPlayback(
    musicPublicId: musicID,
    position: TimeSpan(seconds: 12.5),
    isPlaying: true
)
for await event in events {
    if case let .musicListenersSnapshot(id, listeners) = event {
        print(id, listeners.count)
    }
}
await socket.dispose()
```

Call `dispose()` when the owning task/view stops, including its error/cancellation paths. `Examples/NativeUsage.swift` includes cleanup on failure. Automatic reconnect and transport negotiation are handled by Microsoft's package; `MizonSocket` rejoins the last entity after reconnect. The token factory reads the current `MizonApi` token. Viewer counts, listener snapshots, listener updates and removals are exposed through an event stream. The source's unused `ReceiveNotification` callback remains without a public notification contract.

### Media downloads

```swift
let root = URL.cachesDirectory.appendingPathComponent("Mizon")
let downloader = MediaDownloader(cacheRoot: root)
let result = await api.sendRequest(MediaOperation(MediaRequest(mediaPublicId: UUID()), endpoints: endpoints))
if let error = result.error { throw error }
if let info = result.content, let storageURL = URL(string: info.storagePath) {
    let control = DownloadSession()
    let file = try await downloader.downloadToCache(info, storageURL: storageURL, session: control)
    print(file.path)
    // control.pause(), resume() and cancel() are actor methods; call with await.
}
```

`download(...)` exposes chunk data, byte counts, speed and local path. Downloads resume `.part` files, retry failed chunks up to six times, validate HTTP ranges and byte lengths, and promote the final file before reporting a last chunk. A storage server must honor byte ranges for multi-chunk downloads. `file://` input also works. File hash is used as the cache key, matching the source; it is not treated as a verified digest because the source does not specify its hash algorithm.

## Structure and parity

```text
Package.swift
Mizon.API/                     → MizonAPI module
  BaseApiRequest.swift
  BaseApiResponse.swift
  MizonApi.swift
  MizonSocket.swift
  ...
Mizon.API.Client/              → MizonAPIClient module
  Endpoints.swift
  Operations/{Clients,Media,Musics,Search,Stories}/
  Requests/{Clients,Media,Musics,Search,Stories}/
  Responses/{Clients,Media,Musics,Search,Stories}/
Support/CZlib/                → system zlib bridge
Tests/
Examples/
Documentation/
```

All **30 operations**, all request/response models and nested DTOs, and all 99 source `.cs` files have corresponding Swift files. See [`Documentation/SourceMapping.json`](Documentation/SourceMapping.json) and [`Documentation/Porting.md`](Documentation/Porting.md).

Swift uses structs/protocols and lowerCamelCase properties instead of C# classes/interfaces/PascalCase members. Wire JSON names, HTTP paths/methods, query names, auth requirements and endpoint cache durations are preserved. `MizonServices` replaces `IServiceCollection` registration; `Package.swift` replaces `.sln`/`.csproj`; the CI workflow replaces NuGet publishing infrastructure.

## Validate

```sh
swift test
./Scripts/validate-apple.sh
```

Local validation used **Apple Swift 6.4 / Xcode 27.1**: 14 tests passed, plus compilation for macOS, iOS arm64 and watchOS arm64_32/arm64. CI requests Swift 6.4.1. Tests cover every operation's route/method, wire JSON, .NET TimeSpan bounds, gzip/deflate, auth/cache isolation and expiration, errors, NDJSON search, resumed/ranged downloads, cancellation, socket lifecycle and presence decoding.

No live backend address or test account was supplied. Authentication against a deployed server, real hub reconnection and on-device runtime behavior still require integration testing with your backend. watchOS builds successfully with the official dependency; network/background execution remains subject to Apple's app lifecycle rules.
