import Foundation
import RegexBuilder

public struct Builder: Sendable {
    public enum BuildError: Error {
        case invalidSwiftVersion
    }

    public let binaryen: Binaryen.Client

    init() {
        binaryen = .init()
    }
}

extension Builder {
    public func currentSwiftVersion() async throws -> String {
        let (output, _) = try await shellOut(to: .name("swift"), arguments: ["--version"])
        let regex = Regex {
            "Swift version "
            Capture {
                OneOrMore(.digit)
                "."
                OneOrMore(.digit)
            }
        }
        guard let match = output.firstMatch(of: regex) else {
            throw BuildError.invalidSwiftVersion
        }
        return .init(match.1)
    }
}

extension Builder {
    public func buildAmazonLinux(targetName: String, architecture: Architecture = .current) async throws {
        if isAmazonLinux() {
            try await buildNative(
                targetName: targetName,
                flags: ["--static-swift-stdlib"]
            )
        } else {
            let swiftVersion = try await currentSwiftVersion()
            let imageName: String
            switch swiftVersion {
            case "5.10":
                imageName = "swift:5.10-amazonlinux2"
            case "6.0":
                imageName = "swift:6.0-amazonlinux2"
            case "6.1":
                imageName = "swift:6.1-amazonlinux2"
            case "6.2":
                imageName = "swiftlang/swift:nightly-6.2-amazonlinux2"
            default:
                fatalError("Unsupported Swift version: \(swiftVersion)")
            }
            try await buildDocker(
                targetName: targetName,
                architecture: architecture,
                imageName: imageName,
                flags: ["--static-swift-stdlib"]
            )
        }
    }
}

extension Builder {
    public func buildUbuntu(targetName: String, architecture: Architecture = .current) async throws {
        let swiftVersion = try await currentSwiftVersion()
        let imageName: String
        switch swiftVersion {
        case "5.10":
            imageName = "swift:5.10-noble"
        case "6.0":
            imageName = "swift:6.0-noble"
        case "6.1":
            imageName = "swift:6.1-noble"
        case "6.2":
            imageName = "swiftlang/swift:nightly-6.2-noble"
        default:
            fatalError("Unsupported Swift version: \(swiftVersion)")
        }
        try await buildDocker(
            targetName: targetName,
            architecture: architecture,
            imageName: imageName,
            flags: ["--static-swift-stdlib"],
            pre: "apt-get -q update && apt-get install -y libjemalloc-dev"
        )
    }
}

extension Builder {
    public func buildWasm(targetName: String, architecture: Architecture = .current) async throws {
        let swiftVersion = try await currentSwiftVersion()
        let imageName: String
        let flags: [String]
        let pre: String
        switch swiftVersion {
        case "5.10":
            imageName = "ghcr.io/swiftwasm/swift:5.10-focal"
            flags = ["--triple", "wasm32-unknown-wasi"]
            pre = ":"
        case "6.0":
            imageName = "swift:6.0.3"
            flags = ["--swift-sdk", "wasm32-unknown-wasi"]
            pre =
                "swift sdk install https://github.com/swiftwasm/swift/releases/download/swift-wasm-6.0.3-RELEASE/swift-wasm-6.0.3-RELEASE-wasm32-unknown-wasi.artifactbundle.zip --checksum 31d3585b06dd92de390bacc18527801480163188cd7473f492956b5e213a8618"
        case "6.1":
            imageName = "swift:6.1.0"
            flags = ["--swift-sdk", "wasm32-unknown-wasi"]
            pre =
                "swift sdk install https://github.com/swiftwasm/swift/releases/download/swift-wasm-6.1-RELEASE/swift-wasm-6.1-RELEASE-wasm32-unknown-wasi.artifactbundle.zip --checksum 7550b4c77a55f4b637c376f5d192f297fe185607003a6212ad608276928db992"
        case "6.2":
            imageName = "swiftlang/swift:nightly-6.2"
            flags = ["--swift-sdk", "wasm32-unknown-wasi"]
            pre =
                "swift sdk install https://github.com/swiftwasm/swift/releases/download/swift-wasm-DEVELOPMENT-SNAPSHOT-2025-07-18-a/swift-wasm-DEVELOPMENT-SNAPSHOT-2025-07-18-a-wasm32-unknown-wasi.artifactbundle.zip --checksum 249e8fc0dd6bc5e31583d6c63c778830ff0e3b9f98cff7ee6b31b2decf5f87cb"
        default:
            fatalError("Unsupported Swift version: \(swiftVersion)")
        }
        try await buildDocker(
            targetName: targetName,
            imageName: imageName,
            flags: flags,
            pre: pre
        )
        let binaryPath = "\(Context.buildDirectory)/\(architecture.swiftBuildWasmDirectory)/release/\(targetName).wasm"
        try await binaryen.optimize(input: binaryPath, output: binaryPath)
    }
}

extension Builder {
    private func buildNative(targetName: String, flags: [String]) async throws {
        let spinner = UI.spinner(label: #"Building target "\#(targetName)""#)
        defer { spinner.stop() }

        try await shellOut(
            to: .name("swift"),
            arguments: [
                "build",
                "-c", "release",
                "--product", targetName,
            ] + flags,
            onEvent: { spinner.push($0.string()) }
        )
    }

    private func buildDocker(
        targetName: String,
        architecture: Architecture = .current,
        imageName: String,
        flags: [String],
        pre: String = ":"
    ) async throws {
        let spinner = UI.spinner(label: #"Building target "\#(targetName)""#)
        defer { spinner.stop() }

        let buildCommand = "swift build -c release --product \(targetName) \(flags.joined(separator: " "))"
        spinner.push(buildCommand)

        try await shellOut(
            to: .name("docker"),
            arguments: [
                "run",
                "--platform", "linux/\(architecture.dockerPlatform)",
                "--rm",
                "-v", "\(Files.currentDirectoryPath()):/workspace",
                "-w", "/workspace",
                imageName,
                "bash", "-cl",
                "\(pre) && \(buildCommand)",
            ],
            onEvent: { spinner.push($0.string()) }
        )
    }
}

extension Builder {
    private func isAmazonLinux() -> Bool {
        do {
            let data = try Files.readFile(atPath: "/etc/system-release")
            let text = String(data: data, encoding: .utf8)
            return text?.hasPrefix("Amazon Linux") ?? false
        } catch {
            return false
        }
    }
}
