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

    public func dateIfPresent(_ mode: DateMode = .iso8601) -> Date? {
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
        dateIfPresent(mode) ?? fallback
    }
}

#if os(Linux)
extension ISO8601DateFormatter: @retroactive @unchecked Sendable {
    fileprivate static func ananda_date(from string: String) -> Date? {
        if let date = ananda_internetA.date(from: string) {
            return date
        }

        if let date = ananda_internetB.date(from: string) {
            return date
        }

        return nil
    }

    private static let ananda_internetA: ISO8601DateFormatter = {
        let dateFormatter = ISO8601DateFormatter()

        dateFormatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds,
        ]

        return dateFormatter
    }()

    private static let ananda_internetB: ISO8601DateFormatter = {
        let dateFormatter = ISO8601DateFormatter()

        dateFormatter.formatOptions = [
            .withInternetDateTime,
        ]

        return dateFormatter
    }()
}
#else
extension JJLISO8601DateFormatter: @retroactive @unchecked Sendable {
    public static func ananda_date(from string: String) -> Date? {
        if let date = ananda_iso8601A.date(from: string) {
            return date
        }

        if let date = ananda_iso8601B.date(from: string) {
            return date
        }

        return nil
    }

    private static let ananda_iso8601A: JJLISO8601DateFormatter = {
        let dateFormatter = JJLISO8601DateFormatter()

        dateFormatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds,
        ]

        return dateFormatter
    }()

    private static let ananda_iso8601B: JJLISO8601DateFormatter = {
        let dateFormatter = JJLISO8601DateFormatter()

        dateFormatter.formatOptions = [
            .withInternetDateTime,
        ]

        return dateFormatter
    }()
}
#endif
