import CloudCore

extension Builder {
    public func packageForAwsLambda(targetName: String, architecture: Architecture = .current) async throws {
        let releaseDirectory = "\(Context.buildDirectory)/\(architecture.swiftBuildLinuxDirectory)/release"
        let binaryPath = "\(releaseDirectory)/\(targetName)"
        let lambdaDirectory = "\(Context.buildDirectory)/lambda/\(targetName)"
        let bootstrapPath = "\(lambdaDirectory)/bootstrap"
        try? Files.removeDirectory(atPath: lambdaDirectory)
        try? Files.createDirectory(atPath: lambdaDirectory)
        try Files.copyFile(fromPath: binaryPath, toPath: bootstrapPath)
        var zipArguments = [
            "--recurse-paths",
            "--symlinks",
            "package.zip",
            "bootstrap",
        ]
        for (fileName, filePath) in try Files.scanDirectory(atPath: releaseDirectory) {
            guard fileName.hasSuffix("resources") else {
                continue
            }
            try Files.copyFile(fromPath: filePath, toPath: "\(lambdaDirectory)/\(fileName)")
            zipArguments.append(fileName)
        }
        try await shellOut(
            to: "zip",
            arguments: zipArguments,
            workingDirectory: lambdaDirectory
        )
    }
}
