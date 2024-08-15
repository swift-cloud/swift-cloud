import Foundation

public final class Store: @unchecked Sendable {
    public typealias Operation = (Context) async throws -> Void

    private let queue = DispatchQueue(label: "com.swift.cloud.store")

    private var _resources: [Resource] = []
    var resources: [Resource] {
        get { queue.sync { _resources } }
        set { queue.sync { _resources = newValue } }
    }

    private var _variables: [Variable] = []
    var variables: [Variable] {
        get { queue.sync { _variables } }
        set { queue.sync { _variables = newValue } }
    }

    private var _operations: [Operation] = []
    var operations: [Operation] {
        get { queue.sync { _operations } }
        set { queue.sync { _operations = newValue } }
    }

    private var _builds: [Operation] = []
    var builds: [Operation] {
        get { queue.sync { _builds } }
        set { queue.sync { _builds = newValue } }
    }

    private var _environments: [Environment] = []
    var environments: [Environment] {
        get { queue.sync { _environments } }
        set { queue.sync { _environments = newValue } }
    }

    private var _outputs: [String: String] = [:]
    var outputs: [String: String] {
        get { queue.sync { _outputs } }
        set { queue.sync { _outputs = newValue } }
    }
}

extension Store {
    public func track(_ resource: Resource) {
        resources.append(resource)
    }

    public func track(_ variable: Variable) {
        variables.append(variable)
    }

    public func track(_ environment: Environment) {
        environments.append(environment)
    }

    public func setOutput(_ output: String, value: String) {
        outputs[output] = value
    }

    public func invoke(_ operation: @escaping Operation) {
        operations.append(operation)
    }

    public func build(_ operation: @escaping Operation) {
        builds.append(operation)
    }
}
