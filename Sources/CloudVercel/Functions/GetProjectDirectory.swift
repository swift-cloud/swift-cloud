extension Vercel {
    public struct GetProjectDirectory {
        public let id: String
        public let path: String
        public let files: [String: String]
    }

    public static func getProjectDirectory(path: String) -> Output<GetProjectDirectory> {
        let variable = Variable<GetProjectDirectory>.invoke(
            name: "\(path)-project-directory",
            function: "vercel:getProjectDirectory",
            arguments: ["path": path]
        )
        return variable.output
    }
}
