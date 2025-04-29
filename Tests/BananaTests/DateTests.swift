import Foundation
import Testing
@testable import Banana

@Test func dateIfPresent_iso8601() async throws {
    let jsonString = """
        {
            "a": "2021-10-05T14:48:00Z",
            "b": "2021-10-05T14:48:00.789Z",
            "c": "2021-10-05",
            "d": "2021",
            "e": ""
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e: Date?

        init(json: BananaJSON) {
            a = json.a.dateIfPresent(.iso8601)
            b = json.b.dateIfPresent(.iso8601)
            c = json.c.dateIfPresent(.iso8601)
            d = json.d.dateIfPresent(.iso8601)
            e = json.e.dateIfPresent(.iso8601)
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a == .init(timeIntervalSince1970: 1_633_445_280.0))
    #expect(m.b == .init(timeIntervalSince1970: 1_633_445_280.789))
    #expect(m.c == nil)
    #expect(m.d == nil)
    #expect(m.e == nil)
}

@Test func date_iso8601() async throws {
    let jsonString = """
        {
            "a": "2021-10-05T14:48:00Z",
            "b": "2021-10-05T14:48:00.789Z",
            "c": "2021-10-05",
            "d": "2021",
            "e": ""
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e: Date

        init(json: BananaJSON) {
            a = json.a.date(.iso8601)
            b = json.b.date(.iso8601)
            c = json.c.date(.iso8601)
            d = json.d.date(.iso8601)
            e = json.e.date(.iso8601, fallback: .init(timeIntervalSince1970: 42))
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a == .init(timeIntervalSince1970: 1_633_445_280.0))
    #expect(m.b == .init(timeIntervalSince1970: 1_633_445_280.789))
    #expect(m.c == .distantPast)
    #expect(m.d == .distantPast)
    #expect(m.e == .init(timeIntervalSince1970: 42))
}

@Test func dateIfPresent_unixSeconds() async throws {
    let jsonString = """
        {
            "a": 1633445280,
            "b": 1633445280.123,
            "c": "1633445280",
            "d": "1633445280.123",
            "e": "apple",
            "f": ""
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e, f: Date?

        init(json: BananaJSON) {
            a = json.a.dateIfPresent(.unixSeconds)
            b = json.b.dateIfPresent(.unixSeconds)
            c = json.c.dateIfPresent(.unixSeconds)
            d = json.d.dateIfPresent(.unixSeconds)
            e = json.e.dateIfPresent(.unixSeconds)
            f = json.f.dateIfPresent(.unixSeconds)
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a == .init(timeIntervalSince1970: 1_633_445_280.0))
    #expect(m.b == .init(timeIntervalSince1970: 1_633_445_280.123))
    #expect(m.c == .init(timeIntervalSince1970: 1_633_445_280.0))
    #expect(m.d == .init(timeIntervalSince1970: 1_633_445_280.123))
    #expect(m.e == nil)
    #expect(m.f == nil)
}

@Test func date_unixSeconds() async throws {
    let jsonString = """
        {
            "a": 1633445280,
            "b": 1633445280.123,
            "c": "1633445280",
            "d": "1633445280.123",
            "e": "apple",
            "f": ""
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e, f: Date

        init(json: BananaJSON) {
            a = json.a.date(.unixSeconds)
            b = json.b.date(.unixSeconds)
            c = json.c.date(.unixSeconds)
            d = json.d.date(.unixSeconds)
            e = json.e.date(.unixSeconds)
            f = json.f.date(.unixSeconds, fallback: .init(timeIntervalSince1970: 42))
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a == .init(timeIntervalSince1970: 1_633_445_280.0))
    #expect(m.b == .init(timeIntervalSince1970: 1_633_445_280.123))
    #expect(m.c == .init(timeIntervalSince1970: 1_633_445_280.0))
    #expect(m.d == .init(timeIntervalSince1970: 1_633_445_280.123))
    #expect(m.e == .distantPast)
    #expect(m.f == .init(timeIntervalSince1970: 42))
}

@Test func dateIfPresent_unixMilliseconds() async throws {
    let jsonString = """
        {
            "a": 1633445280000,
            "b": 1633445280123.0,
            "c": "1633445280000",
            "d": "1633445280123.0",
            "e": "apple",
            "f": ""
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e, f: Date?

        init(json: BananaJSON) {
            a = json.a.dateIfPresent(.unixMilliseconds)
            b = json.b.dateIfPresent(.unixMilliseconds)
            c = json.c.dateIfPresent(.unixMilliseconds)
            d = json.d.dateIfPresent(.unixMilliseconds)
            e = json.e.dateIfPresent(.unixMilliseconds)
            f = json.f.dateIfPresent(.unixMilliseconds)
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a == .init(timeIntervalSince1970: 1_633_445_280.0))
    #expect(m.b == .init(timeIntervalSince1970: 1_633_445_280.123))
    #expect(m.c == .init(timeIntervalSince1970: 1_633_445_280.0))
    #expect(m.d == .init(timeIntervalSince1970: 1_633_445_280.123))
    #expect(m.e == nil)
    #expect(m.f == nil)
}

@Test func date_unixMilliseconds() async throws {
    let jsonString = """
        {
            "a": 1633445280000,
            "b": 1633445280123.0,
            "c": "1633445280000",
            "d": "1633445280123.0",
            "e": "apple",
            "f": ""
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e, f: Date

        init(json: BananaJSON) {
            a = json.a.date(.unixMilliseconds)
            b = json.b.date(.unixMilliseconds)
            c = json.c.date(.unixMilliseconds)
            d = json.d.date(.unixMilliseconds)
            e = json.e.date(.unixMilliseconds)
            f = json.f.date(.unixMilliseconds, fallback: .init(timeIntervalSince1970: 42))
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a == .init(timeIntervalSince1970: 1_633_445_280.0))
    #expect(m.b == .init(timeIntervalSince1970: 1_633_445_280.123))
    #expect(m.c == .init(timeIntervalSince1970: 1_633_445_280.0))
    #expect(m.d == .init(timeIntervalSince1970: 1_633_445_280.123))
    #expect(m.e == .distantPast)
    #expect(m.f == .init(timeIntervalSince1970: 42))
}

@Test func dateIfPresent_custom() async throws {
    let jsonString = """
        {
            "a": "apple",
            "b": "other",
            "c": ""
        }
        """

    struct Model: BananaModel {
        let a, b, c: Date?

        init(json: BananaJSON) {
            let parser: (BananaJSON) -> Date? = { json in
                guard json.rawString() == "apple" else { return nil }
                return .init(timeIntervalSince1970: 197_136_000)
            }

            a = json.a.dateIfPresent(.custom(parser))
            b = json.b.dateIfPresent(.custom(parser))
            c = json.c.dateIfPresent(.custom(parser))
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a == .init(timeIntervalSince1970: 197_136_000))
    #expect(m.b == nil)
    #expect(m.c == nil)
}

@Test func date_custom() async throws {
    let jsonString = """
        {
            "a": "apple",
            "b": "other",
            "c": ""
        }
        """

    struct Model: BananaModel {
        let a, b, c: Date

        init(json: BananaJSON) {
            let parser: (BananaJSON) -> Date? = { json in
                guard json.rawString() == "apple" else { return nil }
                return .init(timeIntervalSince1970: 197_136_000)
            }

            a = json.a.date(.custom(parser))
            b = json.b.date(.custom(parser))
            c = json.c.date(.custom(parser), fallback: .init(timeIntervalSince1970: 42))
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a == .init(timeIntervalSince1970: 197_136_000))
    #expect(m.b == .distantPast)
    #expect(m.c == .init(timeIntervalSince1970: 42))
}
