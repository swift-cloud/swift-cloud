extension Cloudflare {
    public struct Record: CloudflareComponent {
        public let record: Resource

        public var name: Output<String> {
            record.name
        }

        public var hostname: Output<String> {
            record.output.keyPath("hostname")
        }

        public var url: Output<String> {
            "https://\(hostname)"
        }

        public init(
            domain: String,
            type: RecordType,
            name: CustomStringConvertible,
            value: CustomStringConvertible,
            proxied: Bool = false,
            ttl: Duration = .seconds(60),
            options: Resource.Options? = nil
        ) {
            record = Resource(
                name: "\(domain)-\(name)-record",
                type: "cloudflare:Record",
                properties: [
                    "zoneId": getZone(name: domain).zoneId,
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

extension Cloudflare.Record {
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
