import Foundation

public struct LocalHome: Home {
    public func bootstrap(with context: Context) async throws {}

    public func passphrase(with context: Context) async throws -> String {
        return "passphrase"
    }

    public func putData(_ data: Data, fileName: String, with context: Context) async throws {
        let path = dataFilePath(fileName, with: context)
        try createFile(atPath: path, contents: data)
    }

    public func getData(fileName: String, with context: Context) async throws -> Data {
        let path = dataFilePath(fileName, with: context)
        return try readFile(atPath: path)
    }

    private func dataFilePath(_ fileName: String, with context: Context) -> String {
        return "\(Context.cloudDirectory)/data/\(slugify(context.project.name))/\(slugify(fileName)).json"
    }
}

extension Home {
    public static func local() -> Self where Self == LocalHome {
        return LocalHome()
    }
}
