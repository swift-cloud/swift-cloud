extension Vercel {
    public struct Project: VercelResourceProvider {
        public let resource: Resource

        public init(
            _ name: String,
            teamId: String? = nil,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            resource = Resource(
                name: name,
                type: "vercel:Project",
                properties: [
                    "teamId": teamId,
                    "outputDirectory": ".cloud/.vercel",
                    "prioritiseProductionBuilds": true,
                ],
                options: options,
                context: context
            )
        }
    }
}
