extension Cloudflare {
    public struct DNSRecord: CloudflareResourceProvider, DNSProviderRecord {
        public let resource: Resource

        public var fqdn: Output<String> {
            resource.output.keyPath("hostname")
        }

        public init(
            zoneName: any Input<String>,
            type: DNSRecordType,
            name: any Input<String>,
            value: any Input<String>,
            proxied: Bool = false,
            ttl: Duration = .seconds(60),
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            let zone = getZone(name: zoneName)
            resource = Resource(
                name: "\(zoneName)-\(name)-\(type)-record",
                type: "cloudflare:Record",
                properties: [
                    "zoneId": zone.id,
                    "type": type,
                    "name": Strings.trimSuffix(name, suffix: ".\(zoneName)").result,
                    "content": value,
                    "proxied": proxied,
                    "ttl": proxied ? 1 : ttl.components.seconds,
                    "allowOverwrite": true,
                    "comment": "Managed by Swift Cloud",
                ],
                options: options,
                context: context
            )
        }
    }
}
