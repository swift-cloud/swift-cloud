import Foundation

public enum Home {}

public protocol HomeProviderItem: Codable, Sendable {}

public protocol HomeProvider: Sendable {
    func bootstrap(with context: Context) async throws

    func passphrase(with context: Context) async throws -> String

    func putItem<T: HomeProviderItem>(_ item: T, fileName: String, with context: Context) async throws

    func getItem<T: HomeProviderItem>(fileName: String, with context: Context) async throws -> T
}

extension HomeProvider {
    public func contextualFileName(_ fileName: String, with context: Context) -> String {
        "\(context.qualifiedName)/\(context.stage)/\(tokenize(fileName)).json"
    }
}

extension HomeProvider {
    private func localStatePath(context: Context) -> String {
        "\(Context.cloudDirectory)/.pulumi/stacks/\(context.qualifiedName)/\(context.stage).json"
    }

    internal func hasLocalState(context: Context) -> Bool {
        FileManager.default.fileExists(atPath: localStatePath(context: context))
    }

    internal func restoreLocalState(context: Context) async throws {
        let state: AnyCodable = try await getItem(fileName: "state", with: context)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(state)
        try createFile(atPath: localStatePath(context: context), contents: data)
    }

    internal func saveLocalState(context: Context) async throws {
        let data = try readFile(atPath: localStatePath(context: context))
        let state = try JSONDecoder().decode(AnyCodable.self, from: data)
        try await putItem(state, fileName: "state", with: context)
    }
}

extension AnyCodable: HomeProviderItem {}
