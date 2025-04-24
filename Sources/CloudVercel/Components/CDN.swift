import CloudCore
import Foundation

extension Vercel {
    public struct CDN: VercelComponent {
        public let name: Output<String>

        public let project: Project

        public var url: Output<String> {
            if let domainName {
                return "https://\(domainName.hostname)"
            } else {
                return "https://\(deployment.output.keyPath("url"))"
            }
        }

        private let deployment: Resource

        private let projectDomain: Resource?

        private let domainName: DomainName?

        public init(
            _ name: String,
            origins: [Vercel.CDN.Origin],
            domainName: DomainName? = nil,
            project: Project? = nil,
            teamId: String? = nil,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            self.name = "\(name)"

            self.domainName = domainName

            self.project = project ?? Project(name, options: options, context: context)

            let vercelProjectPath = "\(Context.cloudDirectory)/.vercel/\(context.project.name)"

            let prebuiltProject = getPrebuiltProject(path: vercelProjectPath)

            var environment = [String: String]()
            for (index, origin) in origins.enumerated() {
                environment["SWIFT_CLOUD_CDN_ORIGIN_URL_\(index)"] = origin.url
            }

            self.deployment = Resource(
                name: "\(name)-deployment",
                type: "vercel:Deployment",
                properties: [
                    "projectId": self.project.id,
                    "teamId": teamId,
                    "files": prebuiltProject.keyPath("output"),
                    "pathPrefix": prebuiltProject.keyPath("path"),
                    "production": true,
                    "environment": environment
                ],
                options: options,
                context: context
            )

            if let domainName {
                self.projectDomain = Resource(
                    name: "\(name)-project-domain",
                    type: "vercel:ProjectDomain",
                    properties: [
                        "domain": domainName.hostname,
                        "projectId": self.project.id,
                    ],
                    options: options,
                    context: context
                )

                if !domainName.hostname.description.contains(".vercel.app") {
                    domainName.aliasTo("cname.vercel-dns.com")
                }
            } else {
                self.projectDomain = nil
            }

            context.store.build { _ in
                let config = [
                    "version": 3,
                    "routes": origins.enumerated().map { (index, origin) in
                        [
                            "src": originPathToVercelSource(origin.path),
                            "middlewareRawSrc": [origin.path],
                            "middlewarePath": "edge-\(index)",
                            "continue": true
                        ]
                    }
                ]
                try Files.createFile(
                    atPath: "\(vercelProjectPath)/.vercel/output/config.json",
                    contents: JSONSerialization.data(withJSONObject: config, options: [
                        .prettyPrinted,
                        .sortedKeys,
                        .withoutEscapingSlashes,
                    ])
                )

                for (index, _) in origins.enumerated() {
                    let fnConfig = [
                        "runtime": "edge",
                        "entrypoint": "index.js",
                        "envVarsInUse": ["SWIFT_CLOUD_CDN_ORIGIN_URL_\(index)"]
                    ]
                    try Files.createFile(
                        atPath: "\(vercelProjectPath)/.vercel/output/functions/edge-\(index).func/.vc-config.json",
                        contents: JSONSerialization.data(withJSONObject: fnConfig, options: [
                            .prettyPrinted,
                            .sortedKeys,
                            .withoutEscapingSlashes,
                        ])
                    )

                    try Files.createFile(
                        atPath: "\(vercelProjectPath)/.vercel/output/functions/edge-\(index).func/index.js",
                        contents: """
                        export default async function handler(request) {
                            const url = new URL(request.url);
                            return new Response("", {
                                headers: {
                                    "x-middleware-rewrite": process.env.SWIFT_CLOUD_CDN_ORIGIN_URL_\(index) + url.pathname + url.search
                                }
                            });
                        }
                        """
                    )
                }
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

fileprivate func originPathToVercelSource(_ input: String) -> String {
    switch input {
        case "/", "*":
            return "/(.*)"
        case _ where input.hasSuffix("/*"):
            return "\(input.dropLast(2))/(.*)"
        default:
            return input
    }
}
