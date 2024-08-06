public enum Docker {}

extension Docker {
    public enum Dockerfile {}
}

extension Docker.Dockerfile {
    public static func filePath(_ name: String) -> String {
        "\(Context.cloudDirectory)/dockerfiles/Dockerfile.\(tokenize(name))"
    }
}

extension Docker.Dockerfile {
    public static func awsLambda(targetName: String, architecture: Architecture = .current) -> String {
        """
        FROM public.ecr.aws/lambda/provided:al2023

        COPY ./.build/\(architecture.swiftBuildLinuxDirectory)/release/\(targetName) /var/runtime/bootstrap

        CMD [ "\(targetName)" ]
        """
    }

    public static func awsECS(targetName: String, architecture: Architecture = .current) -> String {
        """
        FROM amazonlinux:2023

        WORKDIR /app/

        COPY ./.build/\(architecture.swiftBuildLinuxDirectory)/release/\(targetName) .

        CMD [ "\(targetName)" ]
        """
    }
}
