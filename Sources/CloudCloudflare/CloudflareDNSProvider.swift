import CloudCore

extension Cloudflare {
    public struct DNS: DNSProvider {
        public let zone: Output<GetZone>

        public init(zoneName: String) {
            self.zone = getZone(name: zoneName)
        }

        public func createRecord(
            type: any Input<String>,
            name: any Input<String>,
            target: any Input<String>,
            ttl: Duration
        ) -> DNSProviderRecord {
            return DNSRecord(
                zoneId: zone.id,
                type: .init(rawValue: type.description)!,
                name: name,
                value: target,
                ttl: ttl
            )
        }
    }
}

extension DNSProvider where Self == Cloudflare.DNS {
    public static func cloudflare(zoneName: String) -> Cloudflare.DNS {
        .init(zoneName: zoneName)
    }
}
