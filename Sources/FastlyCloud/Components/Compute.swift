import Cloud

extension Fastly {
    public struct Compute: FastlyComponent {
        public let service: Resource

        public var name: Output<String> {
            service.name
        }

        public init(
            _ name: String,
            targetName: String,
            domains: [CustomStringConvertible],
            options: Resource.Options? = nil
        ) {
            let filename = "\(Context.buildDirectory)/fastly/\(targetName)/package.tar.gz"

            service = Resource(
                name: name,
                type: "fastly:ServiceCompute",
                properties: [
                    "activate": true,
                    "domains": domains.map {
                        ["name": $0.description]
                    },
                    "package": [
                        "filename": filename,
                        "sourceCodeHash": getPackageHash(filename: filename).hash,
                    ],
                ],
                options: options
            )

            Context.current.store.build {
                try await $0.builder.buildWasm(targetName: targetName)
                try await $0.builder.packageForFastly(targetName: targetName)
            }
        }
    }
}
