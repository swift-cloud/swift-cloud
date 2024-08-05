extension aws {
    public struct ImageRepository: ResourceProvider {
        public let resource: Resource

        public var url: String {
            keyPath("repositoryUrl")
        }

        public init(_ name: String) {
            resource = .init(name, type: "aws:ecr:Repository")
        }
    }
}

extension aws.ImageRepository {
    public static let shared = aws.ImageRepository("sc-shared-repo")
}
