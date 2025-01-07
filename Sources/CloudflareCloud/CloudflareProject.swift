import Cloud

public protocol CloudflareProject: Project {}

extension CloudflareProject {
    public var providers: [Provider] {
        [.cloudflare()]
    }
}
