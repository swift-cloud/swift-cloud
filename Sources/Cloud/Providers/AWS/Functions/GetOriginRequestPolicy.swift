extension AWS {
    public struct GetOriginRequestPolicy {
        public let id: String
        public let etag: String
        public let name: String
    }

    public static func getOriginRequestPolicy(name: String) -> Output<GetOriginRequestPolicy> {
        let variable = Variable<GetOriginRequestPolicy>.function(
            name: "\(name)-origin-request-policy",
            function: "aws:cloudfront:getOriginRequestPolicy",
            arguments: [
                "name": name
            ]
        )
        return variable.output
    }
}
