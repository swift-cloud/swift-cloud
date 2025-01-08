import CloudCore

extension Builder {
    public func packageForFastly(targetName: String, architecture: Architecture = .current) async throws {
        let releaseDirectory = "\(Context.buildDirectory)/\(architecture.swiftBuildWasmDirectory)/release"
        let binaryPath = "\(releaseDirectory)/\(targetName).wasm"
        let fastlyDirectory = "\(Context.buildDirectory)/fastly/\(targetName)"
        let bootstrapPath = "\(fastlyDirectory)/package/bin/main.wasm"
        let configPath = "\(fastlyDirectory)/package/fastly.toml"
        try? Files.removeDirectory(atPath: fastlyDirectory)
        try? Files.createDirectory(atPath: "\(fastlyDirectory)/package/bin")
        try Files.createFile(
            atPath: configPath,
            contents:
                """
                manifest_version = 2
                description = "Managed by Swift Cloud"
                language = "swift"
                """
        )
        try Files.copyFile(fromPath: binaryPath, toPath: bootstrapPath)
        let zipArguments = [
            "-czf",
            "package.tar.gz",
            "package/bin/main.wasm",
            "package/fastly.toml",
        ]
        try await shellOut(
            to: "tar",
            arguments: zipArguments,
            workingDirectory: fastlyDirectory
        )
    }
}
