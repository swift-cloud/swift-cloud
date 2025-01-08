import CloudCore

extension Provider {
    public static func aws(
        accessKey: String? = nil,
        secretKey: String? = nil,
        token: String? = nil,
        profile: String? = nil,
        region: String = "us-east-1"
    ) -> Self {
        .init(
            plugin: .aws,
            configuration: [
                "accessKey": accessKey,
                "secretKey": secretKey,
                "token": token,
                "profile": profile,
                "region": region,
            ],
            dependencies: [.awsx]
        )
    }
}

extension AWS {
    public struct Provider: ResourceProvider {
        public let resource: Resource

        public init(
            _ name: String,
            accessKey: String? = nil,
            secretKey: String? = nil,
            token: String? = nil,
            profile: String? = nil,
            region: String = "us-east-1"
        ) {
            resource = Resource(
                name: name,
                type: "pulumi:providers:aws",
                properties: [
                    "accessKey": accessKey,
                    "secretKey": secretKey,
                    "token": token,
                    "profile": profile,
                    "region": region,
                ]
            )
        }
    }
}

extension Context {
    public var region: String {
        guard let project = project as? any AWSProject else {
            fatalError("Project definition does not conform to AWSProject")
        }
        return project.region
    }
}
