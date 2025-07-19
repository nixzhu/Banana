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
        let a: Int?
        let b: Int?
        let c: Int?
        let d: Int?
        let e: Int?
        let f: Int?
        let g: Int?
        let h: Int?
        let i: Int?
        let j: Int?

        init(json: BananaJSON) {
            a = json.a.int()
            b = json.b.int()
            c = json.c.int()
            d = json.d.int()
            e = json.e.int()
            f = json.f.int()
            g = json.g.int()
            h = json.h.int()
            i = json.i.int()
            j = json.j.int()
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
        let a: Int
        let b: Int
        let c: Int
        let d: Int
        let e: Int
        let f: Int
        let g: Int
        let h: Int
        let i: Int
        let j: Int

        init(json: BananaJSON) {
            a = json.a.int()
            b = json.b.int()
            c = json.c.int()
            d = json.d.int()
            e = json.e.int()
            f = json.f.int()
            g = json.g.int()
            h = json.h.int()
            i = json.i.int()
            j = json.j.int(fallback: 42)
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
        let a: Int?
        let b: Int?
        let c: Int?
        let d: Int?
        let e: Int?
        let f: Int?
        let g: Int?

        init(json: BananaJSON) {
            a = json.a.parse(customInt)
            b = json.b.parse(customInt)
            c = json.c.parse(customInt)
            d = json.d.parse(customInt)
            e = json.e.parse(customInt)
            f = json.f.parse(customInt)
            g = json.g.parse(customInt)
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
        let a: Int
        let b: Int
        let c: Int
        let d: Int

        init(json: BananaJSON) {
            a = json.a.parse(customInt) ?? 0
            b = json.b.parse(customInt) ?? 0
            c = json.c.parse(customInt) ?? -1
            d = json.d.parse(customInt) ?? 0
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == 123)
    #expect(m.b == 16)
    #expect(m.c == -1)
    #expect(m.d == 7)
}

private func customInt(_ json: BananaJSON) -> Int? {
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
