extension Random {
    public struct Bytes: ResourceProvider {
        public let resource: Resource

        public var hex: String {
            resource.keyPath("hex")
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
