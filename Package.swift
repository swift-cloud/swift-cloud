// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "swift-cloud",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "Cloud", targets: ["Cloud"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
        .package(url: "https://github.com/jpsim/Yams", from: "5.1.3"),
        .package(url: "https://github.com/swift-server/async-http-client", from: "1.21.2"),
        .package(url: "https://github.com/SwiftPackageIndex/ShellOut", from: "3.1.4"),
        .package(url: "https://github.com/vapor/console-kit", from: "4.14.3"),
    ],
    targets: [
        .target(
            name: "Cloud",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "ConsoleKitTerminal", package: "console-kit"),
                .product(name: "ShellOut", package: "ShellOut"),
                .product(name: "Yams", package: "Yams"),
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .executableTarget(
            name: "Example",
            dependencies: ["Cloud"],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "CloudTests",
            dependencies: ["Cloud"],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
    ]
)
