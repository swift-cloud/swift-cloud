import Foundation

public func currentDirectoryPath() -> String {
    FileManager.default.currentDirectoryPath
}

public func userHomeDirectoryPath() -> String {
    FileManager.default.homeDirectoryForCurrentUser.path
}

public func createDirectory(atPath path: String, withIntermediateDirectories: Bool = true) throws {
    try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: withIntermediateDirectories)
}

public func readFile(atPath path: String) throws -> Data {
    let url = URL(fileURLWithPath: path)
    return try Data(contentsOf: url)
}

public func createFile(
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

public func createFile(
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

public func copyFile(fromPath: String, toPath: String) throws {
    try FileManager.default.copyItem(atPath: fromPath, toPath: toPath)
}

public func removeFile(atPath path: String) throws {
    try FileManager.default.removeItem(atPath: path)
}

public func fileExists(atPath path: String) -> Bool {
    FileManager.default.fileExists(atPath: path)
}
