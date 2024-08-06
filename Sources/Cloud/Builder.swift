import Foundation
import RegexBuilder
import ShellOut

public struct Builder: Sendable {
    public enum BuildError: Error {
        case invalidSwiftVersion
    }
}

extension Builder {
    public func currentSwiftVersion() async throws -> String {
        let (output, _) = try await shellOut(to: "swift", arguments: ["--version"])
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
    public func buildAmazonLinux(targetName: String) async throws {
        if isAmazonLinux() {
            try await buildNative(
                targetName: targetName,
                flags: "--static-swift-stdlib"
            )
        } else {
            let swiftVersion = try await currentSwiftVersion()
            try await buildDocker(
                targetName: targetName,
                imageName: "swift:\(swiftVersion)-amazonlinux2",
                flags: "--static-swift-stdlib"
            )
        }
    }
}

extension Builder {
    public func buildWasm(targetName: String) async throws {
        let swiftVersion = try await currentSwiftVersion()
        try await buildDocker(
            targetName: targetName,
            imageName: "ghcr.io/swiftwasm/swift:\(swiftVersion)-focal",
            flags: "--triple wasm32-unknown-wasi"
        )
    }
}

extension Builder {
    private func buildNative(targetName: String, flags: String) async throws {
        try await shellOut(
            to: "swift",
            arguments: [
                "build",
                "-c", "release",
                "--product", targetName,
            ] + flags.components(separatedBy: " ")
        )
    }

    private func buildDocker(
        targetName: String,
        imageName: String,
        flags: String
    ) async throws {
        try await shellOut(
            to: "docker",
            arguments: [
                "run",
                "--platform", "linux/\(Architecture.current.dockerPlatform)",
                "--rm",
                "-v", "\(currentDirectoryPath()):/workspace",
                "-w", "/workspace",
                imageName,
                "bash", "-cl", "swift build -c release --product \(targetName) \(flags)",
            ]
        )
    }
}

extension Builder {
    private func isAmazonLinux() -> Bool {
        do {
            let data = try readFile(atPath: "/etc/system-release")
            let text = String(data: data, encoding: .utf8)
            return text?.hasPrefix("Amazon Linux") ?? false
        } catch {
            return false
        }
    }
}
