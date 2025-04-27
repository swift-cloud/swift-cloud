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
        COPY ./.build/\(architecture.swiftBuildLinuxDirectory)/release/*.resources /var/runtime/

        # Copy directories if they exist
        COPY ./Content* /var/task/Content
        COPY ./Public* /var/task/Public
        COPY ./Resources* /var/task/Resources
        COPY ./Output* /var/task/Output

        CMD [ "\(targetName)" ]
        """
    }

    public static func amazonLinux(targetName: String, architecture: Architecture = .current, port: Int) -> String {
        """
        FROM amazonlinux:2

        WORKDIR /app/

        COPY ./.build/\(architecture.swiftBuildLinuxDirectory)/release/\(targetName) .
        COPY ./.build/\(architecture.swiftBuildLinuxDirectory)/release/*.resources .

        # Copy directories if they exist
        COPY ./Content* /app/Content
        COPY ./Public* /app/Public
        COPY ./Resources* /app/Resources
        COPY ./Output* /app/Output

        ENV SWIFT_BACKTRACE=enable=yes,sanitize=yes,threads=all,images=all,interactive=no,swift-backtrace=./swift-backtrace-static

        EXPOSE \(port)

        ENTRYPOINT [ "./\(targetName)" ]
        CMD ["--hostname", "0.0.0.0", "--port", "\(port)"]
        """
    }

    public static func ubuntu(targetName: String, architecture: Architecture = .current, port: Int) -> String {
        """
        FROM ubuntu:noble

        RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
            && apt-get -q update \
            && apt-get -q dist-upgrade -y \
            && apt-get -q install -y \
            libjemalloc2 \
            ca-certificates \
            tzdata \
            libcurl4

        WORKDIR /app/

        COPY ./.build/\(architecture.swiftBuildLinuxDirectory)/release/\(targetName) .
        COPY ./.build/\(architecture.swiftBuildLinuxDirectory)/release/*.resources .

        # Copy directories if they exist
        COPY ./Content* /app/Content
        COPY ./Public* /app/Public
        COPY ./Resources* /app/Resources
        COPY ./Output* /app/Output

        ENV SWIFT_BACKTRACE=enable=yes,sanitize=yes,threads=all,images=all,interactive=no,swift-backtrace=./swift-backtrace-static

        EXPOSE \(port)

        ENTRYPOINT [ "./\(targetName)" ]
        CMD ["--hostname", "0.0.0.0", "--port", "\(port)"]
        """
    }
}
