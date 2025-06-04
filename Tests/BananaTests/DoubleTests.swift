import Testing
@testable import Banana

@Test func doubleIfPresent_strict() async throws {
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
        let a, b, c, d, e, f, g: Double?

        init(json: BananaJSON) {
            a = json.a.double(.strict)
            b = json.b.double(.strict)
            c = json.c.double(.strict)
            d = json.d.double(.strict)
            e = json.e.double(.strict)
            f = json.f.double(.strict)
            g = json.g.double(.strict)
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

@Test func double_strict() async throws {
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
        let a, b, c, d, e, f, g: Double

        init(json: BananaJSON) {
            a = json.a.double(.strict)
            b = json.b.double(.strict)
            c = json.c.double(.strict)
            d = json.d.double(.strict)
            e = json.e.double(.strict)
            f = json.f.double(.strict, fallback: 2.2)
            g = json.g.double(.strict)
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

@Test func doubleIfPresent_string() async throws {
    let jsonString = """
        {
            "a": "3.14",
            "b": "apple",
            "c": "",
            "d": "0",
            "e": -2.5,
            "f": 4
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e, f: Double?

        init(json: BananaJSON) {
            a = json.a.double(.string)
            b = json.b.double(.string)
            c = json.c.double(.string)
            d = json.d.double(.string)
            e = json.e.double(.string)
            f = json.f.double(.string)
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == 3.14)
    #expect(m.b == nil)
    #expect(m.c == nil)
    #expect(m.d == 0.0)
    #expect(m.e == nil)
    #expect(m.f == nil)
}

@Test func double_string() async throws {
    let jsonString = """
        {
            "a": "3.14",
            "b": "apple",
            "c": "",
            "d": "0",
            "e": -2.5,
            "f": 4
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e, f: Double

        init(json: BananaJSON) {
            a = json.a.double(.string)
            b = json.b.double(.string, fallback: -1.1)
            c = json.c.double(.string)
            d = json.d.double(.string)
            e = json.e.double(.string)
            f = json.f.double(.string)
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == 3.14)
    #expect(m.b == -1.1)
    #expect(m.c == 0.0)
    #expect(m.d == 0.0)
    #expect(m.e == 0.0)
    #expect(m.f == 0.0)
}

@Test func doubleIfPresent_compatible() async throws {
    let jsonString = """
        {
            "a": 2.71,
            "b": "1.618",
            "c": "apple",
            "d": 0,
            "e": "",
            "f": false
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e, f: Double?

        init(json: BananaJSON) {
            a = json.a.double(.compatible)
            b = json.b.double(.compatible)
            c = json.c.double(.compatible)
            d = json.d.double(.compatible)
            e = json.e.double(.compatible)
            f = json.f.double(.compatible)
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == 2.71)
    #expect(m.b == 1.618)
    #expect(m.c == nil)
    #expect(m.d == 0.0)
    #expect(m.e == nil)
    #expect(m.f == nil)
}

@Test func double_compatible() async throws {
    let jsonString = """
        {
            "a": 2.71,
            "b": "1.618",
            "c": "apple",
            "d": 0,
            "e": "",
            "f": false
        }
        """

    struct Model: BananaModel {
        let a, b, c, d, e, f: Double

        init(json: BananaJSON) {
            a = json.a.double(.compatible)
            b = json.b.double(.compatible)
            c = json.c.double(.compatible, fallback: -9.9)
            d = json.d.double(.compatible)
            e = json.e.double(.compatible)
            f = json.f.double(.compatible)
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == 2.71)
    #expect(m.b == 1.618)
    #expect(m.c == -9.9)
    #expect(m.d == 0.0)
    #expect(m.e == 0.0)
    #expect(m.f == 0.0)
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
        let a, b, c, d, e, f: Double?

        init(json: BananaJSON) {
            a = json.a.double(.custom(parseDouble))
            b = json.b.double(.custom(parseDouble))
            c = json.c.double(.custom(parseDouble))
            d = json.d.double(.custom(parseDouble))
            e = json.e.double(.custom(parseDouble))
            f = json.f.double(.custom(parseDouble))
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
        let a, b, c, d: Double

        init(json: BananaJSON) {
            a = json.a.double(.custom(parseDouble))
            b = json.b.double(.custom(parseDouble))
            c = json.c.double(.custom(parseDouble), fallback: -1.0)
            d = json.d.double(.custom(parseDouble))
        }
    }

    let m = Model.decode(from: jsonString)

    #expect(m.a == 1.2)
    #expect(m.b == 0.25)
    #expect(m.c == -1.0)
    #expect(m.d == 2.2)
}

private func parseDouble(_ json: BananaJSON) -> Double? {
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
