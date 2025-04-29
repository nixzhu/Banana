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

    let model = B.decode(from: jsonString, path: ["a", "b"])
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

    let list = [B].decode(from: jsonString, path: ["a", "b"])
    #expect(list[0].c == 42)
}
