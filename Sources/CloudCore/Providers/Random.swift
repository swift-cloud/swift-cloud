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
        public enum Casing {
            case lower
            case upper
        }

        public let resource: Resource

        public var value: Output<String> {
            resource.output.keyPath("result")
        }

        public init(
            _ name: String,
            length: Int,
            casing: [Casing] = [.lower, .upper],
            numerics: Bool = false,
            specialCharacters: Bool = false,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            resource = Resource(
                name: name,
                type: "random:RandomString",
                properties: [
                    "length": length,
                    "lower": casing.contains(.lower),
                    "upper": casing.contains(.upper),
                    "numeric": numerics,
                    "special": specialCharacters,
                ],
                options: options,
                context: context
            )
        }
    }
}
