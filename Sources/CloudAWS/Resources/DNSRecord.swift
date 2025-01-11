import CloudCore

extension AWS {
    public struct DNSRecord: AWSResourceProvider, DNSProviderRecord {
        public let resource: Resource

        public var fqdn: Output<String> {
            resource.output.keyPath("fqdn")
        }

        public init(
            zoneId: any Input<String>,
            type: any Input<String>,
            name: any Input<String>,
            ttl: Duration = .seconds(60),
            records: [any Input<String>],
            options: Resource.Options? = nil
        ) {
            resource = Resource(
                name: "\(zoneId)-\(name)-\(type)-record",
                type: "aws:route53:Record",
                properties: [
                    "zoneId": zoneId,
                    "name": name,
                    "type": type,
                    "ttl": ttl.components.seconds,
                    "records": records,
                ],
                options: options
            )
        }
    }
}
