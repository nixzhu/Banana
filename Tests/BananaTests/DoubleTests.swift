import Testing
@testable import Banana

@Test func doubleIfPresent_normal() async throws {
    let jsonString = """
    {
        "a": true,
        "b": false,
        "c": 0,
        "d": 1.5,
        "e": "2.5",
        "f": "apple",
        "g": ""
    }
    """

    struct Model: BananaModel {
        let a: Double?
        let b: Double?
        let c: Double?
        let d: Double?
        let e: Double?
        let f: Double?
        let g: Double?

        init(json: BananaJSON) {
            a = json.a.double()
            b = json.b.double()
            c = json.c.double()
            d = json.d.double()
            e = json.e.double()
            f = json.f.double()
            g = json.g.double()
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == nil)
    #expect(m.b == nil)
    #expect(m.c == 0.0)
    #expect(m.d == 1.5)
    #expect(m.e == nil)
    #expect(m.f == nil)
    #expect(m.g == nil)
}

@Test func double_normal() async throws {
    let jsonString = """
    {
        "a": true,
        "b": false,
        "c": 0,
        "d": 1.5,
        "e": "2.5",
        "f": "",
        "g": 3
    }
    """

    struct Model: BananaModel {
        let a: Double
        let b: Double
        let c: Double
        let d: Double
        let e: Double
        let f: Double
        let g: Double

        init(json: BananaJSON) {
            a = json.a.double()
            b = json.b.double()
            c = json.c.double()
            d = json.d.double()
            e = json.e.double()
            f = json.f.double(fallback: 2.2)
            g = json.g.double()
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == 0.0)
    #expect(m.b == 0.0)
    #expect(m.c == 0.0)
    #expect(m.d == 1.5)
    #expect(m.e == 0.0)
    #expect(m.f == 2.2)
    #expect(m.g == 3.0)
}

@Test func doubleIfPresent_custom() async throws {
    let jsonString = """
    {
        "a": 1.0,
        "b": "2.5",
        "c": "50%",
        "d": "apple",
        "e": "",
        "f": 3
    }
    """

    struct Model: BananaModel {
        let a: Double?
        let b: Double?
        let c: Double?
        let d: Double?
        let e: Double?
        let f: Double?

        init(json: BananaJSON) {
            a = json.a.parse(customDouble)
            b = json.b.parse(customDouble)
            c = json.c.parse(customDouble)
            d = json.d.parse(customDouble)
            e = json.e.parse(customDouble)
            f = json.f.parse(customDouble)
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == 1.0)
    #expect(m.b == 2.5)
    #expect(m.c == 0.5)
    #expect(m.d == nil)
    #expect(m.e == nil)
    #expect(m.f == 3)
}

@Test func double_custom() async throws {
    let jsonString = """
    {
        "a": "120%",
        "b": "0.25",
        "c": "apple",
        "d": 2.2
    }
    """

    struct Model: BananaModel {
        let a: Double
        let b: Double
        let c: Double
        let d: Double

        init(json: BananaJSON) {
            a = json.a.parse(customDouble) ?? 0
            b = json.b.parse(customDouble) ?? 0
            c = json.c.parse(customDouble) ?? -1
            d = json.d.parse(customDouble) ?? 0
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == 1.2)
    #expect(m.b == 0.25)
    #expect(m.c == -1)
    #expect(m.d == 2.2)
}

private func customDouble(_ json: BananaJSON) -> Double? {
    if let double = json.rawDouble() {
        return double
    }

    if let string = json.rawString() {
        if let double = Double(string) {
            return double
        }

        if string.hasSuffix("%"),
           let double = Double(string.dropLast())
        {
            return double / 100
        }
    }

    return nil
}
