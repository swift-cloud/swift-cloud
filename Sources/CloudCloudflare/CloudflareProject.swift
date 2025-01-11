import CloudCore

public protocol CloudflareProject: Project {
    var accountId: String { get }

    var apiToken: String? { get }
}

extension CloudflareProject {
    public var home: any HomeProvider {
        guard let apiToken = apiToken ?? Context.environment["CLOUDFLARE_API_TOKEN"] else {
            fatalError("Missing Cloudflare API token")
        }
        return .cloudflare(accountId: accountId, apiToken: apiToken)
    }

    public var apiToken: String? {
        nil
    }

    public var providers: [Provider] {
        [.cloudflare(apiToken: apiToken)]
    }
}
