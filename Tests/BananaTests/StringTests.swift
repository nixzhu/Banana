import Testing
@testable import Banana

@Test func stringIfPresent_strict() async throws {
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
        let a, b, c, d, e: String?

        init(json: BananaJSON) {
            a = json.a.string(.strict)
            b = json.b.string(.strict)
            c = json.c.string(.strict)
            d = json.d.string(.strict)
            e = json.e.string(.strict)
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == "apple")
    #expect(m.b == nil)
    #expect(m.c == "")
    #expect(m.d == nil)
    #expect(m.e == nil)
}

@Test func string_strict() async throws {
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
        let a, b, c, d, e: String

        init(json: BananaJSON) {
            a = json.a.string(.strict)
            b = json.b.string(.strict)
            c = json.c.string(.strict)
            d = json.d.string(.strict)
            e = json.e.string(.strict, fallback: "fallback")
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == "apple")
    #expect(m.b == "")
    #expect(m.c == "")
    #expect(m.d == "")
    #expect(m.e == "fallback")
}

@Test func stringIfPresent_int() async throws {
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
        let a, b, c, d, e: String?

        init(json: BananaJSON) {
            a = json.a.string(.int)
            b = json.b.string(.int)
            c = json.c.string(.int)
            d = json.d.string(.int)
            e = json.e.string(.int)
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == nil)
    #expect(m.b == "123")
    #expect(m.c == nil)
    #expect(m.d == "0")
    #expect(m.e == nil)
}

@Test func string_int() async throws {
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
        let a, b, c, d, e: String

        init(json: BananaJSON) {
            a = json.a.string(.int)
            b = json.b.string(.int)
            c = json.c.string(.int, fallback: "<nil>")
            d = json.d.string(.int)
            e = json.e.string(.int, fallback: "yes")
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == "")
    #expect(m.b == "123")
    #expect(m.c == "<nil>")
    #expect(m.d == "0")
    #expect(m.e == "yes")
}

@Test func stringIfPresent_compatible() async throws {
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
        let a, b, c, d, e: String?

        init(json: BananaJSON) {
            a = json.a.string(.compatible)
            b = json.b.string(.compatible)
            c = json.c.string(.compatible)
            d = json.d.string(.compatible)
            e = json.e.string(.compatible)
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == "apple")
    #expect(m.b == "123")
    #expect(m.c == "")
    #expect(m.d == "0")
    #expect(m.e == nil)
}

@Test func string_compatible() async throws {
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
        let a, b, c, d, e: String

        init(json: BananaJSON) {
            a = json.a.string(.compatible)
            b = json.b.string(.compatible)
            c = json.c.string(.compatible)
            d = json.d.string(.compatible)
            e = json.e.string(.compatible, fallback: "nope")
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == "apple")
    #expect(m.b == "123")
    #expect(m.c == "")
    #expect(m.d == "0")
    #expect(m.e == "nope")
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
        let a, b, c, d: String?

        init(json: BananaJSON) {
            a = json.a.string(.custom(parseString))
            b = json.b.string(.custom(parseString))
            c = json.c.string(.custom(parseString))
            d = json.d.string(.custom(parseString))
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
        let a, b, c, d: String

        init(json: BananaJSON) {
            a = json.a.string(.custom(parseString))
            b = json.b.string(.custom(parseString), fallback: "<empty>")
            c = json.c.string(.custom(parseString))
            d = json.d.string(.custom(parseString), fallback: "<nope>")
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == "hello")
    #expect(m.b == "<empty>")
    #expect(m.c == "int(5)")
    #expect(m.d == "<nope>")
}

private func parseString(_ json: BananaJSON) -> String? {
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
