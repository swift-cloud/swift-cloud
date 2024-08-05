extension aws {
    public class ImageRepository: Resource {
        public var url: String {
            keyPath("repositoryUrl")
        }

        public init(_ name: String) {
            super.init(name, type: "aws:ecr:Repository")
        }
    }
}

extension aws.ImageRepository {
    public static let shared = aws.ImageRepository("sc-shared-repo")
}
