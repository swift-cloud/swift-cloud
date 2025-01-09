extension DigitalOcean {
    public struct Project: DigitalOceanResourceProvider {
        public let resource: Resource

        public init(
            _ name: String,
            environment: Environment = Context.current.isProduction ? .production : .development,
            options: Resource.Options? = nil
        ) {
            self.resource = .init(
                name: name,
                type: "digitalocean:Project",
                properties: [
                    "environment": environment.rawValue,
                    "description": "Managed by Swift Cloud",
                ],
                options: options
            )
        }
    }
}

extension DigitalOcean.Project {
    public enum Environment: String {
        case development = "Development"
        case staging = "Staging"
        case production = "Production"
    }
}
