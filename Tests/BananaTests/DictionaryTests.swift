import Testing
@testable import Banana

@Test func dictionary1() {
    struct Item: BananaModel {
        let id: Int
        let name: String

        init(json: BananaJSON) {
            id = json.id.int()
            name = json.name.string()
        }
    }

    let jsonData = """
    {
        "a": {
            "id": 0,
            "name": "nix"
        },
        "b": {
            "id": 1,
            "name": "zhu"
        }
    }
    """.data(using: .utf8)!

    let info = [String: Item].decode(from: jsonData)
    #expect(info["a"]?.id == 0)
    #expect(info["a"]?.name == "nix")
    #expect(info["b"]?.id == 1)
    #expect(info["b"]?.name == "zhu")
}

@Test func dictionary2() {
    struct Item: BananaModel {
        let id: Int
        let name: String

        init(json: BananaJSON) {
            id = json.id.int()
            name = json.name.string()
        }
    }

    let jsonData = """
    {
        "x": {
            "a": {
                "id": 0,
                "name": "nix"
            },
            "b": {
                "id": 1,
                "name": "zhu"
            }
        }
    }
    """.data(using: .utf8)!

    let info = [String: Item].decode(from: jsonData, path: ["x"])
    #expect(info["a"]?.id == 0)
    #expect(info["a"]?.name == "nix")
    #expect(info["b"]?.id == 1)
    #expect(info["b"]?.name == "zhu")
}
