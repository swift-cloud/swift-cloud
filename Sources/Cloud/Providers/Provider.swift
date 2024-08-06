public enum aws {}
public enum azure {}
public enum cloudflare {}
public enum digitalocean {}
public enum fastly {}
public enum gcp {}
public enum heroku {}
public enum planetscale {}
public enum vercel {}

public struct Provider: Sendable {
    let plugin: Pulumi.Plugin
    let configuration: [String: String]
    let dependencies: [Pulumi.Plugin]

    public init(
        plugin: Pulumi.Plugin,
        configuration: [String: String],
        dependencies: [Pulumi.Plugin] = []
    ) {
        self.plugin = plugin
        self.configuration = configuration
        self.dependencies = dependencies
    }
}

extension Provider {
    public var name: String {
        plugin.name
    }
}
