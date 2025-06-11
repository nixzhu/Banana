import Testing
@testable import Banana

@Test func boolIfPresent_strict() async throws {
    let jsonString = """
        {
            "a": true,
            "b": false,
            "c": 0,
            "d": 1,
            "e": -2,
            "f": 99.9,
            "g": "true",
            "h": "false",
            "i": "apple",
            "j": "0",
            "k": "1",
            "l": ""
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e, f, g, h, i, j, k, l: Bool?

        init(json: BananaJSON) {
            for key in ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l"] {
                #expect(json[key].bool() == json[key].bool(.strict))
            }

            a = json.a.bool(.strict)
            b = json.b.bool(.strict)
            c = json.c.bool(.strict)
            d = json.d.bool(.strict)
            e = json.e.bool(.strict)
            f = json.f.bool(.strict)
            g = json.g.bool(.strict)
            h = json.h.bool(.strict)
            i = json.i.bool(.strict)
            j = json.j.bool(.strict)
            k = json.k.bool(.strict)
            l = json.l.bool(.strict)
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a == true)
    #expect(m.b == false)
    #expect(m.c == nil)
    #expect(m.d == nil)
    #expect(m.e == nil)
    #expect(m.f == nil)
    #expect(m.g == nil)
    #expect(m.h == nil)
    #expect(m.i == nil)
    #expect(m.j == nil)
    #expect(m.k == nil)
    #expect(m.l == nil)
}

@Test func bool_strict() async throws {
    let jsonString = """
        {
            "a": true,
            "b": false,
            "c": 0,
            "d": 1,
            "e": -2,
            "f": 99.9,
            "g": "true",
            "h": "false",
            "i": "apple",
            "j": "0",
            "k": "1",
            "l": ""
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e, f, g, h, i, j, k, l: Bool

        init(json: BananaJSON) {
            for key in ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l"] {
                #expect(json[key].bool(fallback: false) == json[key].bool(.strict, fallback: false))
            }

            a = json.a.bool(.strict)
            b = json.b.bool(.strict)
            c = json.c.bool(.strict)
            d = json.d.bool(.strict)
            e = json.e.bool(.strict)
            f = json.f.bool(.strict)
            g = json.g.bool(.strict)
            h = json.h.bool(.strict)
            i = json.i.bool(.strict)
            j = json.j.bool(.strict)
            k = json.k.bool(.strict)
            l = json.l.bool(.strict, fallback: true)
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a == true)
    #expect(m.b == false)
    #expect(m.c == false)
    #expect(m.d == false)
    #expect(m.e == false)
    #expect(m.f == false)
    #expect(m.g == false)
    #expect(m.h == false)
    #expect(m.i == false)
    #expect(m.j == false)
    #expect(m.k == false)
    #expect(m.l == true)
}

