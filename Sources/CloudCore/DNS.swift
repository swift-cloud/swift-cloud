public protocol DNSProvider: Sendable {
    func createRecord(
        type: any Input<String>,
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

extension DNSProvider {
    public func createRecord(
        type: any Input<String>,
        name: any Input<String>,
        target: any Input<String>,
        ttl: Duration = .seconds(60)
    ) -> DNSProviderRecord {
        createRecord(type: type, name: name, target: target, ttl: ttl)
    }

    public func createAlias(
        name: any Input<String>,
        target: any Input<String>,
        ttl: Duration = .seconds(60)
    ) -> DNSProviderRecord {
        createRecord(type: "CNAME", name: name, target: target, ttl: ttl)
    }
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
    public func aliasTo(_ target: any Input<String>) -> DNSProviderRecord {
        dns.createAlias(name: hostname, target: target)
    }
}
