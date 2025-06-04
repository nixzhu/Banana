import Foundation
import Testing
@testable import Banana

@Test func urlIfPresent_compatible() async throws {
    let jsonString = """
        {
            "a": "https://example.com",
            "b": "https://example.com/path?query=#frag",
            "c": "https://example.com/苹果",
            "d": 42,
            "e": ""
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e: URL?

        init(json: BananaJSON) {
            a = json.a.url(.compatible)
            b = json.b.url(.compatible)
            c = json.c.url(.compatible)
            d = json.d.url(.compatible)
            e = json.e.url(.compatible)
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a?.absoluteString == "https://example.com")
    #expect(m.b?.absoluteString == "https://example.com/path?query=#frag")
    #expect(m.c?.absoluteString == "https://example.com/%E8%8B%B9%E6%9E%9C")
    #expect(m.d == nil)
    #expect(m.e == nil)
}

@Test func url_compatible() async throws {
    let jsonString = """
        {
            "a": "https://example.com",
            "b": "https://example.com/path?query=#frag",
            "c": "https://example.com/苹果",
            "d": 42,
            "e": ""
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e: URL

        init(json: BananaJSON) {
            a = json.a.url(.compatible)
            b = json.b.url(.compatible)
            c = json.c.url(.compatible)
            d = json.d.url(.compatible)
            e = json.e.url(.compatible, fallback: .init(string: "/fallback")!)
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a.absoluteString == "https://example.com")
    #expect(m.b.absoluteString == "https://example.com/path?query=#frag")
    #expect(m.c.absoluteString == "https://example.com/%E8%8B%B9%E6%9E%9C")
    #expect(m.d.absoluteString == "/")
    #expect(m.e.absoluteString == "/fallback")
}

@Test func urlIfPresent_custom() async throws {
    let jsonString = """
        {
            "a": "https://custom.com",
            "b": 123,
            "c": "bad//url"
        }
        """

    func parse(_ json: BananaJSON) -> URL? {
        if let string = json.rawString(), string.hasPrefix("https") {
            return URL(string: string + "/ok")
        }

        if let int = json.rawInt() {
            return URL(string: "int://\(int)")
        }

        return nil
    }

    struct Model: BananaModel {
        let a, b, c: URL?

        init(json: BananaJSON) {
            a = json.a.url(.custom(parse))
            b = json.b.url(.custom(parse))
            c = json.c.url(.custom(parse))
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a?.absoluteString == "https://custom.com/ok")
    #expect(m.b?.absoluteString == "int://123")
    #expect(m.c == nil)
}

@Test func url_custom() async throws {
    let jsonString = """
        {
            "a": "https://custom.com",
            "b": 0,
            "c": "bad//url"
        }
        """

    func parse(_ json: BananaJSON) -> URL? {
        if let string = json.rawString(), string.hasPrefix("https") {
            return URL(string: string + "/ok")
        }

        if let int = json.rawInt() {
            return URL(string: "int://\(int)")
        }

        return nil
    }

    struct Model: BananaModel {
        let a, b, c: URL

        init(json: BananaJSON) {
            a = json.a.url(.custom(parse), fallback: .init(string: "/fallback")!)
            b = json.b.url(.custom(parse), fallback: .init(string: "/fallback")!)
            c = json.c.url(.custom(parse), fallback: .init(string: "/fallback")!)
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a.absoluteString == "https://custom.com/ok")
    #expect(m.b.absoluteString == "int://0")
    #expect(m.c.absoluteString == "/fallback")
}
