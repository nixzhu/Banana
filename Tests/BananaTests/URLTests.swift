import Foundation
import Testing
@testable import Banana

@Test func urlIfPresent_normal() async throws {
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
        let a: URL?
        let b: URL?
        let c: URL?
        let d: URL?
        let e: URL?

        init(json: BananaJSON) {
            a = json.a.url()
            b = json.b.url()
            c = json.c.url()
            d = json.d.url()
            e = json.e.url()
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a?.absoluteString == "https://example.com")
    #expect(m.b?.absoluteString == "https://example.com/path?query=#frag")
    #expect(m.c?.absoluteString == "https://example.com/%E8%8B%B9%E6%9E%9C")
    #expect(m.d == nil)
    #expect(m.e == nil)
}

@Test func url_normal() async throws {
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
        let a: URL
        let b: URL
        let c: URL
        let d: URL
        let e: URL

        init(json: BananaJSON) {
            a = json.a.url()
            b = json.b.url()
            c = json.c.url()
            d = json.d.url()
            e = json.e.url(fallback: .init(string: "/fallback")!)
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

    func customURL(_ json: BananaJSON) -> URL? {
        if let string = json.rawString(), string.hasPrefix("https") {
            return URL(string: string + "/ok")
        }

        if let int = json.rawInt() {
            return URL(string: "int://\(int)")
        }

        return nil
    }

    struct Model: BananaModel {
        let a: URL?
        let b: URL?
        let c: URL?

        init(json: BananaJSON) {
            a = json.a.parse(customURL)
            b = json.b.parse(customURL)
            c = json.c.parse(customURL)
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

    func customURL(_ json: BananaJSON) -> URL {
        if let string = json.rawString(), string.hasPrefix("https") {
            if let url = URL(string: string + "/ok") {
                return url
            }
        }

        if let int = json.rawInt() {
            if let url = URL(string: "int://\(int)") {
                return url
            }
        }

        return .init(string: "/fallback")!
    }

    struct Model: BananaModel {
        let a: URL
        let b: URL
        let c: URL

        init(json: BananaJSON) {
            a = json.a.parse(customURL)
            b = json.b.parse(customURL)
            c = json.c.parse(customURL)
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a.absoluteString == "https://custom.com/ok")
    #expect(m.b.absoluteString == "int://0")
    #expect(m.c.absoluteString == "/fallback")
}
