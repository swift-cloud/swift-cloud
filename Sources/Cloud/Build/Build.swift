import Foundation
import ShellOut

public struct Build {
    public func build() async throws {
        if isAmazonLinux() {
            try await buildNative()
        } else {
            try await buildDocker()
        }
    }

    private func buildNative() async throws {
        try await shellOut(
            to: "swift",
            arguments: ["build", "-c", "release"]
        )
    }

    private func buildDocker() async throws {
        try await shellOut(
            to: "docker",
            arguments: [
                "run",
                "--platform", "linux/\(Architecture.current.dockerPlatformString)",
                "--rm",
                "-v", "\(FileManager.default.currentDirectoryPath):/workspace",
                "-w", "/workspace",
                "swift:5.10-amazonlinux2",
                "bash", "-cl", "swift build -c release --static-swift-stdlib",
            ]
        )
    }
}
