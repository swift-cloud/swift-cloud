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
                    "accessKey": accessKey?.encodable(),
                    "secretKey": secretKey?.encodable(),
                    "token": token?.encodable(),
                    "profile": profile?.encodable(),
                    "region": region?.encodable(),
                ]
            )
        }
    }
}
