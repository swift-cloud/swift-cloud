import CloudCore

private let vercelAppDomain = "vercel.app"

extension Vercel {
    public struct DNS: DNSProvider {
        public let domain: String

        public let teamId: String?

        public init(domain: String, teamId: String? = nil) {
            self.teamId = teamId ?? Context.environment["VERCEL_TEAM_ID"]
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
                ttl: ttl,
                teamId: teamId
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
    public static func vercel(domain: String, teamId: String? = nil) -> Vercel.DNS {
        .init(domain: domain, teamId: teamId)
    }

    public static func vercelDotApp() -> Vercel.DNS {
        .init(domain: vercelAppDomain)
    }
}
