import Foundation

func tokenize(_ inputs: String..., separator: String = "-") -> String {
    // Step 1: Join inputs and trim leading and trailing whitespace
    let trimmedString = inputs.joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)

    // Step 2: Split camelCase and lowercase the string
    let camelCaseRegex = try! Regex<(Substring, Substring, Substring)>("([a-z0-9])([A-Z])")
    let splitCamelCase = trimmedString.replacing(camelCaseRegex) { "\($0.1) \($0.2)" }.lowercased()

    // Step 3: Replace non-alphanumeric characters with spaces
    let nonAlphanumericRegex = try! Regex("[^a-z0-9]+")
    let spacedString = splitCamelCase.replacing(nonAlphanumericRegex, with: " ")

    // Step 4: Split into components, filter empty ones, and join with separator
    let components = spacedString.split(separator: " ")
    let slug = components.joined(separator: separator)

    // Step 5: Remove any leading or trailing separators
    return slug.trimmingCharacters(in: .init(charactersIn: separator))
}