@Test func boolIfPresent_int() async throws {
    let jsonString = """
        {
            "a": true,
            "b": false,
            "c": 0,
            "d": 1,
            "e": -2,
            "f": 99.9,
            "g": "true",
            "h": "false",
            "i": "apple",
            "j": "0",
            "k": "1",
            "l": ""
        }
        """
    struct Model: BananaModel {
        let a, b, c, d, e, f, g, h, i, j, k, l: Bool?

        init(json: BananaJSON) {
            a = json.a.bool(.int)
            b = json.b.bool(.int)
            c = json.c.bool(.int)
            d = json.d.bool(.int)
            e = json.e.bool(.int)
            f = json.f.bool(.int)
            g = json.g.bool(.int)
            h = json.h.bool(.int)
            i = json.i.bool(.int)
            j = json.j.bool(.int)
            k = json.k.bool(.int)
            l = json.l.bool(.int)
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a == nil)
    #expect(m.b == nil)
    #expect(m.c == false)
    #expect(m.d == true)
    #expect(m.e == nil)
    #expect(m.f == nil)
    #expect(m.g == nil)
    #expect(m.h == nil)
    #expect(m.i == nil)
    #expect(m.j == nil)
    #expect(m.k == nil)
    #expect(m.l == nil)
}

@Test func bool_int() async throws {
    let jsonString = """
        {
            "a": true,
            "b": false,
            "c": 0,
            "d": 1,
            "e": -2,
            "f": 99.9,
            "g": "true",
            "h": "false",
            "i": "apple",
            "j": "0",
            "k": "1",
            "l": ""
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e, f, g, h, i, j, k, l: Bool

        init(json: BananaJSON) {
            a = json.a.bool(.int)
            b = json.b.bool(.int)
            c = json.c.bool(.int)
            d = json.d.bool(.int)
            e = json.e.bool(.int)
            f = json.f.bool(.int)
            g = json.g.bool(.int)
            h = json.h.bool(.int)
            i = json.i.bool(.int)
            j = json.j.bool(.int)
            k = json.k.bool(.int)
            l = json.l.bool(.int, fallback: true)
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a == false)
    #expect(m.b == false)
    #expect(m.c == false)
    #expect(m.d == true)
    #expect(m.e == false)
    #expect(m.f == false)
    #expect(m.g == false)
    #expect(m.h == false)
    #expect(m.i == false)
    #expect(m.j == false)
    #expect(m.k == false)
    #expect(m.l == true)
}

@Test func boolIfPresent_compatible() async throws {
    let jsonString = """
        {
            "a": true,
            "b": false,
            "c": 0,
            "d": 1,
            "e": -2,
            "f": 99.9,
            "g": "true",
            "h": "false",
            "i": "apple",
            "j": "0",
            "k": "1",
            "l": ""
        }
        """
    struct Model: BananaModel {
        let a, b, c, d, e, f, g, h, i, j, k, l: Bool?

        init(json: BananaJSON) {
            a = json.a.bool(.compatible)
            b = json.b.bool(.compatible)
            c = json.c.bool(.compatible)
            d = json.d.bool(.compatible)
            e = json.e.bool(.compatible)
            f = json.f.bool(.compatible)
            g = json.g.bool(.compatible)
            h = json.h.bool(.compatible)
            i = json.i.bool(.compatible)
            j = json.j.bool(.compatible)
            k = json.k.bool(.compatible)
            l = json.l.bool(.compatible)
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a == true)
    #expect(m.b == false)
    #expect(m.c == false)
    #expect(m.d == true)
    #expect(m.e == nil)
    #expect(m.f == nil)
    #expect(m.g == nil)
    #expect(m.h == nil)
    #expect(m.i == nil)
    #expect(m.j == nil)
    #expect(m.k == nil)
    #expect(m.l == nil)
}

@Test func bool_compatible() async throws {
    let jsonString = """
        {
            "a": true,
            "b": false,
            "c": 0,
            "d": 1,
            "e": -2,
            "f": 99.9,
            "g": "true",
            "h": "false",
            "i": "apple",
            "j": "0",
            "k": "1",
            "l": ""
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e, f, g, h, i, j, k, l: Bool

        init(json: BananaJSON) {
            a = json.a.bool(.compatible)
            b = json.b.bool(.compatible)
            c = json.c.bool(.compatible)
            d = json.d.bool(.compatible)
            e = json.e.bool(.compatible)
            f = json.f.bool(.compatible)
            g = json.g.bool(.compatible)
            h = json.h.bool(.compatible)
            i = json.i.bool(.compatible)
            j = json.j.bool(.compatible)
            k = json.k.bool(.compatible)
            l = json.l.bool(.compatible, fallback: true)
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a == true)
    #expect(m.b == false)
    #expect(m.c == false)
    #expect(m.d == true)
    #expect(m.e == false)
    #expect(m.f == false)
    #expect(m.g == false)
    #expect(m.h == false)
    #expect(m.i == false)
    #expect(m.j == false)
    #expect(m.k == false)
    #expect(m.l == true)
}

@Test func boolIfPresent_custom() async throws {
    let jsonString = """
        {
            "a": true,
            "b": false,
            "c": 0,
            "d": 1,
            "e": -2,
            "f": 99.9,
            "g": "true",
            "h": "false",
            "i": "apple",
            "j": "0",
            "k": "1",
            "l": "2",
            "m": ""
        }
        """
    struct Model: BananaModel {
        let a, b, c, d, e, f, g, h, i, j, k, l, m: Bool?

        init(json: BananaJSON) {
            a = json.a.bool(.custom(parseBool))
            b = json.b.bool(.custom(parseBool))
            c = json.c.bool(.custom(parseBool))
            d = json.d.bool(.custom(parseBool))
            e = json.e.bool(.custom(parseBool))
            f = json.f.bool(.custom(parseBool))
            g = json.g.bool(.custom(parseBool))
            h = json.h.bool(.custom(parseBool))
            i = json.i.bool(.custom(parseBool))
            j = json.j.bool(.custom(parseBool))
            k = json.k.bool(.custom(parseBool))
            l = json.l.bool(.custom(parseBool))
            m = json.m.bool(.custom(parseBool))
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a == true)
    #expect(m.b == false)
    #expect(m.c == false)
    #expect(m.d == true)
    #expect(m.e == nil)
    #expect(m.f == nil)
    #expect(m.g == true)
    #expect(m.h == false)
    #expect(m.i == nil)
    #expect(m.j == false)
    #expect(m.k == true)
    #expect(m.l == nil)
    #expect(m.m == nil)
}

@Test func bool_custom() async throws {
    let jsonString = """
        {
            "a": true,
            "b": false,
            "c": 0,
            "d": 1,
            "e": -2,
            "f": 99.9,
            "g": "true",
            "h": "false",
            "i": "apple",
            "j": "0",
            "k": "1",
            "l": "2",
            "m": ""
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e, f, g, h, i, j, k, l, m: Bool

        init(json: BananaJSON) {
            a = json.a.bool(.custom(parseBool))
            b = json.b.bool(.custom(parseBool))
            c = json.c.bool(.custom(parseBool))
            d = json.d.bool(.custom(parseBool))
            e = json.e.bool(.custom(parseBool))
            f = json.f.bool(.custom(parseBool))
            g = json.g.bool(.custom(parseBool))
            h = json.h.bool(.custom(parseBool))
            i = json.i.bool(.custom(parseBool))
            j = json.j.bool(.custom(parseBool))
            k = json.k.bool(.custom(parseBool))
            l = json.l.bool(.custom(parseBool))
            m = json.m.bool(.custom(parseBool), fallback: true)
        }
    }

    let m = Model.decode(from: jsonString)
    #expect(m.a == true)
    #expect(m.b == false)
    #expect(m.c == false)
    #expect(m.d == true)
    #expect(m.e == false)
    #expect(m.f == false)
    #expect(m.g == true)
    #expect(m.h == false)
    #expect(m.i == false)
    #expect(m.j == false)
    #expect(m.k == true)
    #expect(m.l == false)
    #expect(m.m == true)
}

private func parseBool(_ json: BananaJSON) -> Bool? {
    if let bool = json.rawBool() {
        return bool
    }

    if let int = json.rawInt() {
        switch int {
        case 0:
            return false
        case 1:
            return true
        default:
            break
        }
    }

    if let value = json.rawString() {
        switch value {
        case "true", "1":
            return true
        case "false", "0":
            return false
        default:
            break
        }
    }

    return nil
}
