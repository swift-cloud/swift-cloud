func writeSDKResources(_ links: [LinkProperties]) throws {
    try? Files.removeDirectory(atPath: Context.cloudSDKResourcesDirectory)
    try Files.createDirectory(atPath: Context.cloudSDKResourcesDirectory)
    for link in links {
        try writeSDKResource(link)
    }
}

private func writeSDKResource(_ link: LinkProperties) throws {
    let linkName = tokenize(link.name).split(separator: "-").map { $0.capitalized }.joined()
    let filename = "\(Context.cloudSDKResourcesDirectory)/\(linkName).swift"
    let fileTemplate =
        """
        extension Cloud.Resource {
            public enum \(linkName) {
                {{props}}
            }
        }
        """
    let fileTemplateProperties = link.properties.map { key, _ in
        """
        public static let \(key) = Cloud.env("\(link.environmentKey(key))")!
        """
    }.joined(separator: "\n\t\t")
    try Files.createFile(
        atPath: filename,
        contents: fileTemplate.replacingOccurrences(
            of: "{{props}}",
            with: fileTemplateProperties
        )
    )
}
