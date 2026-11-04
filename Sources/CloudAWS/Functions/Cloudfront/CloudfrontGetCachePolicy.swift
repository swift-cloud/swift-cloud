extension AWS.Cloudfront {
    public struct GetCachePolicy {
        public let id: String
        public let etag: String
        public let name: String
    }

    /// Looks up a cache policy by name, like the managed `Managed-CachingOptimized`.
    public static func getCachePolicy(name: String) -> Output<GetCachePolicy> {
        let variable = Variable<GetCachePolicy>.invoke(
            name: "\(name)-cache-policy",
            function: "aws:cloudfront:getCachePolicy",
            arguments: [
                "name": name
            ]
        )
        return variable.output
    }
}
