extension Vercel {
    public struct DNSRecord: VercelResourceProvider, DNSProviderRecord {
        public let resource: Resource

        private let initialName: any Input<String>

        public var fqdn: Output<String> {
            "\(initialName)"
        }

        public init(
            domain: any Input<String>,
            type: DNSRecordType,
            name: any Input<String>,
            value: any Input<String>,
            ttl: Duration = .seconds(60),
            options: Resource.Options? = nil
        ) {
            self.initialName = name
            resource = Resource(
                name: "\(domain)-\(name)-\(type)-record",
                type: "vercel:DnsRecord",
                properties: [
                    "domain": domain,
                    "type": type,
                    "name": name,
                    "value": value,
                    "ttl": ttl.components.seconds,
                    "comment": "Managed by Swift Cloud",
                ],
                options: options
            )
        }
    }
}
