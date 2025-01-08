func writeKitResources(_ links: [LinkProperties]) throws {
    try? removeDirectory(atPath: Context.cloudKitResourcesDirectory)
    try createDirectory(atPath: Context.cloudKitResourcesDirectory)
    for link in links {
        try writeKitResource(link)
    }
}

private func writeKitResource(_ link: LinkProperties) throws {
    let linkName = link.name.capitalized
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

    try createFile(atPath: filename, contents: fileContents)
}
