// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-cloud",
    platforms: [
        .macOS(.v26)
    ],
    products: [
        .library(name: "Cloud", targets: ["Cloud"]),
        .library(name: "CloudAWS", targets: ["CloudAWS"]),
        .library(name: "CloudCloudflare", targets: ["CloudCloudflare"]),
        .library(name: "CloudCore", targets: ["CloudCore"]),
        .library(name: "CloudDigitalOcean", targets: ["CloudDigitalOcean"]),
        .library(name: "CloudFastly", targets: ["CloudFastly"]),
        .library(name: "CloudSDK", targets: ["CloudSDK"]),
        .library(name: "CloudVercel", targets: ["CloudVercel"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-crypto", "1.0.0"..<"5.0.0"),
        .package(url: "https://github.com/soto-project/soto-core", from: "7.0.0"),
        .package(url: "https://github.com/swift-cloud/Command", from: "0.14.0"),
        .package(url: "https://github.com/swift-server/async-http-client", from: "1.0.0"),
        .package(url: "https://github.com/swiftlang/swift-subprocess", from: "0.2.1"),
        .package(url: "https://github.com/vapor/console-kit", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "Cloud",
            dependencies: [
                "CloudAWS",
                "CloudCloudflare",
                "CloudCore",
                "CloudDigitalOcean",
                "CloudFastly",
                "CloudVercel",
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
                .product(name: "SotoCore", package: "soto-core"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "Command", package: "Command"),
                .product(name: "ConsoleKitTerminal", package: "console-kit"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "Subprocess", package: "swift-subprocess"),
            ]
        ),
        .target(
            name: "CloudDigitalOcean",
            dependencies: ["CloudCore"]
        ),
        .target(
            name: "CloudFastly",
            dependencies: ["CloudCore"]
        ),
        .target(
            name: "CloudSDK",
            dependencies: []
        ),
        .target(
            name: "CloudVercel",
            dependencies: ["CloudCore"]
        ),
        .testTarget(
            name: "CloudCoreTests",
            dependencies: ["CloudCore"]
        ),
    ]
)
