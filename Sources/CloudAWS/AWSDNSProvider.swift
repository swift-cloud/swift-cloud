import CloudCore

extension AWS {
    public struct DNS: DNSProvider {
        public let hostedZone: Output<Route53.GetZone>

        public init(zoneName: String) {
            self.hostedZone = AWS.Route53.getZone(name: zoneName)
        }

        public init(zoneId: String) {
            self.hostedZone = AWS.Route53.getZone(id: zoneId)
        }

        public func createRecord(
            type: any Input<String>,
            name: any Input<String>,
            target: any Input<String>,
            ttl: Duration
        ) -> DNSProviderRecord {
            return AWS.DNSRecord(
                zoneId: hostedZone.id,
                type: type,
                name: name,
                ttl: ttl,
                records: [target]
            )
        }
    }

    public static func dns(zoneName: String) -> DNS {
        .init(zoneName: zoneName)
    }
}

extension DNSProvider where Self == AWS.DNS {
    public static func aws(zoneName: String) -> AWS.DNS {
        .init(zoneName: zoneName)
    }
}
