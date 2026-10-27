#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
swift test
swift build --triple arm64-apple-ios16.0 --sdk "$(xcrun --sdk iphoneos --show-sdk-path)"
swift build --triple arm64_32-apple-watchos9.0 --sdk "$(xcrun --sdk watchos --show-sdk-path)"
swift build --triple arm64-apple-watchos9.0 --sdk "$(xcrun --sdk watchos --show-sdk-path)"
