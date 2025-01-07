import Foundation
import RegexBuilder

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
            let imageName: String
            switch swiftVersion {
            case "5.10":
                imageName = "swift:5.10-amazonlinux2"
            case "6.0":
                imageName = "swift:6.0-amazonlinux2"
            default:
                fatalError("Unsupported Swift version: \(swiftVersion)")
            }
            try await buildDocker(
                targetName: targetName,
                imageName: imageName,
                flags: "--static-swift-stdlib"
            )
        }
    }

    public func packageForAwsLambda(targetName: String, architecture: Architecture = .current) async throws {
        let releaseDirectory = "\(Context.buildDirectory)/\(architecture.swiftBuildLinuxDirectory)/release"
        let binaryPath = "\(releaseDirectory)/\(targetName)"
        let lambdaDirectory = "\(Context.buildDirectory)/lambda/\(targetName)"
        let bootstrapPath = "\(lambdaDirectory)/bootstrap"
        try? removeDirectory(atPath: lambdaDirectory)
        try? createDirectory(atPath: lambdaDirectory)
        try copyFile(fromPath: binaryPath, toPath: bootstrapPath)
        var zipArguments = [
            "--recurse-paths",
            "--symlinks",
            "package.zip",
            "bootstrap",
        ]
        for (fileName, filePath) in try scanDirectory(atPath: releaseDirectory) {
            guard fileName.hasSuffix("resources") else {
                continue
            }
            try copyFile(fromPath: filePath, toPath: "\(lambdaDirectory)/\(fileName)")
            zipArguments.append(fileName)
        }
        try await shellOut(
            to: "zip",
            arguments: zipArguments,
            workingDirectory: lambdaDirectory
        )
    }
}

extension Builder {
    public func packageForFastly(targetName: String, architecture: Architecture = .current) async throws {
        let releaseDirectory = "\(Context.buildDirectory)/\(architecture.swiftBuildWasmDirectory)/release"
        let binaryPath = "\(releaseDirectory)/\(targetName).wasm"
        let fastlyDirectory = "\(Context.buildDirectory)/fastly/\(targetName)"
        let bootstrapPath = "\(fastlyDirectory)/bin/main.wasm"
        let configPath = "\(fastlyDirectory)/fastly.toml"
        try? removeDirectory(atPath: fastlyDirectory)
        try? createDirectory(atPath: fastlyDirectory)
        try copyFile(fromPath: binaryPath, toPath: bootstrapPath)
        try createFile(atPath: configPath, contents: "manifest_version = 2\nlanguage = \"swift\"\n")
        let zipArguments = [
            "--recurse-paths",
            "--symlinks",
            "package.zip",
            "bin/main.wasm",
            "fastly.toml",
        ]
        try await shellOut(
            to: "zip",
            arguments: zipArguments,
            workingDirectory: fastlyDirectory
        )
    }
}

extension Builder {
    public func buildWasm(targetName: String) async throws {
        let swiftVersion = try await currentSwiftVersion()
        let imageName: String
        switch swiftVersion {
        case "5.10":
            imageName = "ghcr.io/swiftwasm/swift:5.10-focal"
        default:
            fatalError("Unsupported Swift version: \(swiftVersion)")
        }
        try await buildDocker(
            targetName: targetName,
            imageName: imageName,
            flags: "--triple wasm32-unknown-wasi"
        )
    }
}

extension Builder {
    private func buildNative(targetName: String, flags: String) async throws {
        let spinner = UI.spinner(label: #"Building target "\#(targetName)""#)
        defer { spinner.stop() }

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
        let spinner = UI.spinner(label: #"Building target "\#(targetName)""#)
        defer { spinner.stop() }

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
            ],
            onEvent: { spinner.push($0.string()) }
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
