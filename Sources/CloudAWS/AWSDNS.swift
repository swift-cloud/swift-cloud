import CloudCore

extension AWS {
    public struct DNS: DNSProvider {
        public let zoneName: any Input<String>

        public init(zoneName: any Input<String>) {
            self.zoneName = zoneName
        }

        public func createRecord(
            type: DNSRecordType,
            name: any Input<String>,
            target: any Input<String>,
            ttl: Duration
        ) -> DNSProviderRecord {
            return AWS.DNSRecord(
                zoneName: zoneName,
                type: type,
                name: name,
                ttl: ttl,
                records: [target]
            )
        }

        public func createAlias(
            name: any Input<String>,
            target: any Input<String>,
            ttl: Duration
        ) -> DNSProviderRecord {
            return createRecord(type: .cname, name: name, target: target, ttl: ttl)
        }
    }
}

extension DNSProvider where Self == AWS.DNS {
    public static func aws(zoneName: any Input<String>) -> AWS.DNS {
        .init(zoneName: zoneName)
    }
}
