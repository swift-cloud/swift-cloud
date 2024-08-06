import ArgumentParser

public protocol Project: Sendable {
    init()

    var name: String { get }

    var home: Home { get }

    var providers: [Provider] { get }

    func build() async throws -> Outputs
}

extension Project {
    public var name: String {
        String(describing: type(of: self))
    }
}

extension Project {
    public var home: Home {
        .local()
    }
}

extension Project {
    public var providers: [Provider] {
        []
    }
}

extension Project {
    public static func main() async throws {
        let project = Self()
        let command = try Command.parseAsRoot()
        switch command {
        case let command as Command.RunCommand:
            try await command.invoke(with: project)
        default:
            let error = ValidationError("Unknown command")
            Command.exit(withError: error)
        }
    }
}
