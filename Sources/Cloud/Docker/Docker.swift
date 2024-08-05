public struct Docker {
    public let targetName: String

    public let swiftVersion: String

    public let image: Image

    public init(
        targetName: String,
        swiftVersion: String,
        image: Image = .official
    ) {
        self.targetName = targetName
        self.swiftVersion = swiftVersion
        self.image = image
    }

    public func amazonLinuxDockerFile() -> String {
        """
        FROM \(image.name):\(swiftVersion)-amazonlinux2 as base

        WORKDIR /build/

        COPY . .

        RUN swift build -c release --static-swift-stdlib

        FROM amazonlinux:2023

        WORKDIR /app/

        COPY --from=base /build/.build/release/\(targetName) .

        CMD ["./\(targetName)"]
        """
    }
}

extension Docker {
    public enum Image {
        case official
        case swiftlang
        case custom(_ name: String)

        public var name: String {
            switch self {
            case .official:
                return "swift"
            case .swiftlang:
                return "swiftlang/swift"
            case .custom(let name):
                return name
            }
        }
    }
}
