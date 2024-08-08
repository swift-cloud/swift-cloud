import ConsoleKitTerminal
import Foundation

extension ui {
    public static func newLine() {
        cli.output("", newLine: true)
    }
}

extension ui {
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

extension ui {
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
        if let width {
            text = text.padding(toLength: width.rawValue, withPad: " ", startingAt: 0)
        }
        cli.output(
            "\(text)",
            style: .init(color: color, isBold: bold),
            newLine: newLine
        )
    }
}

extension ui {
    public static func writeBlock(_ text: String) {
        let lines = text.split(separator: .newlineSequence)
        for line in lines {
            ui.write("|", width: .small, color: .yellow, bold: true)
            ui.write("\(line)")
            ui.newLine()
        }
    }
}

extension ui {
    public static func error(_ error: Error) {
        cli.error("\(error)")
    }

    public static func error(_ error: String) {
        cli.error("\(error)")
    }
}

extension ui {
    public final class Spinner: @unchecked Sendable {
        fileprivate static let shared = Spinner()

        private let queue = DispatchQueue(label: "com.swift.cloud.ui.spinner")

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

        fileprivate func start(_ label: String) -> Self {
            spinner?.succeed()
            labels.append(label)
            spinner = cli.customActivity(
                frames: ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"].map { frame in
                    "\(frame) \(label)"
                },
                success: "",
                failure: ""
            )
            if labels.count > 1 {
                cli.clear(lines: 1)
            }
            spinner?.start()
            return self
        }

        public func stop() {
            spinner?.succeed()
            labels.removeLast()
            if let label = labels.last {
                spinner = cli.customActivity(
                    frames: ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"].map { frame in
                        "\(frame) \(label)"
                    },
                    success: "",
                    failure: ""
                )
                cli.clear(lines: 1)
                spinner?.start()
            } else {
                cli.clear(lines: 1)
            }
        }
    }

    public static func spinner(label: String) -> Spinner {
        return Spinner.shared.start(label)
    }
}
