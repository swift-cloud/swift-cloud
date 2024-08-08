import ConsoleKitTerminal

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
    public static func spinner(label: String? = nil) -> ActivityIndicator<CustomActivity> {
        let activity = cli.customActivity(
            frames: ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"].map { frame in
                "\(frame) \(label ?? "")\n"
            },
            success: "",
            failure: ""
        )
        activity.start()
        return activity
    }
}
