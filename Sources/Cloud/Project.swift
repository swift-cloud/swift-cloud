import ArgumentParser
import ConsoleKitTerminal

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
        [.aws(region: "us-east-1")]
    }
}

extension Project {
    public static func main() async throws {
        let command = try Command.parseAsRoot()
        switch command {
        case let command as Command.RunCommand:
            let project = Self()
            let terminal = Terminal()
            let builder = Builder()
            let store = Store()
            let context = Context(
                stage: command.options.stage,
                project: project,
                store: store,
                builder: builder,
                terminal: terminal
            )
            await Context.$current.withValue(context) {
                ui.writeHeader()
                do {
                    try await command.invoke(with: context)
                } catch {
                    ui.error(error)
                }
                ui.writeFooter()
            }
        default:
            let error = ValidationError("Unknown command")
            Command.exit(withError: error)
        }
    }
}
