import Foundation

public struct LocalHome: HomeProvider {
    public init() {}

    public func bootstrap(with context: Context) async throws {}

    public func putItem<T: HomeProviderItem>(_ item: T, fileName: String, with context: Context) async throws {
        let path = dataFilePath(fileName, with: context)
        let data = try JSONEncoder().encode(item)
        try Files.createFile(atPath: path, contents: data)
    }

    public func getItem<T: HomeProviderItem>(fileName: String, with context: Context) async throws -> T {
        let path = dataFilePath(fileName, with: context)
        let data = try Files.readFile(atPath: path)
        return try JSONDecoder().decode(T.self, from: data)
    }

    private func dataFilePath(_ fileName: String, with context: Context) -> String {
        "\(Context.userCloudDirectory)/projects/\(contextualFileName(fileName, with: context))"
    }
}

extension HomeProvider where Self == LocalHome {
    public static func local() -> Self {
        LocalHome()
    }
}
