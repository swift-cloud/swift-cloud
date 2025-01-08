import Foundation

public enum Files {
    public static func currentDirectoryPath() -> String {
        FileManager.default.currentDirectoryPath
    }

    public static func userHomeDirectoryPath() -> String {
        FileManager.default.homeDirectoryForCurrentUser.path
    }

    public static func createDirectory(atPath path: String, withIntermediateDirectories: Bool = true) throws {
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: withIntermediateDirectories)
    }

    public static func readFile(atPath path: String) throws -> Data {
        let url = URL(fileURLWithPath: path)
        return try Data(contentsOf: url)
    }

    public static func createFile(
        atPath path: String,
        contents: Data?,
        withIntermediateDirectories: Bool = true
    ) throws {
        if withIntermediateDirectories {
            let directoryPath = path.components(separatedBy: "/").dropLast().joined(separator: "/")
            try createDirectory(atPath: directoryPath, withIntermediateDirectories: true)
        }
        let url = URL(fileURLWithPath: path)
        try contents?.write(to: url)
    }

    public static func createFile(
        atPath path: String,
        contents: String,
        withIntermediateDirectories: Bool = true
    ) throws {
        try createFile(
            atPath: path,
            contents: contents.data(using: .utf8),
            withIntermediateDirectories: withIntermediateDirectories
        )
    }

    public static func copyFile(fromPath: String, toPath: String) throws {
        try FileManager.default.copyItem(atPath: fromPath, toPath: toPath)
    }

    public static func removeFile(atPath path: String) throws {
        try FileManager.default.removeItem(atPath: path)
    }

    public static func fileExists(atPath path: String) -> Bool {
        FileManager.default.fileExists(atPath: path)
    }

    public static func removeDirectory(atPath path: String) throws {
        try FileManager.default.removeItem(atPath: path)
    }

    public static func scanDirectory(atPath path: String) throws -> [(name: String, path: String)] {
        try FileManager.default.contentsOfDirectory(atPath: path).map { name in
            (name: name, path: "\(path)/\(name)")
        }
    }

    public static func currentEnvironment() -> [String: String] {
        var environment = ProcessInfo.processInfo.environment
        for (key, value) in readEnvironmentFile() {
            environment[key] = value
        }
        return environment
    }

    public static func readEnvironmentFile() -> [String: String] {
        if let data = try? readFile(atPath: "\(currentDirectoryPath())/.env") {
            let input = String(data: data, encoding: .utf8) ?? ""
            return parseEnvironmentFile(input)
        }
        if let data = try? readFile(atPath: "\(currentDirectoryPath())/.env.local") {
            let input = String(data: data, encoding: .utf8) ?? ""
            return parseEnvironmentFile(input)
        }
        return [:]
    }

    public static func parseEnvironmentFile(_ envFileContent: String) -> [String: String] {
        var result: [String: String] = [:]

        // Split the file content into lines
        let lines = envFileContent.split(separator: "\n")

        for line in lines {
            // Trim whitespace and ignore empty lines or comments
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedLine.isEmpty, !trimmedLine.hasPrefix("#") else { continue }

            // Split by the first '=' into key and value
            let components = trimmedLine.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
            guard components.count == 2 else { continue }

            let key = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
            var value = components[1].trimmingCharacters(in: .whitespacesAndNewlines)

            // Check if the value is wrapped in quotes
            if value.hasPrefix("\"") && value.hasSuffix("\"") && value.count >= 2 {
                value = String(value.dropFirst().dropLast())
            }

            // Add key-value pair to the result dictionary
            result[key] = value
        }

        return result
    }
}
