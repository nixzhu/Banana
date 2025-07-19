import Foundation
import Banana

extension BananaJSON {
    func bool() -> Bool? {
        rawBool()
    }

    func bool(fallback: Bool = false) -> Bool {
        bool() ?? fallback
    }
}

extension BananaJSON {
    func int() -> Int? {
        rawInt()
    }

    func int(fallback: Int = 0) -> Int {
        int() ?? fallback
    }
}

extension BananaJSON {
    func double() -> Double? {
        rawDouble()
    }

    func double(fallback: Double = 0) -> Double {
        double() ?? fallback
    }
}

extension BananaJSON {
    func string() -> String? {
        rawString()
    }

    func string(fallback: String = "") -> String {
        string() ?? fallback
    }
}

extension BananaJSON {
    func url() -> URL? {
        if let string = rawString() {
            if let url = URL(string: string) {
                return url
            }

            if let encoded = string.addingPercentEncoding(withAllowedCharacters: .testing_url),
               let url = URL(string: encoded)
            {
                return url
            }
        }

        return nil
    }

    func url(fallback: URL = .init(string: "/")!) -> URL {
        url() ?? fallback
    }
}

extension BananaJSON {
    func unixSecondsDate() -> Date? {
        if let seconds = rawDouble() {
            return .init(timeIntervalSince1970: seconds)
        }

        if let string = rawString() {
            if let seconds = TimeInterval(string) {
                return .init(timeIntervalSince1970: seconds)
            }
        }

        return nil
    }

    func unixSecondsDate(fallback: Date = .init(timeIntervalSince1970: 0)) -> Date {
        unixSecondsDate() ?? fallback
    }
}

extension BananaJSON {
    func iso8601Date() -> Date? {
        if let string = rawString() {
            if let date = ISO8601DateFormatter.testing_date(from: string) {
                return date
            }
        }

        return nil
    }

    func iso8601Date(fallback: Date = .distantPast) -> Date {
        iso8601Date() ?? fallback
    }
}

extension CharacterSet {
    fileprivate static let testing_url: Self = {
        var set = CharacterSet.urlQueryAllowed
        set.insert("#")
        set.formUnion(.urlPathAllowed)

        return set
    }()
}

extension ISO8601DateFormatter: @retroactive @unchecked Sendable {
    fileprivate static func testing_date(from string: String) -> Date? {
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
