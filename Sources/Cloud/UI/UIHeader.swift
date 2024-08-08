extension ui {
    public static func writeHeader() {
        cli.clear(lines: 3)
        ui.newLine()

        ui.write("Swift Cloud", color: .cyan, bold: true, newLine: true)
        ui.newLine()

        ui.write("➜", width: .small, color: .cyan, bold: true)
        ui.write("Package", width: .medium, bold: true)
        ui.write(Context.current.packageName, newLine: true)

        ui.write("", width: .small)
        ui.write("Project", width: .medium, bold: true)
        ui.write(Context.current.projectName, newLine: true)

        ui.write("", width: .small)
        ui.write("Stage", width: .medium, bold: true)
        ui.write(Context.current.stage, newLine: true)

        ui.newLine()
    }
}
