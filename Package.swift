/*
 * Festina lente 
 * Copyright (c) 2026 Shu Wang <shuwang1@outlook.com>. All rights reserved.
 */

// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "libgnss-rtcm-swift",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "RTCM",
            targets: ["RTCM"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "RTCM",
            dependencies: []),
        .testTarget(
            name: "RTCMTests",
            dependencies: ["RTCM"]),
    ],
    swiftLanguageModes: [.v6]
)
