import Command
import Foundation

private let shell = CommandRunner()

public enum ShellError: Error {
    case terminated(errorCode: Int32, stderr: String)
}

public typealias ShellEventHandler = (CommandEvent) -> Void

@discardableResult
public func shellOut(
    to command: String,
    arguments: [String],
    workingDirectory: String? = nil,
    environment: [String: String] = Files.currentEnvironment(),
    onEvent: ShellEventHandler? = nil
) async throws -> (stdout: String, stderr: String) {
    var std = ""
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
            std += line.string() ?? ""
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
        throw ShellError.terminated(errorCode: errorCode, stderr: std)
    } catch {
        throw ShellError.terminated(errorCode: 255, stderr: std)
    }
}

public func shellStream(
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
