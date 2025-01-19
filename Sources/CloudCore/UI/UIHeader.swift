extension UI {
    public static func writeHeader(context: Context = .current) {
        cli.clear(lines: 3)
        UI.newLine()

        UI.write("Swift Cloud", color: .cyan, bold: true, newLine: true)
        UI.newLine()

        UI.write("➜", width: .small, color: .cyan, bold: true)
        UI.write("Project", width: .medium, bold: true)
        UI.write(context.name, newLine: true)

        UI.write("", width: .small)
        UI.write("Stage", width: .medium, bold: true)
        UI.write(context.stage, newLine: true)

        UI.newLine()
    }
}
