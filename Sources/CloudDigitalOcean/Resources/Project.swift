extension DigitalOcean {
    public struct Project: DigitalOceanResourceProvider {
        public let resource: Resource

        public init(
            _ name: String,
            environment: Environment? = nil,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            let environment = environment ?? (context.isProduction ? .production : .development)
            self.resource = .init(
                name: name,
                type: "digitalocean:Project",
                properties: [
                    "name": tokenize(context.stage, name),
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
