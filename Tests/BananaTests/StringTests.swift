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
        let a, b, c, d, e: String?

        init(json: BananaJSON) {
            for key in ["a", "b", "c", "d", "e"] {
                #expect(json[key].string() == json[key].string(.normal))
            }

            a = json.a.string(.normal)
            b = json.b.string(.normal)
            c = json.c.string(.normal)
            d = json.d.string(.normal)
            e = json.e.string(.normal)
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
        let a, b, c, d, e: String

        init(json: BananaJSON) {
            for key in ["a", "b", "c", "d", "e"] {
                #expect(json[key].string(fallback: "") == json[key].string(.normal, fallback: ""))
            }

            a = json.a.string(.normal)
            b = json.b.string(.normal)
            c = json.c.string(.normal)
            d = json.d.string(.normal)
            e = json.e.string(.normal, fallback: "fallback")
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
