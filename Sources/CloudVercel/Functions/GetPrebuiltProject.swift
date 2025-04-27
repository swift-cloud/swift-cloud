extension Vercel {
    public struct GetPrebuiltProject {
        public let id: String
        public let path: String
        public let output: [String: String]
    }

    public static func getPrebuiltProject(path: String) -> Output<GetPrebuiltProject> {
        let variable = Variable<GetPrebuiltProject>.invoke(
            name: "\(path)-prebuilt-project",
            function: "vercel:getPrebuiltProject",
            arguments: ["path": path]
        )
        return variable.output
    }
}
