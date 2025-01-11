extension AWS {
    public enum Route53 {
        public struct GetZone {
            public let arn: String
            public let id: String
        }

        public static func getZone(name: String) -> Output<GetZone> {
            let variable = Variable<GetZone>.invoke(
                name: "\(name)-zone",
                function: "aws:route53:getZone",
                arguments: ["name": name]
            )
            return variable.output
        }

        public static func getZone(id: String) -> Output<GetZone> {
            let variable = Variable<GetZone>.invoke(
                name: "\(id)-zone",
                function: "aws:route53:getZone",
                arguments: ["zoneId": id]
            )
            return variable.output
        }
    }
}
