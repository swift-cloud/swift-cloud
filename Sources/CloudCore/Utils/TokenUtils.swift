import Crypto
import Foundation

public func tokenize(
    _ inputs: any Input<String>...,
    separator: String = "-",
    maxLength: Int = 512
) -> String {
    // Step 1: Join inputs and trim leading and trailing whitespace
    let trimmedString =
        inputs
        .map { $0.description }
        .joined(separator: " ")
        .trimmingCharacters(in: .whitespacesAndNewlines)

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
    let token = slug.trimmingCharacters(in: .init(charactersIn: separator))

    // Step 6: Return the result if it's within the maxLength
    if token.count <= maxLength {
        return token
    }

    // Step 7: If the result is too long, hash it
    let hashed = SHA256.hash(data: Data(token.utf8)).hexEncodedString().prefix(4)

    // Step 8: Return the prefix of the token and the hashed value
    return token.prefix(maxLength - 5) + "-" + hashed
}
