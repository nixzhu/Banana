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
            a = json.a.date(.iso8601)
            b = json.b.date(.iso8601)
            c = json.c.date(.iso8601)
            d = json.d.date(.iso8601)
            e = json.e.date(.iso8601)
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

            "a1": "2021-10-05T14:48:00.789Z",
            "a2": "2021-10-05T14:48:10.789+02:00",
            "b1": "2021-10-05T14:48:00Z",
            "b2": "2021-10-05T14:48:10+02:00",
            "c": "2023-05-17T15:32:46.123",
            "d": "2023-05-17T15:32:46",
            "e": "2021-10-05",
            "f": "2021",
            "g": ""
        }
        """

    struct Model: BananaModel {
        let a1, a2, b1, b2, c, d, e, f, g: Date

        init(json: BananaJSON) {
            a1 = json.a1.date(.iso8601)
            a2 = json.a2.date(.iso8601)
            b1 = json.b1.date(.iso8601)
            b2 = json.b2.date(.iso8601)
            c = json.c.date(.iso8601)
            d = json.d.date(.iso8601)
            e = json.e.date(.iso8601)
            f = json.f.date(.iso8601)
            g = json.g.date(.iso8601, fallback: .init(timeIntervalSince1970: 42))
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a1 == .init(timeIntervalSince1970: 1_633_445_280.789))
    #expect(m.a2 == .init(timeIntervalSince1970: 1_633_438_090.789))
    #expect(m.b1 == .init(timeIntervalSince1970: 1_633_445_280))
    #expect(m.b2 == .init(timeIntervalSince1970: 1_633_438_090))
    #expect(m.c == .distantPast)
    #expect(m.d == .distantPast)
    #expect(m.e == .distantPast)
    #expect(m.f == .distantPast)
    #expect(m.g == .init(timeIntervalSince1970: 42))
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
            a = json.a.date(.unixSeconds)
            b = json.b.date(.unixSeconds)
            c = json.c.date(.unixSeconds)
            d = json.d.date(.unixSeconds)
            e = json.e.date(.unixSeconds)
            f = json.f.date(.unixSeconds)
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
            a = json.a.date(.unixMilliseconds)
            b = json.b.date(.unixMilliseconds)
            c = json.c.date(.unixMilliseconds)
            d = json.d.date(.unixMilliseconds)
            e = json.e.date(.unixMilliseconds)
            f = json.f.date(.unixMilliseconds)
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

            a = json.a.date(.custom(parser))
            b = json.b.date(.custom(parser))
            c = json.c.date(.custom(parser))
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
