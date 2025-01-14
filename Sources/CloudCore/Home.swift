import Foundation

public protocol HomeProviderItem: Codable, Sendable {}

public struct HomeProviderPassphrase: HomeProviderItem {
    public let password: String

    fileprivate init() throws {
        self.password = try Data.random(length: 32).hexEncodedString()
    }
}

public protocol HomeProvider: Sendable {
    func bootstrap(with context: Context) async throws

    func passphrase(with context: Context) async throws -> String

    func putItem<T: HomeProviderItem>(_ item: T, fileName: String, with context: Context) async throws

    func getItem<T: HomeProviderItem>(fileName: String, with context: Context) async throws -> T
}

extension HomeProvider {
    public func passphrase(with context: Context) async throws -> String {
        let fileName = "passphrase"
        // First we'll look for a password in the home bucket
        if let password: HomeProviderPassphrase = try? await getItem(fileName: fileName, with: context) {
            return password.password
        }
        // If we don't have a password, we'll generate a new one
        let passphrase = try HomeProviderPassphrase()
        try await putItem(passphrase, fileName: fileName, with: context)
        return passphrase.password
    }
}

extension HomeProvider {
    public func contextualFileName(_ fileName: String, with context: Context) -> String {
        "\(context.name)/\(context.stage)/\(tokenize(fileName)).json"
    }
}

extension HomeProvider {
    private func localStatePath(context: Context) -> String {
        "\(Context.cloudDirectory)/.pulumi/stacks/\(context.name)/\(context.stage).json"
    }

    internal func hasLocalState(context: Context) -> Bool {
        FileManager.default.fileExists(atPath: localStatePath(context: context))
    }

    internal func pullState(context: Context) async throws {
        let state: AnyCodable = try await getItem(fileName: "state", with: context)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(state)
        try Files.createFile(atPath: localStatePath(context: context), contents: data)
    }

    internal func pushState(context: Context) async throws {
        let data = try Files.readFile(atPath: localStatePath(context: context))
        let state = try JSONDecoder().decode(AnyCodable.self, from: data)
        try await putItem(state, fileName: "state", with: context)
    }
}

extension AnyCodable: HomeProviderItem {}
