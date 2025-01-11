public protocol DNSProvider: Sendable {
    func createRecord(
        type: DNSRecordType,
        name: any Input<String>,
        target: any Input<String>,
        ttl: Duration
    ) -> DNSProviderRecord

    func createAlias(
        name: any Input<String>,
        target: any Input<String>,
        ttl: Duration
    ) -> DNSProviderRecord
}

public protocol DNSProviderRecord: Sendable {
    var fqdn: Output<String> { get }
}

public struct DomainName: Sendable {
    public let hostname: any Input<String>
    public let dns: any DNSProvider

    public init(hostname: any Input<String>, dns: any DNSProvider) {
        self.hostname = hostname
        self.dns = dns
    }

    @discardableResult
    public func aliasTo(_ target: any Input<String>, ttl: Duration = .seconds(60)) -> DNSProviderRecord {
        dns.createAlias(name: hostname, target: target, ttl: ttl)
    }
}

public enum DNSRecordType: Sendable, Input {
    public typealias ValueType = String

    case a
    case aaaa
    case caa
    case cname
    case txt
    case srv
    case loc
    case mx
    case ns
    case spf
    case cert
    case dnskey
    case ds
    case naptr
    case smimea
    case sshfp
    case tlsa
    case uri
    case ptr
    case https
    case svcb
    case input(_ value: any Input<String>)

    public var description: String {
        switch self {
        case .a: return "A"
        case .aaaa: return "AAAA"
        case .caa: return "CAA"
        case .cname: return "CNAME"
        case .txt: return "TXT"
        case .srv: return "SRV"
        case .loc: return "LOC"
        case .mx: return "MX"
        case .ns: return "NS"
        case .spf: return "SPF"
        case .cert: return "CERT"
        case .dnskey: return "DNSKEY"
        case .ds: return "DS"
        case .naptr: return "NAPTR"
        case .smimea: return "SMIMEA"
        case .sshfp: return "SSHFP"
        case .tlsa: return "TLSA"
        case .uri: return "URI"
        case .ptr: return "PTR"
        case .https: return "HTTPS"
        case .svcb: return "SVCB"
        case .input(let value):
            return value.description
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}

extension DomainName {
    public static func inferredZoneName(hostname: String) -> String {
        let parts = hostname.split(separator: ".")
        let countThreshold =
            switch hostname {
            case _ where hostname.hasSuffix(".co.uk"): 3
            case _ where hostname.hasSuffix(".com.au"): 3
            case _ where hostname.hasSuffix(".co.jp"): 3
            case _ where hostname.hasSuffix(".co.nz"): 3
            case _ where hostname.hasSuffix(".co.za"): 3
            case _ where hostname.hasSuffix(".com.br"): 3
            case _ where hostname.hasSuffix(".com.mx"): 3
            default: 2
            }
        if parts.count > countThreshold {
            return parts.dropFirst().joined(separator: ".")
        } else {
            return parts.joined(separator: ".")
        }
    }
}
