# Installation Guide: libgnss-rtcm-swift

`libgnss-rtcm-swift` is a pure Swift library distributed via the Swift Package Manager (SPM).

## Prerequisites

- **Swift 6.0+**: The library leverages Swift 6 concurrency features and language modes.
- **Operating System**: 
    - macOS 10.15 or later.
    - Linux (Ubuntu 22.04+ recommended).
    - iOS 16.0 or later.

## Installation via Swift Package Manager

To use `libgnss-rtcm-swift` in your project, add it to your `Package.swift` file:

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MyGNSSProject",
    dependencies: [
        .package(url: "https://github.com/shuwang1/libgnss-rtcm-swift", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "MyTarget",
            dependencies: [
                .product(name: "RTCM", package: "libgnss-rtcm-swift")
            ]
        )
    ]
)
```

## Local Development Setup

If you are contributing to the library or running tests locally:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/shuwang1/libgnss-rtcm-swift.git
   cd libgnss-rtcm-swift
   ```

2. **Build the library**:
   ```bash
   swift build
   ```

3. **Run the tests**:
   ```bash
   swift test
   ```

## Documentation Generation

The library uses **Swift-DocC** for documentation. To generate a local preview:

1. **Generate Documentation**:
   ```bash
   swift package generate-documentation --target RTCM
   ```

2. **Preview with Local Server**:
   ```bash
   swift package --allow-writing-to-package-directory preview-documentation --target RTCM
   ```

## Integration with Xcode

1. Open your project in Xcode.
2. Go to **File** > **Add Package Dependencies...**.
3. Enter the repository URL.
4. Select the version or branch you wish to use.
5. Add the `RTCM` product to your target.
