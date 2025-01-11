extension Cloudflare {
    public struct DNSRecord: CloudflareResourceProvider, DNSProviderRecord {
        public let resource: Resource

        public var fqdn: Output<String> {
            resource.output.keyPath("hostname")
        }

        public init(
            zoneId: CustomStringConvertible,
            type: RecordType,
            name: CustomStringConvertible,
            value: CustomStringConvertible,
            proxied: Bool = false,
            ttl: Duration = .seconds(60),
            options: Resource.Options? = nil
        ) {
            resource = Resource(
                name: "\(zoneId)-\(name)-record",
                type: "cloudflare:Record",
                properties: [
                    "zoneId": zoneId,
                    "type": type.rawValue,
                    "name": name,
                    "content": value,
                    "proxied": proxied,
                    "ttl": proxied ? 1 : ttl.components.seconds,
                    "allowOverwrite": true,
                    "comment": "Managed by Swift Cloud",
                ],
                options: options
            )
        }
    }
}

extension Cloudflare.DNSRecord {
    public enum RecordType: String {
        case a = "A"
        case aaaa = "AAAA"
        case caa = "CAA"
        case cname = "CNAME"
        case txt = "TXT"
        case srv = "SRV"
        case loc = "LOC"
        case mx = "MX"
        case ns = "NS"
        case spf = "SPF"
        case cert = "CERT"
        case dnskey = "DNSKEY"
        case ds = "DS"
        case naptr = "NAPTR"
        case smimea = "SMIMEA"
        case sshfp = "SSHFP"
        case tlsa = "TLSA"
        case uri = "URI"
        case ptr = "PTR"
        case https = "HTTPS"
        case svcb = "SVCB"
    }
}
