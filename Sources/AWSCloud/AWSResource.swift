import Cloud

public protocol AWSResourceProvider: ResourceProvider {}

extension Resource: AWSResourceProvider {}

extension AWSResourceProvider {
    internal var arn: Output<String> {
        output.keyPath("arn")
    }
}
