@_exported import Cloud

public enum AWS {}

public protocol AWSProject: Project {}

extension AWSProject {
    public var home: Home.AWS {
        Home.AWS()
    }

    public var providers: [Provider] {
        [.aws()]
    }
}

extension Provider {
    public static func aws(
        accessKey: String = "",
        secretKey: String = "",
        token: String = "",
        profile: String = "",
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
