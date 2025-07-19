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
        let a: Bool?
        let b: Bool?
        let c: Bool?
        let d: Bool?
        let e: Bool?
        let f: Bool?
        let g: Bool?
        let h: Bool?
        let i: Bool?
        let j: Bool?
        let k: Bool?
        let l: Bool?

        init(json: BananaJSON) {
            a = json.a.bool()
            b = json.b.bool()
            c = json.c.bool()
            d = json.d.bool()
            e = json.e.bool()
            f = json.f.bool()
            g = json.g.bool()
            h = json.h.bool()
            i = json.i.bool()
            j = json.j.bool()
            k = json.k.bool()
            l = json.l.bool()
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
        let a: Bool
        let b: Bool
        let c: Bool
        let d: Bool
        let e: Bool
        let f: Bool
        let g: Bool
        let h: Bool
        let i: Bool
        let j: Bool
        let k: Bool
        let l: Bool

        init(json: BananaJSON) {
            a = json.a.bool()
            b = json.b.bool()
            c = json.c.bool()
            d = json.d.bool()
            e = json.e.bool()
            f = json.f.bool()
            g = json.g.bool()
            h = json.h.bool()
            i = json.i.bool()
            j = json.j.bool()
            k = json.k.bool()
            l = json.l.bool(fallback: true)
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
        let a: Bool?
        let b: Bool?
        let c: Bool?
        let d: Bool?
        let e: Bool?
        let f: Bool?
        let g: Bool?
        let h: Bool?
        let i: Bool?
        let j: Bool?
        let k: Bool?
        let l: Bool?
        let m: Bool?

        init(json: BananaJSON) {
            a = json.a.parse(customBool)
            b = json.b.parse(customBool)
            c = json.c.parse(customBool)
            d = json.d.parse(customBool)
            e = json.e.parse(customBool)
            f = json.f.parse(customBool)
            g = json.g.parse(customBool)
            h = json.h.parse(customBool)
            i = json.i.parse(customBool)
            j = json.j.parse(customBool)
            k = json.k.parse(customBool)
            l = json.l.parse(customBool)
            m = json.m.parse(customBool)
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
        let a: Bool
        let b: Bool
        let c: Bool
        let d: Bool
        let e: Bool
        let f: Bool
        let g: Bool
        let h: Bool
        let i: Bool
        let j: Bool
        let k: Bool
        let l: Bool
        let m: Bool

        init(json: BananaJSON) {
            a = json.a.parse(customBool) ?? false
            b = json.b.parse(customBool) ?? false
            c = json.c.parse(customBool) ?? false
            d = json.d.parse(customBool) ?? false
            e = json.e.parse(customBool) ?? false
            f = json.f.parse(customBool) ?? false
            g = json.g.parse(customBool) ?? false
            h = json.h.parse(customBool) ?? false
            i = json.i.parse(customBool) ?? false
            j = json.j.parse(customBool) ?? false
            k = json.k.parse(customBool) ?? false
            l = json.l.parse(customBool) ?? false
            m = json.m.parse(customBool) ?? true
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

private func customBool(_ json: BananaJSON) -> Bool? {
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
