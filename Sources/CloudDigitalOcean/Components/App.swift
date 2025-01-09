import CloudCore
import Foundation

extension DigitalOcean {
    public struct App: DigitalOceanComponent {
        public let service: Resource

        public var name: Output<String> {
            service.name
        }

        public init(
            _ name: String,
            options: Resource.Options? = nil
        ) {
            service = Resource(
                name: name,
                type: "digitalocean:App",
                properties: [:],
                options: options
            )
        }
    }
}
