import CloudCore

extension AWS {
    public struct DNSRecord: AWSResourceProvider, DNSProviderRecord {
        public let resource: Resource

        public var fqdn: Output<String> {
            resource.output.keyPath("fqdn")
        }

        public init(
            zoneId: CustomStringConvertible,
            type: CustomStringConvertible,
            name: CustomStringConvertible,
            ttl: Duration = .seconds(60),
            records: [CustomStringConvertible],
            options: Resource.Options? = nil
        ) {
            resource = Resource(
                name: "\(name)-record",
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
