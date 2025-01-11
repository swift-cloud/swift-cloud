extension Cloudflare {
    public struct DNSRecord: CloudflareResourceProvider, DNSProviderRecord {
        public let resource: Resource

        public var fqdn: Output<String> {
            resource.output.keyPath("hostname")
        }

        public init(
            zoneId: any Input<String>,
            type: DNSRecordType,
            name: any Input<String>,
            value: any Input<String>,
            proxied: Bool = false,
            ttl: Duration = .seconds(60),
            options: Resource.Options? = nil
        ) {
            resource = Resource(
                name: "\(zoneId)-\(name)-record",
                type: "cloudflare:Record",
                properties: [
                    "zoneId": zoneId,
                    "type": type,
                    "name": name,
                    "content": value,
                    "proxied": proxied,
                    "ttl": proxied ? 1 : ttl.components.seconds,
                    "allowOverwrite": true,
                    "comment": "Managed by Swift Cloud",
                ],
                options: options
            )
        }
    }
}
