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

    public static func dns(zoneName: String) -> DNS {
        .init(zoneName: zoneName)
    }
}
