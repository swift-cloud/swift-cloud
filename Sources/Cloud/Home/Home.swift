import Foundation

public protocol Home: Sendable {
    func bootstrap(with context: Context) async throws

    func passphrase(with context: Context) async throws -> String

    func putData(_ data: Data, fileName: String, with context: Context) async throws

    func getData(fileName: String, with context: Context) async throws -> Data
}
