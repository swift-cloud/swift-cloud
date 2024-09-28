public enum Random {}

extension Random {
    public struct Bytes: ResourceProvider {
        public let resource: Resource

        public var hex: Output<String> {
            resource.output.keyPath("hex")
        }

        public init(
            _ name: String,
            length: Int,
            options: Resource.Options? = nil
        ) {
            resource = Resource(
                name: name,
                type: "random:RandomBytes",
                properties: [
                    "length": length
                ],
                options: options
            )
        }
    }
}
