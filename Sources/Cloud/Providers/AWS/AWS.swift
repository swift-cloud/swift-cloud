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
                name,
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

public struct AWSProvider: Provider {
    public let plugin: Pulumi.Plugin = .aws

    public let configuration: [String: String?]

    public init(
        accessKey: String? = nil,
        secretKey: String? = nil,
        token: String? = nil,
        profile: String? = nil,
        region: String? = nil
    ) {
        configuration = [
            "accessKey": accessKey,
            "secretKey": secretKey,
            "token": token,
            "profile": profile,
            "region": region,
        ]
    }
}

extension Provider {
    public static func aws(
        accessKey: String? = nil,
        secretKey: String? = nil,
        token: String? = nil,
        profile: String? = nil,
        region: String? = nil
    ) -> Self where Self == AWSProvider {
        AWSProvider(
            accessKey: accessKey,
            secretKey: secretKey,
            token: token,
            profile: profile,
            region: region
        )
    }
}
