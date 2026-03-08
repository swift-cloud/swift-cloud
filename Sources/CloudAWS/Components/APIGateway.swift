import CloudCore

extension AWS {
    public struct APIGateway: AWSComponent {
        public let api: Resource
        public let logGroup: Resource
        public let stage: Resource
        public let secureDomainName: AWS.SecureDomainName?
        public let apiDomainName: Resource?
        public let apiMapping: Resource?

        public var name: Output<String> {
            api.name
        }

        public var region: Output<String> {
            getARN(api).region
        }

        public var internalHostname: Output<String> {
            "\(api.id).execute-api.\(region).amazonaws.com"
        }

        public var hostname: Output<String> {
            if let secureDomainName {
                return "\(secureDomainName.hostname)"
            }
            return internalHostname
        }

        public var url: Output<String> {
            "https://\(hostname)"
        }

        public init(
            _ name: String,
            domainName: DomainName? = nil,
            cors: Bool = true,
            logFormat: LogFormat = .default,
            options: Resource.Options? = nil,
            context: Context = .current
        ) {
            api = Resource(
                name: name,
                type: "aws:apigatewayv2:Api",
                properties: [
                    "protocolType": "HTTP",
                    "corsConfiguration": cors
                        ? [
                            "allowOrigins": ["*"],
                            "allowMethods": ["*"],
                            "allowHeaders": ["*"],
                            "exposeHeaders": ["*"],
                            "maxAge": 86400,
                        ]
                        : nil,
                ],
                options: options,
                context: context
            )

            logGroup = Resource(
                name: "\(name)-logs",
                type: "aws:cloudwatch:LogGroup",
                properties: [
                    "name": "/aws/apigateway/\(api.name)",
                    "retentionInDays": 7,
                ],
                options: options,
                context: context
            )

            stage = Resource(
                name: "\(name)-stage",
                type: "aws:apigatewayv2:Stage",
                properties: [
                    "apiId": api.id,
                    "name": "$default",
                    "autoDeploy": true,
                    "accessLogSettings": [
                        "destinationArn": logGroup.arn,
                        "format": logFormat.value,
                    ],
                ],
                options: options,
                context: context
            )

            secureDomainName = domainName.map {
                AWS.SecureDomainName(domainName: $0, options: options, context: context)
            }

            if let secureDomainName, let domainName {
                let apigwDomain = Resource(
                    name: "\(name)-domain",
                    type: "aws:apigatewayv2:DomainName",
                    properties: [
                        "domainName": domainName.hostname,
                        "domainNameConfiguration": [
                            "certificateArn": secureDomainName.certificate.arn,
                            "endpointType": "REGIONAL",
                            "securityPolicy": "TLS_1_2",
                        ],
                    ],
                    options: options,
                    context: context,
                    dependsOn: [secureDomainName.validation]
                )

                apiDomainName = apigwDomain

                apiMapping = Resource(
                    name: "\(name)-mapping",
                    type: "aws:apigatewayv2:ApiMapping",
                    properties: [
                        "apiId": api.id,
                        "domainName": apigwDomain.id,
                        "stage": stage.id,
                    ],
                    options: options,
                    context: context
                )

                domainName.aliasTo(
                    apigwDomain.output.keyPath("domainNameConfiguration", "targetDomainName")
                )
            } else {
                apiDomainName = nil
                apiMapping = nil
            }
        }

        @discardableResult
        public func route(_ routeKey: String, function: AWS.Function) -> Self {
            let integration = Resource(
                name: tokenize(api.chosenName, routeKey, "integration"),
                type: "aws:apigatewayv2:Integration",
                properties: [
                    "apiId": api.id,
                    "integrationType": "AWS_PROXY",
                    "integrationUri": function.function.arn,
                    "integrationMethod": "POST",
                    "payloadFormatVersion": "2.0",
                ],
                options: api.options,
                context: api.context
            )

            _ = Resource(
                name: tokenize(api.chosenName, routeKey, "route"),
                type: "aws:apigatewayv2:Route",
                properties: [
                    "apiId": api.id,
                    "routeKey": routeKey,
                    "target": "integrations/\(integration.id)",
                ],
                options: api.options,
                context: api.context
            )

            function.grantInvokePermission(
                name: tokenize(api.chosenName, routeKey),
                arn: "\(api.output.keyPath("executionArn"))/*/*",
                principal: "apigateway.amazonaws.com"
            )

            return self
        }
    }
}

extension AWS.APIGateway {
    public struct LogFormat: ExpressibleByStringLiteral, Sendable {
        public let value: String

        public init(stringLiteral value: String) {
            self.value = value
        }

        /// JSON format capturing common request/response fields.
        public static let `default` = LogFormat(
            stringLiteral: #"{"requestId":"$context.requestId","ip":"$context.identity.sourceIp","requestTime":"$context.requestTime","httpMethod":"$context.httpMethod","routeKey":"$context.routeKey","status":"$context.status","protocol":"$context.protocol","responseLength":"$context.responseLength","integrationError":"$context.integrationErrorMessage"}"#
        )

        /// Common Log Format (CLF).
        public static let clf = LogFormat(
            stringLiteral: "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength"
        )
    }
}
