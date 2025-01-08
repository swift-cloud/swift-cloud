import CloudCore

public protocol AWSResourceProvider: ResourceProvider {}

extension Resource: AWSResourceProvider {}

extension AWSResourceProvider {
    public var arn: Output<String> {
        output.keyPath("arn")
    }
}
