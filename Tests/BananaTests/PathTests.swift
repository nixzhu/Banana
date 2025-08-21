import Testing
@testable import Banana

@Test func path1() {
    struct B: BananaModel {
        let c: Int

        init(json: BananaJSON) {
            c = json.c.int()
        }
    }

    let jsonString = """
    {
        "a": {
            "b": {
                "c": 42
            }
        }
    }
    """

    let model = B.decode(from: jsonString, at: ["a", "b"])
    #expect(model.c == 42)
}

@Test func path2() {
    struct B: BananaModel {
        let c: Int

        init(json: BananaJSON) {
            c = json.c.int()
        }
    }

    let jsonString = """
    {
        "a": {
            "b": [
                {
                    "c": 42
                }
            ]
        }
    }
    """

    let list = [B].decode(from: jsonString, at: ["a", "b"])
    #expect(list[0].c == 42)
}

@Test func path3() {
    struct D: BananaModel {
        let d: Int

        init(json: BananaJSON) {
            d = json.d.int()
        }
    }

    let jsonString = """
    {
        "a": {
            "b": [
                {
                    "c": {
                        "d": 42
                    }
                }
            ]
        }
    }
    """

    let d = D.decode(from: jsonString, at: ["a", "b", 0, "c"])
    #expect(d.d == 42)
}
