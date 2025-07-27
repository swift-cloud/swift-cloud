//===-----------------------------------------------------------------------------===//
//
// Copyright 2018 Read Evaluate Press, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//===-----------------------------------------------------------------------------===//

/// A type-erased `Decodable` value.
///
/// The `AnyDecodable` type forwards decoding responsibilities
/// to an underlying value, hiding its specific underlying type.
///
/// You can decode mixed-type values in dictionaries
/// and other collections that require `Decodable` conformance
/// by declaring their contained type to be `AnyDecodable`:
///
///     let json = """
///     {
///         "boolean": true,
///         "integer": 42,
///         "double": 3.141592653589793,
///         "string": "string",
///         "array": [1, 2, 3],
///         "nested": {
///             "a": "alpha",
///             "b": "bravo",
///             "c": "charlie"
///         },
///         "null": null
///     }
///     """.data(using: .utf8)!
///
///     let decoder = JSONDecoder()
///     let dictionary = try! decoder.decode([String: AnyDecodable].self, from: json)
@frozen public struct AnyDecodable: Decodable {
    public let value: Any

    public init(_ value: Any?) {
        self.value = value ?? ()
    }
}

@usableFromInline
protocol _AnyDecodable {
    var value: Any { get }
    init(_ value: Any?)
}

extension AnyDecodable: _AnyDecodable {}

extension _AnyDecodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self.init(Optional<Self>.none)
        } else if let bool = try? container.decode(Bool.self) {
            self.init(bool)
        } else if let int = try? container.decode(Int.self) {
            self.init(int)
        } else if let uint = try? container.decode(UInt.self) {
            self.init(uint)
        } else if let double = try? container.decode(Double.self) {
            self.init(double)
        } else if let string = try? container.decode(String.self) {
            self.init(string)
        } else if let array = try? container.decode([AnyDecodable].self) {
            self.init(array.map { $0.value })
        } else if let dictionary = try? container.decode([String: AnyDecodable].self) {
            self.init(dictionary.mapValues { $0.value })
        } else {
            throw DecodingError.dataCorruptedError(
                in: container, debugDescription: "AnyDecodable value cannot be decoded")
        }
    }
}

extension AnyDecodable: Equatable {
    public static func == (lhs: AnyDecodable, rhs: AnyDecodable) -> Bool {
        switch (lhs.value, rhs.value) {
        case (let lhs as Bool, let rhs as Bool):
            return lhs == rhs
        case (let lhs as Int, let rhs as Int):
            return lhs == rhs
        case (let lhs as Int8, let rhs as Int8):
            return lhs == rhs
        case (let lhs as Int16, let rhs as Int16):
            return lhs == rhs
        case (let lhs as Int32, let rhs as Int32):
            return lhs == rhs
        case (let lhs as Int64, let rhs as Int64):
            return lhs == rhs
        case (let lhs as UInt, let rhs as UInt):
            return lhs == rhs
        case (let lhs as UInt8, let rhs as UInt8):
            return lhs == rhs
        case (let lhs as UInt16, let rhs as UInt16):
            return lhs == rhs
        case (let lhs as UInt32, let rhs as UInt32):
            return lhs == rhs
        case (let lhs as UInt64, let rhs as UInt64):
            return lhs == rhs
        case (let lhs as Float, let rhs as Float):
            return lhs == rhs
        case (let lhs as Double, let rhs as Double):
            return lhs == rhs
        case (let lhs as String, let rhs as String):
            return lhs == rhs
        case (let lhs as [String: AnyDecodable], let rhs as [String: AnyDecodable]):
            return lhs == rhs
        case (let lhs as [AnyDecodable], let rhs as [AnyDecodable]):
            return lhs == rhs
        default:
            return false
        }
    }
}

extension AnyDecodable: CustomStringConvertible {
    public var description: String {
        switch value {
        case is Void:
            return String(describing: nil as Any?)
        case let value as CustomStringConvertible:
            return value.description
        default:
            return String(describing: value)
        }
    }
}

extension AnyDecodable: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch value {
        case let value as CustomDebugStringConvertible:
            return "AnyDecodable(\(value.debugDescription))"
        default:
            return "AnyDecodable(\(description))"
        }
    }
}

extension AnyDecodable: Hashable {
    public func hash(into hasher: inout Hasher) {
        switch value {
        case let value as Bool:
            hasher.combine(value)
        case let value as Int:
            hasher.combine(value)
        case let value as Int8:
            hasher.combine(value)
        case let value as Int16:
            hasher.combine(value)
        case let value as Int32:
            hasher.combine(value)
        case let value as Int64:
            hasher.combine(value)
        case let value as UInt:
            hasher.combine(value)
        case let value as UInt8:
            hasher.combine(value)
        case let value as UInt16:
            hasher.combine(value)
        case let value as UInt32:
            hasher.combine(value)
        case let value as UInt64:
            hasher.combine(value)
        case let value as Float:
            hasher.combine(value)
        case let value as Double:
            hasher.combine(value)
        case let value as String:
            hasher.combine(value)
        case let value as [String: AnyDecodable]:
            hasher.combine(value)
        case let value as [AnyDecodable]:
            hasher.combine(value)
        default:
            break
        }
    }
}
