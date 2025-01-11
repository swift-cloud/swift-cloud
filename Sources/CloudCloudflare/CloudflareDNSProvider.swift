import CloudCore

extension Cloudflare {
    public struct DNS: DNSProvider {
        public let zoneName: any Input<String>

        public let proxyAliasRecords: Bool

        public init(zoneName: any Input<String>, proxyAliasRecords: Bool = true) {
            self.zoneName = zoneName
            self.proxyAliasRecords = proxyAliasRecords
        }

        public func createRecord(
            type: DNSRecordType,
            name: any Input<String>,
            target: any Input<String>,
            ttl: Duration
        ) -> DNSProviderRecord {
            return DNSRecord(
                zoneName: zoneName,
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
                zoneName: zoneName,
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
    public static func cloudflare(
        zoneName: any Input<String>,
        proxyAliasRecords: Bool = true
    ) -> Cloudflare.DNS {
        .init(zoneName: zoneName, proxyAliasRecords: proxyAliasRecords)
    }
}
