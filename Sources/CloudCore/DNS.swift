public protocol DNSProvider: Sendable {
    func createRecord(
        type: Output<String>,
        name: Output<String>,
        target: Output<String>,
        ttl: Duration
    ) -> DNSProviderRecord

    func createAlias(
        name: Output<String>,
        target: Output<String>,
        ttl: Duration
    ) -> DNSProviderRecord
}

extension DNSProvider {
    public func createRecord(
        type: Output<String>,
        name: Output<String>,
        target: Output<String>,
        ttl: Duration = .seconds(60)
    ) -> DNSProviderRecord {
        createRecord(type: type, name: name, target: target, ttl: ttl)
    }

    public func createAlias(
        name: Output<String>,
        target: Output<String>,
        ttl: Duration = .seconds(60)
    ) -> DNSProviderRecord {
        createRecord(type: "CNAME", name: name, target: target, ttl: ttl)
    }
}

public protocol DNSProviderRecord: Sendable {
    var fqdn: Output<String> { get }
}

public struct DomainName: Sendable {
    public let hostname: Output<String>
    public let dns: any DNSProvider

    public init(hostname: Output<String>, dns: any DNSProvider) {
        self.hostname = hostname
        self.dns = dns
    }

    public init(hostname: String, dns: any DNSProvider) {
        self.hostname = "\(hostname)"
        self.dns = dns
    }

    @discardableResult
    public func aliasTo(_ target: Output<String>) -> DNSProviderRecord {
        dns.createAlias(name: hostname, target: target)
    }
}
