public enum aws {}
public enum azure {}
public enum cloudflare {}
public enum digitalocean {}
public enum fastly {}
public enum gcp {}
public enum planetscale {}
public enum vercel {}

public protocol Provider: Sendable {
    var plugin: Pulumi.Plugin { get }

    var configuration: [String: String?] { get }
}

extension Provider {
    public var name: String {
        plugin.name
    }
}
