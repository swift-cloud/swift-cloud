import Foundation

extension AWS.CDN {
    /// A CloudFront Function (`cloudfront-js-2.0` runtime), attached to CDN paths via `AWS.CDN.Origin`'s `functions`.
    public struct Function: AWSComponent {
        public let function: Resource

        public var name: Output<String> {
            function.name
        }

        public var arn: Output<String> {
            function.arn
        }

        public init(
            _ name: String,
            code: String,
            comment: String? = nil,
            keyValueStores: [KeyValueStore] = [],
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            function = Resource(
                name: name,
                type: "aws:cloudfront:Function",
                properties: [
                    // Function names allow up to 64 characters.
                    "name": tokenize(context.stage, name, maxLength: 64),
                    "runtime": "cloudfront-js-2.0",
                    "code": code,
                    "comment": comment,
                    // Publishing promotes the code to the LIVE stage, which is what distributions run.
                    "publish": true,
                    "keyValueStoreAssociations": keyValueStores.isEmpty ? nil : keyValueStores.map { "\($0.arn)" },
                ],
                options: options,
                context: context
            )
        }
    }
}

extension AWS.CDN.Function {
    /// Where in the request lifecycle the function runs.
    public enum EventType: String, Sendable {
        case viewerRequest = "viewer-request"
        case viewerResponse = "viewer-response"
    }

    public struct Association: Sendable {
        public let eventType: EventType
        public let functionArn: String

        public init(_ function: AWS.CDN.Function, eventType: EventType) {
            self.eventType = eventType
            self.functionArn = "\(function.arn)"
        }

        public static func viewerRequest(_ function: AWS.CDN.Function) -> Self {
            .init(function, eventType: .viewerRequest)
        }

        public static func viewerResponse(_ function: AWS.CDN.Function) -> Self {
            .init(function, eventType: .viewerResponse)
        }
    }
}
