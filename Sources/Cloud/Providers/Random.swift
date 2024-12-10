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

extension Random {
    public struct Text: ResourceProvider {
        public let resource: Resource

        public var value: Output<String> {
            resource.output.keyPath("result")
        }

        public init(
            _ name: String,
            length: Int,
            numerics: Bool = false,
            specialCharacters: Bool = false,
            options: Resource.Options? = nil
        ) {
            resource = Resource(
                name: name,
                type: "random:RandomString",
                properties: [
                    "length": length,
                    "numeric": numerics,
                    "special": specialCharacters,
                ],
                options: options
            )
        }
    }
}
