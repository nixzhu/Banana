import Testing
@testable import Banana

@Test func boolIfPresent_normal() async throws {
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
                #expect(json[key].bool() == json[key].bool(.normal))
            }

            a = json.a.bool(.normal)
            b = json.b.bool(.normal)
            c = json.c.bool(.normal)
            d = json.d.bool(.normal)
            e = json.e.bool(.normal)
            f = json.f.bool(.normal)
            g = json.g.bool(.normal)
            h = json.h.bool(.normal)
            i = json.i.bool(.normal)
            j = json.j.bool(.normal)
            k = json.k.bool(.normal)
            l = json.l.bool(.normal)
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

@Test func bool_normal() async throws {
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
                #expect(json[key].bool(fallback: false) == json[key].bool(.normal, fallback: false))
            }

            a = json.a.bool(.normal)
            b = json.b.bool(.normal)
            c = json.c.bool(.normal)
            d = json.d.bool(.normal)
            e = json.e.bool(.normal)
            f = json.f.bool(.normal)
            g = json.g.bool(.normal)
            h = json.h.bool(.normal)
            i = json.i.bool(.normal)
            j = json.j.bool(.normal)
            k = json.k.bool(.normal)
            l = json.l.bool(.normal, fallback: true)
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
