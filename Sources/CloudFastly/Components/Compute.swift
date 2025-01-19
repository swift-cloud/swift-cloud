import CloudCore
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
            domains: [any Input<String>],
            backends: [Backend] = [],
            features: Features = .init(),
            options: Resource.Options? = nil,
            context: Context = .current
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

            context.store.build {
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
        public var name: String
        public var address: String
        public var port: Int
        public var overrideHost: String?
        public var sslCertHostname: String?
        public var sslSniHostname: String?
        public var useSsl: Bool?

        public init(
            name: String,
            address: String,
            port: Int = 80,
            overrideHost: String? = nil,
            sslCertHostname: String? = nil,
            sslSniHostname: String? = nil,
            useSsl: Bool? = nil
        ) {
            self.address = address
            self.name = name
            self.overrideHost = overrideHost
            self.port = port
            self.sslCertHostname = sslCertHostname
            self.sslSniHostname = sslSniHostname
            self.useSsl = useSsl
        }

        public init(_ url: URL) {
            let ssl = url.scheme == "https"
            address = url.host ?? ""
            name = url.host ?? ""
            overrideHost = url.host ?? ""
            port = url.port ?? (ssl ? 443 : 80)
            sslCertHostname = ssl ? url.host : nil
            sslSniHostname = ssl ? url.host : nil
            useSsl = ssl
        }

        public init(_ url: String) {
            self.init(URL(string: url)!)
        }
    }
}

extension Fastly.Compute.Backend:
    ExpressibleByStringLiteral, ExpressibleByExtendedGraphemeClusterLiteral, ExpressibleByUnicodeScalarLiteral
{
    public init(stringLiteral value: String) {
        self.init(value)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
}

extension Fastly.Compute.Backend: ExpressibleByStringInterpolation {
    public init(stringInterpolation: StringInterpolation) {
        self.init(stringInterpolation.description)
    }
}
