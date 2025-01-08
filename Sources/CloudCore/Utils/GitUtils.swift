func updateGitignore() throws {
    let gitignorePath = ".gitignore"
    let entryToFind = ".cloud"
    let entryToAdd = ".cloud/"

    guard Files.fileExists(atPath: gitignorePath) else {
        return
    }

    let content = try String(contentsOfFile: gitignorePath, encoding: .utf8)
    guard !content.contains(entryToFind) else {
        return
    }

    let trimmedContent = content.trimmingSuffix { $0.isWhitespace }
    let newContent = "\(trimmedContent)\n\n# swift cloud\n\(entryToAdd)\n"
    try newContent.write(toFile: gitignorePath, atomically: true, encoding: .utf8)
}
