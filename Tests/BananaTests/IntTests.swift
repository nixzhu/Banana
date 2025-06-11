import Testing
@testable import Banana

@Test func intIfPresent_strict() async throws {
    let jsonString = """
        {
            "a": true,
            "b": false,
            "c": 0,
            "d": 1,
            "e": -2,
            "f": 99.9,
            "g": "100",
            "h": "apple",
            "i": "0x2A",
            "j": ""
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e, f, g, h, i, j: Int?

        init(json: BananaJSON) {
            for key in ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"] {
                #expect(json[key].int() == json[key].int(.strict))
            }

            a = json.a.int(.strict)
            b = json.b.int(.strict)
            c = json.c.int(.strict)
            d = json.d.int(.strict)
            e = json.e.int(.strict)
            f = json.f.int(.strict)
            g = json.g.int(.strict)
            h = json.h.int(.strict)
            i = json.i.int(.strict)
            j = json.j.int(.strict)
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a == nil)
    #expect(m.b == nil)
    #expect(m.c == 0)
    #expect(m.d == 1)
    #expect(m.e == -2)
    #expect(m.f == nil)
    #expect(m.g == nil)
    #expect(m.h == nil)
    #expect(m.i == nil)
    #expect(m.j == nil)
}

@Test func int_strict() async throws {
    let jsonString = """
        {
            "a": true,
            "b": false,
            "c": 0,
            "d": 1,
            "e": -2,
            "f": 99.9,
            "g": "100",
            "h": "apple",
            "i": "0x2A",
            "j": ""
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e, f, g, h, i, j: Int

        init(json: BananaJSON) {
            for key in ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"] {
                #expect(json[key].int(fallback: 0) == json[key].int(.strict, fallback: 0))
            }

            a = json.a.int(.strict)
            b = json.b.int(.strict)
            c = json.c.int(.strict)
            d = json.d.int(.strict)
            e = json.e.int(.strict)
            f = json.f.int(.strict)
            g = json.g.int(.strict)
            h = json.h.int(.strict)
            i = json.i.int(.strict)
            j = json.j.int(.strict, fallback: 42)
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == 0)
    #expect(m.b == 0)
    #expect(m.c == 0)
    #expect(m.d == 1)
    #expect(m.e == -2)
    #expect(m.f == 0)
    #expect(m.g == 0)
    #expect(m.h == 0)
    #expect(m.i == 0)
    #expect(m.j == 42)
}

@Test func intIfPresent_string() async throws {
    let jsonString = """
        {
            "a": "123",
            "b": "apple",
            "c": "0",
            "d": "-10",
            "e": "",
            "f": 55
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e, f: Int?

        init(json: BananaJSON) {
            a = json.a.int(.string)
            b = json.b.int(.string)
            c = json.c.int(.string)
            d = json.d.int(.string)
            e = json.e.int(.string)
            f = json.f.int(.string)
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == 123)
    #expect(m.b == nil)
    #expect(m.c == 0)
    #expect(m.d == -10)
    #expect(m.e == nil)
    #expect(m.f == nil)
}

@Test func int_string() async throws {
    let jsonString = """
        {
            "a": "123",
            "b": "apple",
            "c": "0",
            "d": "-10",
            "e": "",
            "f": 55
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e, f: Int

        init(json: BananaJSON) {
            a = json.a.int(.string)
            b = json.b.int(.string, fallback: -1)
            c = json.c.int(.string)
            d = json.d.int(.string)
            e = json.e.int(.string)
            f = json.f.int(.string)
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a == 123)
    #expect(m.b == -1)
    #expect(m.c == 0)
    #expect(m.d == -10)
    #expect(m.e == 0)
    #expect(m.f == 0)
}

@Test func intIfPresent_compatible() async throws {
    let jsonString = """
        {
            "a": 10,
            "b": "20",
            "c": "apple",
            "d": 0,
            "e": "",
            "f": 3.14
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e, f: Int?

        init(json: BananaJSON) {
            a = json.a.int(.compatible)
            b = json.b.int(.compatible)
            c = json.c.int(.compatible)
            d = json.d.int(.compatible)
            e = json.e.int(.compatible)
            f = json.f.int(.compatible)
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == 10)
    #expect(m.b == 20)
    #expect(m.c == nil)
    #expect(m.d == 0)
    #expect(m.e == nil)
    #expect(m.f == nil)
}

@Test func int_compatible() async throws {
    let jsonString = """
        {
            "a": 10,
            "b": "20",
            "c": "apple",
            "d": 0,
            "e": "",
            "f": 3.14
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e, f: Int

        init(json: BananaJSON) {
            a = json.a.int(.compatible)
            b = json.b.int(.compatible)
            c = json.c.int(.compatible, fallback: -5)
            d = json.d.int(.compatible)
            e = json.e.int(.compatible)
            f = json.f.int(.compatible)
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == 10)
    #expect(m.b == 20)
    #expect(m.c == -5)
    #expect(m.d == 0)
    #expect(m.e == 0)
    #expect(m.f == 0)
}

@Test func intIfPresent_custom() async throws {
    let jsonString = """
        {
            "a": true,
            "b": "50",
            "c": 0,
            "d": "0x2A",
            "e": "apple",
            "f": "",
            "g": "0xFF"
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e, f, g: Int?

        init(json: BananaJSON) {
            a = json.a.int(.custom(parseInt))
            b = json.b.int(.custom(parseInt))
            c = json.c.int(.custom(parseInt))
            d = json.d.int(.custom(parseInt))
            e = json.e.int(.custom(parseInt))
            f = json.f.int(.custom(parseInt))
            g = json.g.int(.custom(parseInt))
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == nil)
    #expect(m.b == 50)
    #expect(m.c == 0)
    #expect(m.d == 42)
    #expect(m.e == nil)
    #expect(m.f == nil)
    #expect(m.g == 255)
}

@Test func int_custom() async throws {
    let jsonString = """
        {
            "a": "123",
            "b": "0x10",
            "c": "apple",
            "d": 7
        }
        """

    struct Model: BananaModel {
        let a, b, c, d: Int

        init(json: BananaJSON) {
            a = json.a.int(.custom(parseInt))
            b = json.b.int(.custom(parseInt))
            c = json.c.int(.custom(parseInt), fallback: -1)
            d = json.d.int(.custom(parseInt))
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == 123)
    #expect(m.b == 16)
    #expect(m.c == -1)
    #expect(m.d == 7)
}

private func parseInt(_ json: BananaJSON) -> Int? {
    if let int = json.rawInt() {
        return int
    }

    if let string = json.rawString() {
        if let int = Int(string) {
            return int
        }

        if string.hasPrefix("0x"),
           let int = Int(string.dropFirst(2), radix: 16)
        {
            return int
        }
    }

    return nil
}
