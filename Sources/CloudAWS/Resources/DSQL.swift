extension AWS {
    public enum DSQL {}
}

extension AWS.DSQL {
    public struct Cluster: AWSResourceProvider {
        public let resource: Resource
        fileprivate let configuredWitnessRegion: (any Input<String>)?

        public var identifier: Output<String> {
            output.keyPath("identifier")
        }

        public var vpcEndpointServiceName: Output<String> {
            output.keyPath("vpcEndpointServiceName")
        }

        public var witnessRegion: Output<String> {
            output.keyPath("multiRegionProperties", "witnessRegion")
        }

        public var region: Output<String> {
            AWS.getARN(self).region
        }

        public var hostname: Output<String> {
            "\(identifier).dsql.\(region).on.aws"
        }

        public var port: Output<String> {
            "5432"
        }

        public var url: Output<String> {
            "postgres://admin@\(hostname):\(port)/postgres"
        }

        public init(
            _ name: String,
            deletionProtectionEnabled: Bool = false,
            forceDestroy: Bool = false,
            encryptionKey: EncryptionKey = .awsOwned,
            multiRegion: MultiRegion = .disabled,
            region: (any Input<String>)? = nil,
            tags: [String: String]? = nil,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            configuredWitnessRegion = multiRegion.witnessRegion

            resource = Resource(
                name: name,
                type: "aws:dsql:Cluster",
                properties: [
                    "deletionProtectionEnabled": deletionProtectionEnabled,
                    "forceDestroy": forceDestroy,
                    "kmsEncryptionKey": encryptionKey.value,
                    "multiRegionProperties": multiRegion.properties,
                    "region": region,
                    "tags": tags,
                ],
                options: options,
                context: context
            )
        }
    }
}

extension AWS.DSQL.Cluster {
    public enum EncryptionKey {
        case awsOwned
        case kms(any Input<String>)

        fileprivate var value: any Input<String> {
            switch self {
            case .awsOwned:
                return "AWS_OWNED_KMS_KEY"
            case .kms(let keyArn):
                return keyArn
            }
        }
    }

    public enum MultiRegion {
        case disabled
        case enabled(witnessRegion: any Input<String>, peers: [any Input<String>] = [])

        public static func enabled(
            witnessRegion: any Input<String>,
            peers: [AWS.DSQL.Cluster]
        ) -> Self {
            .enabled(witnessRegion: witnessRegion, peers: peers.map(\.arn))
        }

        fileprivate var witnessRegion: (any Input<String>)? {
            switch self {
            case .disabled:
                return nil
            case .enabled(let witnessRegion, _):
                return witnessRegion
            }
        }

        fileprivate var properties: [String: AnyEncodable]? {
            switch self {
            case .disabled:
                return nil
            case .enabled(let witnessRegion, let peers):
                return [
                    "witnessRegion": AnyEncodable(witnessRegion),
                    "clusters": AnyEncodable(peers.map(AnyEncodable.init)),
                ]
            }
        }
    }
}

extension AWS.DSQL.Cluster {
    @discardableResult
    public func peer(
        with cluster: AWS.DSQL.Cluster,
        name: String? = nil,
        witnessRegion: (any Input<String>)? = nil
    ) -> AWS.DSQL.Peering {
        .init(
            name ?? tokenize(resource.chosenName, cluster.resource.chosenName, "peering"),
            source: self,
            target: cluster,
            witnessRegion: witnessRegion
        )
    }
}

extension AWS.DSQL {
    public struct ClusterPeering: AWSResourceProvider {
        public let resource: Resource

        public init(
            _ name: String,
            identifier: any Input<String>,
            clusters: [any Input<String>],
            witnessRegion: any Input<String>,
            region: (any Input<String>)? = nil,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            resource = Resource(
                name: name,
                type: "aws:dsql:ClusterPeering",
                properties: [
                    "identifier": identifier,
                    "clusters": clusters,
                    "witnessRegion": witnessRegion,
                    "region": region,
                ],
                options: options,
                context: context
            )
        }

        public init(
            _ name: String,
            cluster: AWS.DSQL.Cluster,
            peers: [AWS.DSQL.Cluster],
            witnessRegion: (any Input<String>)? = nil,
            options: Resource.Options? = nil
        ) {
            guard !peers.isEmpty else {
                fatalError("Aurora DSQL cluster peering requires at least one peer cluster.")
            }

            let witnessRegion = AWS.DSQL.requiredWitnessRegion(
                source: cluster,
                target: peers[0],
                witnessRegion: witnessRegion
            )

            self.init(
                name,
                identifier: cluster.identifier,
                clusters: peers.map(\.arn),
                witnessRegion: witnessRegion,
                region: cluster.region,
                options: options ?? cluster.resource.options,
                context: cluster.resource.context
            )
        }
    }
}

extension AWS.DSQL {
    public struct Peering: AWSComponent {
        public let source: AWS.DSQL.ClusterPeering
        public let target: AWS.DSQL.ClusterPeering

        public var name: Output<String> {
            source.name
        }

        public init(
            _ name: String,
            source: AWS.DSQL.Cluster,
            target: AWS.DSQL.Cluster,
            witnessRegion: (any Input<String>)? = nil
        ) {
            let witnessRegion = AWS.DSQL.requiredWitnessRegion(
                source: source,
                target: target,
                witnessRegion: witnessRegion
            )

            self.source = .init(
                "\(name)-source",
                cluster: source,
                peers: [target],
                witnessRegion: witnessRegion
            )

            self.target = .init(
                "\(name)-target",
                cluster: target,
                peers: [source],
                witnessRegion: witnessRegion
            )
        }
    }
}

extension AWS.DSQL {
    fileprivate static func requiredWitnessRegion(
        source: AWS.DSQL.Cluster,
        target: AWS.DSQL.Cluster,
        witnessRegion: (any Input<String>)?
    ) -> any Input<String> {
        if let witnessRegion {
            return witnessRegion
        }

        if let witnessRegion = source.configuredWitnessRegion {
            return witnessRegion
        }

        if let witnessRegion = target.configuredWitnessRegion {
            return witnessRegion
        }

        fatalError(
            "Aurora DSQL peering requires a witness region. Pass `witnessRegion` or configure `multiRegion: .enabled(witnessRegion: ...)` on one of the clusters."
        )
    }
}

extension AWS.DSQL.Cluster: Linkable {
    public var actions: [String] {
        [
            "dsql:DbConnect",
            "dsql:DbConnectAdmin",
        ]
    }

    public var resources: [Output<String>] {
        [arn]
    }

    public var properties: LinkProperties? {
        .init(
            type: "dsql",
            name: resource.chosenName,
            properties: [
                "identifier": identifier,
                "region": region,
                "hostname": hostname,
                "port": port,
                "databaseName": "postgres",
                "username": "admin",
                "url": url,
            ]
        )
    }
}
