import ArgumentParser
import ConsoleKitTerminal

public protocol Project: Sendable {
    init()

    var name: String { get }

    var home: any HomeProvider { get }

    var providers: [Provider] { get }

    func build() async throws -> Outputs
}

extension Project {
    public var name: String {
        ""
    }

    public var providers: [Provider] {
        []
    }

    public var home: any HomeProvider {
        .local()
    }
}

extension Project {
    public static func main() async throws {
        let command = try? Command.parseAsRoot()
        switch command {
        case let command as Command.RunCommand:
            let stage = try await command.stage()
            let context = try await Context(
                stage: stage,
                project: Self(),
                package: .current(),
                store: .init(),
                builder: .init()
            )
            try await command.execute(context: context)
        default:
            UI.newLine()
            UI.error("Invalid command: ensure you pass a stage, ie: --stage prod")
            UI.newLine()
        }
    }
}
