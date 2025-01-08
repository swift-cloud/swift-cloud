// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "swift-cloud",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "Cloud", targets: ["Cloud"]),
        .library(name: "CloudAWS", targets: ["CloudAWS"]),
        .library(name: "CloudCloudflare", targets: ["CloudCloudflare"]),
        .library(name: "CloudCore", targets: ["CloudCore"]),
        .library(name: "CloudFastly", targets: ["CloudFastly"]),
        .library(name: "CloudKit", targets: ["CloudKit"]),
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
                "CloudAWS",
                "CloudCloudflare",
                "CloudCore",
                "CloudFastly",
            ]
        ),
        .target(
            name: "CloudAWS",
            dependencies: ["CloudCore"]
        ),
        .target(
            name: "CloudCloudflare",
            dependencies: ["CloudCore"]
        ),
        .target(
            name: "CloudCore",
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
            name: "CloudFastly",
            dependencies: ["CloudCore"]
        ),
        .target(
            name: "CloudKit",
            dependencies: []
        ),
        .testTarget(
            name: "CloudCoreTests",
            dependencies: ["CloudCore"]
        ),
    ]
)
