import Foundation

extension Duration {
    public static func minutes<T>(_ seconds: T) -> Duration where T: BinaryInteger {
        .seconds(60 * Int(seconds))
    }

    public static func hours<T>(_ seconds: T) -> Duration where T: BinaryInteger {
        .seconds(3600 * Int(seconds))
    }

    public static func days<T>(_ seconds: T) -> Duration where T: BinaryInteger {
        .seconds(86400 * Int(seconds))
    }
}
