func writeKitResources(_ links: [LinkProperties]) throws {
    try? removeDirectory(atPath: Context.cloudKitResourcesDirectory)
    try createDirectory(atPath: Context.cloudKitResourcesDirectory)
    for link in links {
        try writeKitResource(link)
    }
}

private func writeKitResource(_ link: LinkProperties) throws {
    let linkType = link.type.capitalized
    let linkName = link.name.capitalized
    let directory = "\(Context.cloudKitResourcesDirectory)/\(linkType)"
    let enumFilename = "\(directory)/_\(linkType).swift"
    let resourceFilename = "\(directory)/\(linkName).swift"

    try? createDirectory(atPath: directory)
    try? removeFile(atPath: enumFilename)
    try createFile(
        atPath: enumFilename,
        contents:
            """
            extension Cloud.Resource {
                public enum \(linkType) {}
            }
            """
    )

    let resourceFileTemplate =
        """
        extension Cloud.Resource.\(linkType) {
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

    try createFile(
        atPath: resourceFilename,
        contents: resourceFileTemplate.replacingOccurrences(of: "{{props}}", with: resourceFileProperties)
    )
}
