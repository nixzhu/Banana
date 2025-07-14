import Testing
@testable import Banana

@Test func intIfPresent_normal() async throws {
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
                #expect(json[key].int() == json[key].int(.normal))
            }

            a = json.a.int(.normal)
            b = json.b.int(.normal)
            c = json.c.int(.normal)
            d = json.d.int(.normal)
            e = json.e.int(.normal)
            f = json.f.int(.normal)
            g = json.g.int(.normal)
            h = json.h.int(.normal)
            i = json.i.int(.normal)
            j = json.j.int(.normal)
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

@Test func int_normal() async throws {
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
                #expect(json[key].int(fallback: 0) == json[key].int(.normal, fallback: 0))
            }

            a = json.a.int(.normal)
            b = json.b.int(.normal)
            c = json.c.int(.normal)
            d = json.d.int(.normal)
            e = json.e.int(.normal)
            f = json.f.int(.normal)
            g = json.g.int(.normal)
            h = json.h.int(.normal)
            i = json.i.int(.normal)
            j = json.j.int(.normal, fallback: 42)
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
