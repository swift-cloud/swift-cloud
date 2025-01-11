import CloudCore

extension Cloudflare {
    public struct DNS: DNSProvider {
        public let zone: Output<GetZone>

        public let proxyAliasRecords: Bool

        public init(zoneName: String, proxyAliasRecords: Bool = true) {
            self.zone = getZone(name: zoneName)
            self.proxyAliasRecords = proxyAliasRecords
        }

        public func createRecord(
            type: DNSRecordType,
            name: any Input<String>,
            target: any Input<String>,
            ttl: Duration
        ) -> DNSProviderRecord {
            return DNSRecord(
                zoneId: zone.id,
                type: .input(type),
                name: name,
                value: target,
                ttl: ttl
            )
        }

        public func createAlias(
            name: any Input<String>,
            target: any Input<String>,
            ttl: Duration
        ) -> any DNSProviderRecord {
            return DNSRecord(
                zoneId: zone.id,
                type: .cname,
                name: name,
                value: target,
                proxied: proxyAliasRecords,
                ttl: ttl
            )
        }
    }
}

extension DNSProvider where Self == Cloudflare.DNS {
    public static func cloudflare(zoneName: String, proxyAliasRecords: Bool = true) -> Cloudflare.DNS {
        .init(zoneName: zoneName, proxyAliasRecords: proxyAliasRecords)
    }
}
