import CloudCore
import Foundation

extension Vercel {
    public struct CDN: VercelComponent {
        public let name: Output<String>

        public let project: Project

        private let deployment: Resource

        public init(
            _ name: String,
            origins: [Vercel.CDN.Origin],
            project: Project? = nil,
            teamId: String? = nil,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            self.name = "\(name)"

            self.project = project ?? Project(name, options: options, context: context)

            let vercelJsonPath = "\(Context.cloudDirectory)/.vercel/vercel.json"

            self.deployment = Resource(
                name: "\(name)-deployment",
                type: "vercel:Deployment",
                properties: [
                    "projectId": self.project.id,
                    "teamId": teamId,
                    "files": getFile(path: vercelJsonPath).file,
                ],
                options: options,
                context: context
            )

            context.store.build { _ in
                let rewrites = origins.map { origin in
                    [
                        "source": "\(origin.path)/:match*".replacing("//:match*", with: "/:match*"),
                        "destination": "\(origin.url)/:match*".replacing("//:match*", with: "/:match*")
                    ]
                }
                let json = [
                    "$schema": "https://openapi.vercel.sh/vercel.json",
                    "cleanUrls": true,
                    "rewrites": rewrites
                ]
                let contents = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
                try Files.createFile(atPath: vercelJsonPath, contents: contents)
            }
        }
    }
}

extension Vercel.CDN {
    public struct Origin {
        public let url: String
        public let path: String

        public init(
            url: any Input<String>,
            path: any Input<String>
        ) {
            self.url = url.description
            self.path = path.description
        }
    }
}

extension Vercel.CDN.Origin {
    public static func url(
        _ url: any Input<String>, path: any Input<String>
    ) -> Self {
        .init(url: url, path: path)
    }
}
