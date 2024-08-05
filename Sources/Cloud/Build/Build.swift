import Foundation
import ShellOut

public struct Build {
    public func buildAmazonLinux(targetName: String) async throws {
        if isAmazonLinux() {
            try await buildNative(
                targetName: targetName,
                flags: "--static-swift-stdlib"
            )
        } else {
            try await buildDocker(
                targetName: targetName,
                imageName: "swift:5.10-amazonlinux2",
                flags: "--static-swift-stdlib"
            )
        }
    }

    public func buildWasm(targetName: String) async throws {
        try await buildDocker(
            targetName: targetName,
            imageName: "ghcr.io/swiftwasm/swift:5.10-focal",
            flags: "--triple wasm32-unknown-wasi"
        )
    }

    private func buildNative(targetName: String, flags: String) async throws {
        try await shellOut(
            to: "swift",
            arguments: ["build", "-c", "release", "--product", targetName] + flags.components(separatedBy: " ")
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
                "--platform", "linux/\(Architecture.current.dockerPlatformString)",
                "--rm",
                "-v", "\(FileManager.default.currentDirectoryPath):/workspace",
                "-w", "/workspace",
                imageName,
                "bash", "-cl", "swift build -c release --product \(targetName) \(flags)",
            ]
        )
    }
}
