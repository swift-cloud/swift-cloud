extension Vercel {
    public struct DNSRecord: VercelResourceProvider, DNSProviderRecord {
        public let resource: Resource

        public let domain: any Input<String>

        public var fqdn: Output<String> {
            "\(resource.name).\(domain)"
        }

        public init(
            domain: any Input<String>,
            type: DNSRecordType,
            name: any Input<String>,
            value: any Input<String>,
            ttl: Duration = .seconds(60),
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            self.domain = domain
            resource = Resource(
                name: "\(domain)-\(name)-\(type)-record",
                type: "vercel:DnsRecord",
                properties: [
                    "domain": domain,
                    "type": type,
                    "name": Strings.trimSuffix(name, suffix: ".\(domain)").result,
                    "value": value,
                    "ttl": ttl.components.seconds,
                    "comment": "Managed by Swift Cloud",
                ],
                options: options,
                context: context
            )
        }
    }
}
