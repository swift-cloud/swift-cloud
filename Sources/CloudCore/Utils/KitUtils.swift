func writeKitResources(_ links: [LinkProperties]) throws {
    try? removeDirectory(atPath: Context.cloudKitResourcesDirectory)
    try createDirectory(atPath: Context.cloudKitResourcesDirectory)
    for link in links {
        try writeKitResource(link)
    }
}

private func writeKitResource(_ link: LinkProperties) throws {
    let linkName = link.name.capitalized
    let directory = "\(Context.cloudKitResourcesDirectory)"
    let resourceFilename = "\(directory)/\(linkName).swift"

    let resourceFileTemplate =
        """
        extension Cloud.Resource {
            public struct \(linkName) {
                {{props}}
            }
        }
        """

    let resourceFileProperties = link.properties.map { key, _ in
        """
        public static let \(key): String = env("\(link.environmentKey(key))")
        """
    }.joined(separator: "\n\t\t")

    try? createDirectory(atPath: directory)
    try createFile(
        atPath: resourceFilename,
        contents: resourceFileTemplate.replacingOccurrences(of: "{{props}}", with: resourceFileProperties)
    )
}
