import Foundation

public struct LocalHome: Home {
    public func bootstrap(with context: Context) async throws {}

    public func passphrase(with context: Context) async throws -> String {
        return "passphrase"
    }

    public func putItem<T: Codable>(_ data: T, fileName: String, with context: Context) async throws {
        let path = dataFilePath(fileName, with: context)
        let data = try JSONEncoder().encode(data)
        try createFile(atPath: path, contents: data)
    }

    public func getItem<T: Codable>(fileName: String, with context: Context) async throws -> T {
        let path = dataFilePath(fileName, with: context)
        let data = try readFile(atPath: path)
        return try JSONDecoder().decode(T.self, from: data)
    }

    private func dataFilePath(_ fileName: String, with context: Context) -> String {
        let stage = context.stage
        return "\(Context.userCloudDirectory)/projects/\(context.qualifiedName)/\(stage)/\(tokenize(fileName)).json"
    }
}

extension Home {
    public static func local() -> Self where Self == LocalHome {
        return LocalHome()
    }
}
