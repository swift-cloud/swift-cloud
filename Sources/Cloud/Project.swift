import ArgumentParser
import ConsoleKitTerminal

public protocol Project: Sendable {
    associatedtype ProjectHomeProvider: HomeProvider

    init()

    var name: String { get }

    var home: ProjectHomeProvider { get }

    var providers: [Provider] { get }

    func build() async throws -> Outputs
}

extension Project {
    public var name: String {
        .init(describing: type(of: self))
    }
}

extension Project {
    public var home: Home.AWS {
        Home.AWS()
    }
}

extension Project {
    public var providers: [Provider] {
        [.aws(region: "us-east-1")]
    }
}

extension Project {
    public static func main() async throws {
        let command = try? Command.parseAsRoot()
        switch command {
        case let command as Command.RunCommand:
            let project = Self()
            let builder = Builder()
            let store = Store()
            let context = try await Context(
                stage: command.options.stage,
                project: project,
                package: .current(),
                store: store,
                builder: builder
            )
            await Context.$current.withValue(context) {
                ui.writeHeader()
                do {
                    try await command.invoke(with: context)
                    try await command.complete(with: context)
                } catch {
                    ui.error(error)
                }
                ui.writeFooter()
            }
        default:
            ui.newLine()
            ui.error("➜  Invalid command:   ensure you pass a stage, ie: --stage prod")
            ui.newLine()
        }
    }
}
