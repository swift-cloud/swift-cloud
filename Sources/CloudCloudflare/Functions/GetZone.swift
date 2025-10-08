extension Cloudflare {
    public struct GetZone {
        public let account: GetZoneAccount
        public let activatedOn: String
        public let cnameSuffix: String
        public let createdOn: String
        public let developmentMode: Int
        public let id: String
        public let meta: GetZoneMeta
        public let modifiedOn: String
        public let name: String
        public let nameServers: [String]
        public let originalDnshost: String
        public let originalNameServers: [String]
        public let originalRegistrar: String
        public let owner: GetZoneOwner
        public let paused: Bool
        public let status: String
        public let tenant: GetZoneTenant
        public let tenantUnit: GetZoneTenantUnit
        public let type: String
        public let vanityNameServers: [String]
        public let verificationKey: String
        public let zoneId: String?
    }

    public struct GetZoneAccount {
        public let id: String
        public let name: String
    }

    public struct GetZoneMeta {
        public let cdnOnly: Bool
        public let customCertificateQuota: Int
        public let dnsOnly: Bool
        public let foundationDns: Bool
        public let pageRuleQuota: Int
        public let phishingDetected: Bool
        public let step: Int
    }

    public struct GetZoneOwner {
        public let id: String
        public let name: String
        public let type: String
    }

    public struct GetZoneTenant {
        public let id: String
        public let name: String
    }

    public struct GetZoneTenantUnit {
        public let id: String
    }

    public static func getZone(name: any Input<String>) -> Output<GetZone> {
        let variable = Variable<GetZone>.invoke(
            name: "\(name)-zone",
            function: "cloudflare:getZone",
            arguments: [
                "filter": [
                    "match": "all",
                    "name": name,
                ]
            ]
        )
        return variable.output
    }

    public static func getZone(zoneId: any Input<String>) -> Output<GetZone> {
        let variable = Variable<GetZone>.invoke(
            name: "\(zoneId)-zone",
            function: "cloudflare:getZone",
            arguments: [
                "zoneId": zoneId
            ]
        )
        return variable.output
    }
}
