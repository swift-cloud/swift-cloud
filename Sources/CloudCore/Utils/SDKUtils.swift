func writeSDKResources(_ links: [LinkProperties]) throws {
    try? Files.removeDirectory(atPath: Context.cloudKitResourcesDirectory)
    try Files.createDirectory(atPath: Context.cloudKitResourcesDirectory)
    for link in links {
        try writeSDKResource(link)
    }
}

private func writeSDKResource(_ link: LinkProperties) throws {
    let linkName = tokenize(link.name).split(separator: "-").map { $0.capitalized }.joined()
    let filename = "\(Context.cloudKitResourcesDirectory)/\(linkName).swift"

    let fileTemplate =
        """
        extension Cloud.Resource {
            public struct \(linkName) {
                {{props}}
            }
        }
        """

    let fileTemplateProperties = link.properties.map { key, _ in
        """
        public static let \(key): String = env("\(link.environmentKey(key))")
        """
    }.joined(separator: "\n\t\t")

    let fileContents = fileTemplate.replacingOccurrences(of: "{{props}}", with: fileTemplateProperties)

    try Files.createFile(atPath: filename, contents: fileContents)
}
