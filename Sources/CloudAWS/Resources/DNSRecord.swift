import CloudCore

extension AWS {
    public struct DNSRecord: AWSResourceProvider, DNSProviderRecord {
        public let resource: Resource

        public var fqdn: Output<String> {
            resource.output.keyPath("fqdn")
        }

        public init(
            zoneName: any Input<String>,
            type: any Input<String>,
            name: any Input<String>,
            ttl: Duration = .seconds(60),
            records: [any Input<String>],
            options: Resource.Options? = nil
        ) {
            let hostedZone = Route53.getZone(name: zoneName)
            resource = Resource(
                name: "\(zoneName)-\(name)-\(type)-record",
                type: "aws:route53:Record",
                properties: [
                    "zoneId": hostedZone.id,
                    "name": Strings.trimSuffix(name, suffix: ".\(zoneName)").result,
                    "type": type,
                    "ttl": ttl.components.seconds,
                    "records": records,
                ],
                options: options
            )
        }
    }
}
