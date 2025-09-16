public enum Git {
    public enum GitError: Error {
        case invalidBranch
    }

    public static func currentBranch() async throws -> String {
        let (stdout, _) = try await shellOut(to: .name("git"), arguments: ["branch", "--show-current"])
        let branch = stdout.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !branch.isEmpty else {
            throw GitError.invalidBranch
        }
        return branch
    }

    public static func updateGitignore() throws {
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
}
