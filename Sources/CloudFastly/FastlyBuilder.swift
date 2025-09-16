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
                language = "swift"
                name = "\(targetName)"
                description = "Managed by Swift Cloud"
                """
        )
        try Files.copyFile(fromPath: binaryPath, toPath: bootstrapPath)
        try await shellOut(
            to: .path("/usr/bin/tar"),
            arguments: [
                "-czf",
                "package.tar.gz",
                "package/bin/main.wasm",
                "package/fastly.toml",
            ],
            workingDirectory: fastlyDirectory
        )
    }
}
