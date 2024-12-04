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
