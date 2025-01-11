import AsyncHTTPClient
import CloudCore
import Foundation

extension Cloudflare {
    public final class Home: HomeProvider {
        public let accountId: String

        private let apiToken: String

        private let client: HTTPClient

        private let namespaceName = "swift-cloud-assets"

        private var baseURL: String {
            "https://api.cloudflare.com/client/v4/accounts/\(accountId)"
        }

        public init(accountId: String, apiToken: String) {
            self.accountId = accountId
            self.apiToken = apiToken
            self.client = .shared
        }

        public func bootstrap(with context: Context) async throws {
            _ = try await upsertNamespace()
        }

        public func putItem<T: HomeProviderItem>(_ item: T, fileName: String, with context: Context) async throws {
            let namespace = try await upsertNamespace().id
            let value = NamespaceValue(value: item)
            let key = contextualFileName(fileName, with: context)
            var request = HTTPClientRequest(
                url: "\(baseURL)/storage/kv/namespaces/\(namespace)/values/\(key)"
            )
            request.method = .PUT
            request.headers.add(name: "Content-Type", value: "application/json")
            request.headers.add(name: "Authorization", value: "Bearer \(apiToken)")
            request.body = try .bytes(try JSONEncoder().encode(value))
            _ = try await client.execute(request, timeout: .seconds(10))
        }

        public func getItem<T: HomeProviderItem>(fileName: String, with context: Context) async throws -> T {
            let namespace = try await upsertNamespace().id
            let key = contextualFileName(fileName, with: context)
            var request = HTTPClientRequest(
                url: "\(baseURL)/storage/kv/namespaces/\(namespace)/values/\(key)"
            )
            request.method = .GET
            request.headers.add(name: "Authorization", value: "Bearer \(apiToken)")
            let response = try await client.execute(request, timeout: .seconds(10))
            let bytes = try await response.body.collect(upTo: 1024 * 1024)
            return try JSONDecoder().decode(NamespaceValue<T>.self, from: bytes).value
        }
    }
}

extension Cloudflare.Home {
    private struct APIResponse<T: Decodable>: Decodable {
        let success: Bool
        let result: T
    }
}

extension Cloudflare.Home {
    private struct Namespace: Decodable {
        let id: String
        let title: String
    }

    private struct NamespaceValue<T: Codable>: Codable {
        let value: T
    }

    private func upsertNamespace() async throws -> Namespace {
        let namespaces = try await listNamespaces().result
        if let namespace = namespaces.first(where: { $0.title == namespaceName }) {
            return namespace
        } else {
            return try await createNamespace().result
        }
    }

    private func createNamespace() async throws -> APIResponse<Namespace> {
        var request = HTTPClientRequest(
            url: "\(baseURL)/storage/kv/namespaces"
        )
        request.method = .POST
        request.headers.add(name: "Content-Type", value: "application/json")
        request.headers.add(name: "Authorization", value: "Bearer \(apiToken)")
        request.body = try .bytes(JSONEncoder().encode(["title": namespaceName]))
        let response = try await client.execute(request, timeout: .seconds(10))
        let bytes = try await response.body.collect(upTo: 1024 * 1024)
        return try JSONDecoder().decode(APIResponse<Namespace>.self, from: bytes)
    }

    private func listNamespaces() async throws -> APIResponse<[Namespace]> {
        var request = HTTPClientRequest(
            url: "\(baseURL)/storage/kv/namespaces"
        )
        request.method = .GET
        request.headers.add(name: "Authorization", value: "Bearer \(apiToken)")
        let response = try await client.execute(request, timeout: .seconds(10))
        let bytes = try await response.body.collect(upTo: 1024 * 1024)
        return try JSONDecoder().decode(APIResponse<[Namespace]>.self, from: bytes)
    }
}

extension HomeProvider where Self == Cloudflare.Home {
    public static func cloudflare(accountId: String, apiToken: String) -> Self {
        .init(accountId: accountId, apiToken: apiToken)
    }
}
