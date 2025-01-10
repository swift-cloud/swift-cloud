@_exported import CloudCore

public enum DigitalOcean {}

extension Project {

    public func digitalOceanToken(
        options: Resource.Options? = nil
    ) -> String {
        if let provider = options?.provider as? DigitalOcean.Provider, let token = provider.token {
            return token
        }
        if let provider = providers.first(where: { $0.name == "digitalocean" }) {
            if let token = provider.configuration["token"], let value = token {
                return value
            }
        }
        return Context.environment["DIGITALOCEAN_TOKEN"] ?? ""
    }
}
