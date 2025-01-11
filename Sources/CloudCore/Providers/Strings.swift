public enum Strings {}

extension Strings {
    public static func split(
        _ input: any Input<String>,
        pattern: String
    ) -> Output<[String]> {
        let variable = Variable<[String]>(
            name: "\(input)-\(pattern)-split",
            definition: [
                "fn::split": [pattern, input]
            ]
        )
        return variable.output
    }
}

extension Strings {
    public static func select(
        _ input: [any Input<String>],
        index: Int
    ) -> Output<String> {
        let variable = Variable<String>(
            name: "\(input.map(\.description).joined(separator: "-"))-\(index)-split",
            definition: [
                "fn::select": [index, input]
            ]
        )
        return variable.output
    }

    public static func select(
        _ input: Output<[String]>,
        index: Int
    ) -> Output<String> {
        let variable = Variable<String>(
            name: "\(input)-\(index)-split",
            definition: [
                "fn::select": [index, input]
            ]
        )
        return variable.output
    }
}

extension Strings {
    public static func joined(
        _ input: [any Input<String>],
        separator: String
    ) -> Output<String> {
        let variable = Variable<String>(
            name: "\(input.map(\.description).joined(separator: "-"))-\(separator)-split",
            definition: [
                "fn::join": [separator, input]
            ]
        )
        return variable.output
    }

    public static func joined(
        _ input: Output<[String]>,
        separator: String
    ) -> Output<String> {
        let variable = Variable<String>(
            name: "\(input)-\(separator)-split",
            definition: [
                "fn::join": [separator, input]
            ]
        )
        return variable.output
    }
}

extension Strings {
    public struct Replacement {
        public let result: String
    }

    public static func replace(
        _ input: any Input<String>,
        pattern: String,
        with value: String
    ) -> Output<Replacement> {
        let variable = Variable<Replacement>.invoke(
            name: "\(input)-\(pattern)-\(value)-replace",
            function: "str:replace",
            arguments: [
                "old": pattern,
                "new": value,
                "string": input,
            ]
        )
        return variable.output
    }
}

extension Strings {
    public struct RegexReplacement {
        public let result: String
    }

    public static func regexReplace(
        _ input: any Input<String>,
        pattern: String,
        with value: String
    ) -> Output<Replacement> {
        let variable = Variable<Replacement>.invoke(
            name: "\(input)-\(pattern)-\(value)-regexreplace",
            function: "str:regexp:replace",
            arguments: [
                "old": pattern,
                "new": value,
                "string": input,
            ]
        )
        return variable.output
    }
}

extension Strings {
    public struct Trimmed {
        public let result: String
    }

    public static func trimPrefix(
        _ input: any Input<String>,
        prefix: String
    ) -> Output<Trimmed> {
        let variable = Variable<Trimmed>.invoke(
            name: "\(input)-\(prefix)-trimprefix",
            function: "str:trimPrefix",
            arguments: [
                "prefix": prefix,
                "string": input,
            ]
        )
        return variable.output
    }

    public static func trimSuffix(
        _ input: any Input<String>,
        suffix: String
    ) -> Output<Trimmed> {
        let variable = Variable<Trimmed>.invoke(
            name: "\(input)-\(suffix)-trimsuffix",
            function: "str:trimSuffix",
            arguments: [
                "suffix": suffix,
                "string": input,
            ]
        )
        return variable.output
    }
}
