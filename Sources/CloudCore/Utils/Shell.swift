import Command
import Foundation

private let shell = CommandRunner()

enum ShellError: Error {
    case terminated(errorCode: Int32, stderr: String)
}

public typealias ShellEventHandler = (CommandEvent) -> Void

@discardableResult
func shellOut(
    to command: String,
    arguments: [String],
    workingDirectory: String? = nil,
    environment: [String: String] = currentEnvironment(),
    onEvent: ShellEventHandler? = nil
) async throws -> (stdout: String, stderr: String) {
    var stdout = ""
    var stderr = ""
    let stream = try shellStream(
        to: command,
        arguments: arguments,
        workingDirectory: workingDirectory,
        environment: environment
    )
    do {
        for try await line in stream {
            switch line {
            case .standardOutput:
                stdout += line.string() ?? ""
            case .standardError:
                stderr += line.string() ?? ""
            }
            onEvent?(line)
        }
        return (stdout, stderr)
    } catch let CommandError.terminated(errorCode, _) {
        throw ShellError.terminated(errorCode: errorCode, stderr: stderr.count > 0 ? stderr : stdout)
    } catch {
        throw ShellError.terminated(errorCode: 255, stderr: stderr.count > 0 ? stderr : stdout)
    }
}

func shellStream(
    to command: String,
    arguments: [String],
    workingDirectory: String? = nil,
    environment: [String: String] = ProcessInfo.processInfo.environment
) throws -> AsyncThrowingStream<CommandEvent, any Error> {
    return shell.run(
        arguments: [command] + arguments,
        environment: environment,
        workingDirectory: try workingDirectory.map { try .init(validating: $0) }
    )
}
