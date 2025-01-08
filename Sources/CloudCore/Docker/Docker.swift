public enum Docker {}

extension Docker {
    public enum Dockerfile {}
}

extension Docker.Dockerfile {
    public static func write(_ contents: String, to path: String) throws {
        try Files.createFile(atPath: path, contents: contents)
        try Files.createFile(atPath: "\(path).dockerignore", contents: "\n")
    }

    public static func filePath(_ name: String) -> String {
        "\(Context.cloudAssetsDirectory)/Dockerfile.\(tokenize(name))"
    }
}

extension Docker.Dockerfile {
    public static func awsLambda(targetName: String, architecture: Architecture = .current) -> String {
        """
        FROM public.ecr.aws/lambda/provided:al2

        COPY ./.build/\(architecture.swiftBuildLinuxDirectory)/release/\(targetName) /var/runtime/bootstrap

        CMD [ "\(targetName)" ]
        """
    }

    public static func amazonLinux(targetName: String, architecture: Architecture = .current, port: Int) -> String {
        """
        FROM amazonlinux:2

        WORKDIR /app/

        COPY ./.build/\(architecture.swiftBuildLinuxDirectory)/release/\(targetName) .

        ENV SWIFT_BACKTRACE=enable=yes,sanitize=yes,threads=all,images=all,interactive=no,swift-backtrace=./swift-backtrace-static

        EXPOSE \(port)

        ENTRYPOINT [ "./\(targetName)" ]
        CMD ["--hostname", "0.0.0.0", "--port", "\(port)"]
        """
    }
}
