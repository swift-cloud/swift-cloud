import Foundation

extension ui {
    public static func writeFooter() {
        let diff = Date().timeIntervalSince(Context.current.startDate)

        ui.newLine()
        ui.write("➜", width: .small, color: .cyan, bold: true)
        ui.write("Done:", width: .medium, color: .cyan, bold: true)
        ui.write(String(format: "%.2fs", diff))
        ui.newLine()
        ui.newLine()
    }
}
