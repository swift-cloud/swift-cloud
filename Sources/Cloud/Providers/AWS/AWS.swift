extension Provider {
    public static func aws(
        accessKey: String = "",
        secretKey: String = "",
        token: String = "",
        profile: String = "",
        region: String = ""
    ) -> Self {
        .init(
            plugin: .aws,
            configuration: [
                "accessKey": accessKey,
                "secretKey": secretKey,
                "token": token,
                "profile": profile,
                "region": region,
            ]
        )
    }
}

extension aws {
    public struct Provider: ResourceProvider {
        public let resource: Resource

        public init(
            _ name: String,
            accessKey: String? = nil,
            secretKey: String? = nil,
            token: String? = nil,
            profile: String? = nil,
            region: String? = nil
        ) {
            resource = Resource(
                name: name,
                type: "pulumi:providers:aws",
                properties: [
                    "accessKey": .init(accessKey),
                    "secretKey": .init(secretKey),
                    "token": .init(token),
                    "profile": .init(profile),
                    "region": .init(region),
                ]
            )
        }
    }
}
