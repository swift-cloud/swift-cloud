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

        // Copy Content directory if it exists
        let contentDirectory = "\(Context.projectDirectory)/Content"
        if Files.fileExists(atPath: contentDirectory) {
            let lambdaContentDirectory = "\(lambdaDirectory)/Content"
            try Files.createDirectory(atPath: lambdaContentDirectory)
            try Files.copyDirectory(fromPath: contentDirectory, toPath: lambdaContentDirectory)
            zipArguments.append("Content")
        }

        // Copy Public directory if it exists
        let publicDirectory = "\(Context.projectDirectory)/Public"
        if Files.fileExists(atPath: publicDirectory) {
            let lambdaPublicDirectory = "\(lambdaDirectory)/Public"
            try Files.createDirectory(atPath: lambdaPublicDirectory)
            try Files.copyDirectory(fromPath: publicDirectory, toPath: lambdaPublicDirectory)
            zipArguments.append("Public")
        }

        // Copy Output directory if it exists
        let outputDirectory = "\(Context.projectDirectory)/Output"
        if Files.fileExists(atPath: outputDirectory) {
            let lambdaOutputDirectory = "\(lambdaDirectory)/Output"
            try Files.createDirectory(atPath: lambdaOutputDirectory)
            try Files.copyDirectory(fromPath: outputDirectory, toPath: lambdaOutputDirectory)
            zipArguments.append("Output")
        }

        // Copy Resources directory if it exists
        let resourcesDirectory = "\(Context.projectDirectory)/Resources"
        if Files.fileExists(atPath: resourcesDirectory) {
            let lambdaResourcesDirectory = "\(lambdaDirectory)/Resources"
            try Files.createDirectory(atPath: lambdaResourcesDirectory)
            try Files.copyDirectory(fromPath: resourcesDirectory, toPath: lambdaResourcesDirectory)
            zipArguments.append("Resources")
        }

        try await shellOut(
            to: .name("zip"),
            arguments: zipArguments,
            workingDirectory: lambdaDirectory
        )
    }
}
