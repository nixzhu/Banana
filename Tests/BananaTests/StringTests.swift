import Testing
@testable import Banana

@Test func stringIfPresent_normal() async throws {
    let jsonString = """
    {
        "a": "apple",
        "b": 123,
        "c": "",
        "d": 0,
        "e": true
    }
    """

    struct Model: BananaModel {
        let a: String?
        let b: String?
        let c: String?
        let d: String?
        let e: String?

        init(json: BananaJSON) {
            a = json.a.string()
            b = json.b.string()
            c = json.c.string()
            d = json.d.string()
            e = json.e.string()
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == "apple")
    #expect(m.b == nil)
    #expect(m.c == "")
    #expect(m.d == nil)
    #expect(m.e == nil)
}

@Test func string_normal() async throws {
    let jsonString = """
    {
        "a": "apple",
        "b": 123,
        "c": "",
        "d": 0,
        "e": true
    }
    """

    struct Model: BananaModel {
        let a: String
        let b: String
        let c: String
        let d: String
        let e: String

        init(json: BananaJSON) {
            a = json.a.string()
            b = json.b.string()
            c = json.c.string()
            d = json.d.string()
            e = json.e.string(fallback: "fallback")
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == "apple")
    #expect(m.b == "")
    #expect(m.c == "")
    #expect(m.d == "")
    #expect(m.e == "fallback")
}

@Test func stringIfPresent_custom() async throws {
    let jsonString = """
    {
        "a": "  hello ",
        "b": "",
        "c": 5,
        "d": false
    }
    """

    struct Model: BananaModel {
        let a: String?
        let b: String?
        let c: String?
        let d: String?

        init(json: BananaJSON) {
            a = json.a.parse(customString)
            b = json.b.parse(customString)
            c = json.c.parse(customString)
            d = json.d.parse(customString)
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == "hello")
    #expect(m.b == nil)
    #expect(m.c == "int(5)")
    #expect(m.d == nil)
}

@Test func string_custom() async throws {
    let jsonString = """
    {
        "a": "  hello ",
        "b": "",
        "c": 5,
        "d": false
    }
    """

    struct Model: BananaModel {
        let a: String
        let b: String
        let c: String
        let d: String

        init(json: BananaJSON) {
            a = json.a.parse(customString) ?? ""
            b = json.b.parse(customString) ?? "<empty>"
            c = json.c.parse(customString) ?? ""
            d = json.d.parse(customString) ?? "<nope>"
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == "hello")
    #expect(m.b == "<empty>")
    #expect(m.c == "int(5)")
    #expect(m.d == "<nope>")
}

private func customString(_ json: BananaJSON) -> String? {
    if let string = json.rawString()?.trimmingCharacters(in: .whitespaces),
       !string.isEmpty
    {
        return string
    }

    if let int = json.rawInt() {
        return "int(\(int))"
    }

    return nil
}
