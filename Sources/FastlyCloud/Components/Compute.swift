import Cloud
import Foundation

extension Fastly {
    public struct Compute: FastlyComponent {
        public let service: Resource

        public var name: Output<String> {
            service.name
        }

        public init(
            _ name: String,
            targetName: String,
            domains: [CustomStringConvertible],
            backends: [Backend] = [],
            features: Features = .init(),
            options: Resource.Options? = nil
        ) {
            let filename = "\(Context.buildDirectory)/fastly/\(targetName)/package.tar.gz"

            service = Resource(
                name: name,
                type: "fastly:ServiceCompute",
                properties: [
                    "activate": true,
                    "backends": backends.map { AnyEncodable($0) },
                    "domains": domains.map {
                        ["name": $0.description]
                    },
                    "package": [
                        "filename": filename,
                        "sourceCodeHash": getPackageHash(filename: filename).hash,
                    ],
                    "productEnablement": .init(features),
                ],
                options: options
            )

            Context.current.store.build {
                try await $0.builder.buildWasm(targetName: targetName)
                try await $0.builder.packageForFastly(targetName: targetName)
            }
        }
    }
}

extension Fastly.Compute {
    public struct Features: Encodable {
        public var fanout: Bool = false
        public var websockets: Bool = false
        public var logExplorerInsights: Bool = false

        public init(
            fanout: Bool = false,
            websockets: Bool = false,
            logExplorerInsights: Bool = false
        ) {
            self.fanout = fanout
            self.websockets = websockets
            self.logExplorerInsights = logExplorerInsights
        }
    }
}

extension Fastly.Compute {
    public struct Backend: Encodable {
        public var address: String
        public var name: String
        public var overrideHost: String
        public var port: Int
        public var sslSniHostname: String?
        public var useSsl: Bool

        public init(_ url: URL) {
            let ssl = url.scheme == "https"
            address = url.host ?? ""
            name = url.host ?? ""
            overrideHost = url.host ?? ""
            port = url.port ?? (ssl ? 443 : 80)
            sslSniHostname = ssl ? url.host : nil
            useSsl = ssl
        }

        public init(_ url: String) {
            self.init(URL(string: url)!)
        }
    }
}
