import Foundation

extension Pulumi {
    public struct Stack: Codable, Sendable {
        public struct Deployment: Codable, Sendable {
            public struct Resource: Codable, Sendable {
                public let urn: String
                public let type: String
                public let created: Date
                public let modified: Date
                public let outputs: [String: AnyCodable]?
            }

            public let resources: [Resource]
        }

        public let version: Int
        public let deployment: Deployment
    }
}

extension Pulumi.Stack {
    public func stackResource() -> Pulumi.Stack.Deployment.Resource? {
        return deployment.resources.first(where: { $0.type == "pulumi:pulumi:Stack" })
    }
}
