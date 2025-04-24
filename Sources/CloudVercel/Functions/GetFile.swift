extension Vercel {
    public struct GetFile {
        public let id: String
        public let path: String
        public let file: [String: String]
    }

    public static func getFile(path: String) -> Output<GetFile> {
        let variable = Variable<GetFile>.invoke(
            name: "\(path)-file",
            function: "vercel:getFile",
            arguments: ["path": path]
        )
        return variable.output
    }
}
