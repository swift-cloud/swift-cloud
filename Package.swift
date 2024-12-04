// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "swift-cloud",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "Cloud", targets: ["Cloud"]),
        .library(name: "AWSCloud", targets: ["AWSCloud"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
        .package(url: "https://github.com/apple/swift-crypto", "1.0.0"..<"4.0.0"),
        .package(url: "https://github.com/jpsim/Yams", from: "5.1.3"),
        .package(url: "https://github.com/soto-project/soto-core", from: "7.0.0"),
        .package(url: "https://github.com/swift-server/async-http-client", from: "1.22.1"),
        .package(url: "https://github.com/tuist/Command", from: "0.9.32"),
        .package(url: "https://github.com/vapor/console-kit", from: "4.15.0"),
    ],
    targets: [
        .target(
            name: "Cloud",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "Command", package: "Command"),
                .product(name: "ConsoleKitTerminal", package: "console-kit"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "SotoCore", package: "soto-core"),
                .product(name: "Yams", package: "Yams"),
            ]
        ),
        .target(
            name: "AWSCloud",
            dependencies: ["Cloud"]
        ),
        .executableTarget(
            name: "Example",
            dependencies: ["AWSCloud"]
        ),
        .testTarget(
            name: "CloudTests",
            dependencies: ["Cloud"]
        ),
    ]
)
