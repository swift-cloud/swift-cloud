extension ui {
    public static func writeHeader() {
        cli.clear(lines: 3)
        ui.newLine()

        ui.write("Swift Cloud", color: .cyan, bold: true)
        ui.newLine()
        ui.newLine()

        ui.write("➜", width: .small, color: .cyan, bold: true)
        ui.write("App:", width: .medium, bold: true)
        ui.write(Context.current.project.name)
        ui.newLine()

        ui.write("", width: .small)
        ui.write("Stage:", width: .medium, bold: true)
        ui.write(Context.current.stage)
        ui.newLine()
        ui.newLine()
    }
}
