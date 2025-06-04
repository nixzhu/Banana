import Foundation

#if !os(Linux)
import JJLISO8601DateFormatter
#endif

extension BananaJSON {
    public enum DateMode {
        case iso8601
        case unixSeconds
        case unixMilliseconds
        case custom((BananaJSON) -> Date?)
    }

    public func date(_ mode: DateMode = .iso8601) -> Date? {
        switch mode {
        case .iso8601:
            if let string = rawString() {
                #if os(Linux)
                if let date = ISO8601DateFormatter.ananda_date(from: string) {
                    return date
                }
                #else
                if let date = JJLISO8601DateFormatter.ananda_date(from: string) {
                    return date
                }
                #endif
            }
        case .unixSeconds:
            if let seconds = rawDouble() {
                return .init(timeIntervalSince1970: seconds)
            }

            if let string = rawString() {
                if let seconds = TimeInterval(string) {
                    return .init(timeIntervalSince1970: seconds)
                }
            }
        case .unixMilliseconds:
            if let milliseconds = rawDouble() {
                return .init(timeIntervalSince1970: milliseconds / 1000)
            }

            if let string = rawString() {
                if let milliseconds = TimeInterval(string) {
                    return .init(timeIntervalSince1970: milliseconds / 1000)
                }
            }
        case .custom(let parse):
            if let value = parse(self) {
                return value
            }
        }

        return nil
    }

    public func date(_ mode: DateMode = .iso8601, fallback: Date = .distantPast) -> Date {
        date(mode) ?? fallback
    }
}

#if os(Linux)
extension ISO8601DateFormatter: @retroactive @unchecked Sendable {
    fileprivate static func ananda_date(from string: String) -> Date? {
        for formatter in formatters {
            if let date = formatter.date(from: string) {
                return date
            }
        }

        return nil
    }

    private static let formatters: [ISO8601DateFormatter] = [
        internetWithFractional,
        internetWithoutFractional,
    ]

    private static let internetWithFractional: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()

        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds,
        ]

        return formatter
    }()

    private static let internetWithoutFractional: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()

        formatter.formatOptions = [
            .withInternetDateTime,
        ]

        return formatter
    }()
}
#else
extension JJLISO8601DateFormatter: @retroactive @unchecked Sendable {
    fileprivate static func ananda_date(from string: String) -> Date? {
        for formatter in formatters {
            if let date = formatter.date(from: string) {
                return date
            }
        }

        return nil
    }

    private static let formatters: [JJLISO8601DateFormatter] = [
        internetWithFractional,
        internetWithoutFractional,
    ]

    private static let internetWithFractional: JJLISO8601DateFormatter = {
        let formatter = JJLISO8601DateFormatter()

        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds,
        ]

        return formatter
    }()

    private static let internetWithoutFractional: JJLISO8601DateFormatter = {
        let formatter = JJLISO8601DateFormatter()

        formatter.formatOptions = [
            .withInternetDateTime,
        ]

        return formatter
    }()
}
#endif
