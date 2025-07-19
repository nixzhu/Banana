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
        let a: Date?
        let b: Date?
        let c: Date?
        let d: Date?
        let e: Date?

        init(json: BananaJSON) {
            a = json.a.iso8601Date()
            b = json.b.iso8601Date()
            c = json.c.iso8601Date()
            d = json.d.iso8601Date()
            e = json.e.iso8601Date()
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
        let a1: Date
        let a2: Date
        let b1: Date
        let b2: Date
        let c: Date
        let d: Date
        let e: Date
        let f: Date
        let g: Date

        init(json: BananaJSON) {
            a1 = json.a1.iso8601Date()
            a2 = json.a2.iso8601Date()
            b1 = json.b1.iso8601Date()
            b2 = json.b2.iso8601Date()
            c = json.c.iso8601Date()
            d = json.d.iso8601Date()
            e = json.e.iso8601Date()
            f = json.f.iso8601Date()
            g = json.g.iso8601Date() ?? .init(timeIntervalSince1970: 42)
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
        let a: Date?
        let b: Date?
        let c: Date?
        let d: Date?
        let e: Date?
        let f: Date?

        init(json: BananaJSON) {
            a = json.a.unixSecondsDate()
            b = json.b.unixSecondsDate()
            c = json.c.unixSecondsDate()
            d = json.d.unixSecondsDate()
            e = json.e.unixSecondsDate()
            f = json.f.unixSecondsDate()
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
        let a: Date
        let b: Date
        let c: Date
        let d: Date
        let e: Date
        let f: Date

        init(json: BananaJSON) {
            a = json.a.unixSecondsDate()
            b = json.b.unixSecondsDate()
            c = json.c.unixSecondsDate()
            d = json.d.unixSecondsDate()
            e = json.e.unixSecondsDate()
            f = json.f.unixSecondsDate() ?? .init(timeIntervalSince1970: 42)
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a == .init(timeIntervalSince1970: 1_633_445_280.0))
    #expect(m.b == .init(timeIntervalSince1970: 1_633_445_280.123))
    #expect(m.c == .init(timeIntervalSince1970: 1_633_445_280.0))
    #expect(m.d == .init(timeIntervalSince1970: 1_633_445_280.123))
    #expect(m.e == .init(timeIntervalSince1970: 0))
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
        let a: Date?
        let b: Date?
        let c: Date?

        init(json: BananaJSON) {
            let customDate: (BananaJSON) -> Date? = { json in
                guard json.rawString() == "apple" else { return nil }

                return .init(timeIntervalSince1970: 197_136_000)
            }

            a = json.a.parse(customDate)
            b = json.b.parse(customDate)
            c = json.c.parse(customDate)
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
        let a: Date
        let b: Date
        let c: Date

        init(json: BananaJSON) {
            let customDate: (BananaJSON) -> Date? = { json in
                guard json.rawString() == "apple" else { return nil }

                return .init(timeIntervalSince1970: 197_136_000)
            }

            a = json.a.parse(customDate) ?? .distantPast
            b = json.b.parse(customDate) ?? .distantPast
            c = json.c.parse(customDate) ?? .init(timeIntervalSince1970: 42)
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a == .init(timeIntervalSince1970: 197_136_000))
    #expect(m.b == .distantPast)
    #expect(m.c == .init(timeIntervalSince1970: 42))
}
