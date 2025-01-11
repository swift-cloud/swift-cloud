import CloudCore

extension Vercel {
    public struct DNS: DNSProvider {
        public let domain: String

        public init(domain: String) {
            self.domain = domain
        }

        public func createRecord(
            type: DNSRecordType,
            name: any Input<String>,
            target: any Input<String>,
            ttl: Duration
        ) -> DNSProviderRecord {
            return Vercel.DNSRecord(
                domain: domain,
                type: type,
                name: name,
                value: target,
                ttl: ttl
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

extension DNSProvider where Self == Vercel.DNS {
    public static func vercel(domain: String) -> Vercel.DNS {
        .init(domain: domain)
    }
}
