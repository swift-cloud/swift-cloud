import ConsoleKitTerminal
import Foundation

extension UI {
    public static func newLine() {
        cli.output("", newLine: true)
    }
}

extension UI {
    public static func clear(_ type: ConsoleClear) {
        cli.clear(type)
    }

    public static func clearScreen() {
        cli.clear(.screen)
    }

    public static func clearLine() {
        cli.clear(.line)
    }
}

extension UI {
    public enum ColumnSize: Int {
        case small = 3
        case medium = 12
        case large = 32
    }

    public static func write(
        _ text: String,
        width: ColumnSize? = nil,
        color: ConsoleColor? = nil,
        bold: Bool = false,
        newLine: Bool = false
    ) {
        var text = text
        if let width, text.count < width.rawValue {
            text = text.padding(toLength: width.rawValue, withPad: " ", startingAt: 0)
        }
        cli.output(
            "\(text)",
            style: .init(color: color, isBold: bold),
            newLine: newLine
        )
    }
}

extension UI {
    public static func writeBlock(_ text: String, bold: Bool = false) {
        let lines = text.split(separator: .newlineSequence)
        for line in lines {
            UI.write("|", width: .small, color: .yellow, bold: true)
            UI.write("\(line)", bold: bold)
            UI.newLine()
        }
    }

    public static func writeBlock(key: String, value: String) {
        UI.write("|", width: .small, color: .yellow, bold: true)
        UI.write("\(key)", width: .medium, bold: true)
        UI.write("\(value)")
        UI.newLine()
    }
}

extension UI {
    public static func writeOutputs(_ outputs: [String: AnyCodable]) {
        guard !outputs.isEmpty else {
            UI.writeBlock("No outputs")
            return
        }
        for key in outputs.keys.sorted() {
            guard !Outputs.isInternalKey(key) else {
                continue
            }
            let value = outputs[key]!
            UI.writeBlock(key: key, value: "\(value)")
        }
    }
}

extension UI {
    public static func error(_ error: Error) {
        cli.error("\(error)")
    }

    public static func error(_ error: String) {
        cli.error("\(error)")
    }
}

extension UI {
    public final class Spinner: @unchecked Sendable {
        fileprivate static let shared = Spinner()

        private let queue = DispatchQueue(label: "com.swift.cloud.ui.spinner")

        private let frames = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]

        private var _labels: [String] = []
        private var labels: [String] {
            get { queue.sync { _labels } }
            set { queue.sync { _labels = newValue } }
        }

        private var _spinner: ActivityIndicator<CustomActivity>?
        private var spinner: ActivityIndicator<CustomActivity>? {
            get { queue.sync { _spinner } }
            set { queue.sync { _spinner = newValue } }
        }

        private init() {}

        fileprivate func start(_ label: String) {
            spinner?.succeed()
            labels.append(label)
            spinner = cli.customActivity(
                frames: frames.map { "\($0) \(label)\n" },
                success: "",
                failure: ""
            )
            if labels.count > 1 {
                cli.clear(lines: 1)
            }
            spinner?.start()
        }

        public func push(_ line: String?) {
            guard
                let label = labels.last,
                let lines = line?.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "\n"),
                let trimmedLine = lines.last?.trimmingCharacters(in: .whitespacesAndNewlines),
                !trimmedLine.isEmpty,
                trimmedLine != ".",
                trimmedLine != "@ updating...."
            else { return }
            spinner?.succeed()
            spinner = cli.customActivity(
                frames: frames.map { "\($0) \(label)\n  └─ \(trimmedLine)" },
                success: "",
                failure: ""
            )
            cli.clear(lines: 1)
            spinner?.start()
        }

        public func stop() {
            spinner?.succeed()
            labels.removeLast()
            cli.clear(lines: 1)
            if let label = labels.last {
                spinner = cli.customActivity(
                    frames: frames.map { "\($0) \(label)\n" },
                    success: "",
                    failure: ""
                )
                spinner?.start()
            }
        }
    }

    public static func spinner(label: String) -> Spinner {
        let spinner = Spinner.shared
        spinner.start(label)
        return spinner
    }
}
