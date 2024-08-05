import Foundation

func slugify(_ inputs: String..., separator: String = "-") -> String {
    // Step 1: Trim leading and trailing whitespace
    let trimmedString = inputs.joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)

    // Step 2: Lowercase the string
    let lowercasedString = trimmedString.lowercased()

    // Step 3: Replace non-alphanumeric characters with the separator
    let alphanumericSet = CharacterSet.alphanumerics
    let components = lowercasedString.components(separatedBy: alphanumericSet.inverted)

    // Step 4: Join the components with the separator
    let slugComponents = components.filter { !$0.isEmpty }
    let slug = slugComponents.joined(separator: separator)

    // Step 5: Remove any leading or trailing separators
    return slug.trimmingCharacters(in: .init(charactersIn: separator))
}

func dockerFilePath(_ name: String) -> String {
    "\(Context.cloudDirectory)/dockerfiles/\(slugify(name))"
}

func createFile(
    atPath path: String,
    contents: Data?,
    withIntermediateDirectories: Bool = true
) throws {
    if withIntermediateDirectories {
        let directoryPath = path.components(separatedBy: "/").dropLast().joined(separator: "/")
        try FileManager.default.createDirectory(atPath: directoryPath, withIntermediateDirectories: true)
    }
    let url = URL(fileURLWithPath: path)
    try contents?.write(to: url)
}

func createFile(
    atPath path: String,
    contents: String,
    withIntermediateDirectories: Bool = true
) throws {
    try createFile(
        atPath: path,
        contents: contents.data(using: .utf8),
        withIntermediateDirectories: withIntermediateDirectories
    )
}
