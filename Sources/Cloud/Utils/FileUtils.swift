import Foundation

func currentDirectoryPath() -> String {
    FileManager.default.currentDirectoryPath
}

func userHomeDirectoryPath() -> String {
    FileManager.default.homeDirectoryForCurrentUser.path
}

func createDirectory(atPath path: String, withIntermediateDirectories: Bool = true) throws {
    try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: withIntermediateDirectories)
}

func readFile(atPath path: String) throws -> Data {
    let url = URL(fileURLWithPath: path)
    return try Data(contentsOf: url)
}

func createFile(
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

func createFile(
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

func copyFile(fromPath: String, toPath: String) throws {
    try FileManager.default.copyItem(atPath: fromPath, toPath: toPath)
}

func removeFile(atPath path: String) throws {
    try FileManager.default.removeItem(atPath: path)
}

func fileExists(atPath path: String) -> Bool {
    FileManager.default.fileExists(atPath: path)
}

func removeDirectory(atPath path: String) throws {
    try FileManager.default.removeItem(atPath: path)
}

func scanDirectory(atPath path: String) throws -> [(name: String, path: String)] {
    try FileManager.default.contentsOfDirectory(atPath: path).map { name in
        (name: name, path: "\(path)/\(name)")
    }
}

func currentEnvironment() -> [String: String] {
    var environment = ProcessInfo.processInfo.environment
    for (key, value) in readEnvironmentFile() {
        environment[key] = value
    }
    return environment
}

func readEnvironmentFile() -> [String: String] {
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

func parseEnvironmentFile(_ envFileContent: String) -> [String: String] {
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
