extension Fastly {
    public struct GetPackageHash {
        public let hash: String
        public let id: String
        public let content: String
        public let filename: String
    }

    public static func getPackageHash(filename: String) -> Output<GetPackageHash> {
        let variable = Variable<GetPackageHash>.invoke(
            name: "\(filename)-hash",
            function: "fastly:getPackageHash",
            arguments: ["filename": filename]
        )
        return variable.output
    }
}
