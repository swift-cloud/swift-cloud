import Foundation

extension UI {
    public static func writeFooter(context: Context = .current) {
        let diff = Date().timeIntervalSince(context.startDate)

        UI.newLine()
        UI.write("➜", width: .small, color: .cyan, bold: true)
        UI.write("Done:", width: .medium, color: .cyan, bold: true)
        UI.write(String(format: "%.2fs", diff))
        UI.newLine()
        UI.newLine()
    }
}
