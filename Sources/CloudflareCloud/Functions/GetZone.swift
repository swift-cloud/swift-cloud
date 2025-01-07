extension Cloudflare {
    public struct GetZone {
        public let accountId: String
        public let id: String
        public let name: String
        public let nameServers: [String]?
        public let paused: Bool
        public let plan: String
        public let status: String
        public let vanityNameServers: [String]?
        public let zoneId: String
    }

    public static func getZone(name: String) -> Output<GetZone> {
        let variable = Variable<GetZone>.invoke(
            name: "\(name)-zone",
            function: "cloudflare:getZone",
            arguments: ["name": name]
        )
        return variable.output
    }

    public static func getZone(zoneId: String) -> Output<GetZone> {
        let variable = Variable<GetZone>.invoke(
            name: "\(zoneId)-zone",
            function: "cloudflare:getZone",
            arguments: ["zoneId": zoneId]
        )
        return variable.output
    }
}
