// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "Mizon.API.Swift",
    platforms: [.macOS(.v13), .iOS(.v16), .watchOS(.v9)],
    products: [
        .library(name: "MizonAPI", targets: ["MizonAPI"]),
        .library(name: "MizonAPIClient", targets: ["MizonAPIClient"])
    ],
    dependencies: [.package(url: "https://github.com/dotnet/signalr-client-swift", exact: "1.0.0")],
    targets: [
        .systemLibrary(name: "CZlib", path: "Support/CZlib"),
        .target(name: "MizonAPI", dependencies: ["CZlib", .product(name: "SignalRClient", package: "signalr-client-swift")], path: "Mizon.API"),
        .target(name: "MizonAPIClient", dependencies: ["MizonAPI"], path: "Mizon.API.Client"),
        .testTarget(name: "MizonAPITests", dependencies: ["MizonAPI", "MizonAPIClient", "CZlib"], path: "Tests")
    ],
    swiftLanguageModes: [.v6]
)
