import Testing
@testable import Banana

@Test func array1() {
    struct Model: BananaModel {
        let list: [Item]

        init(json: BananaJSON) {
            list = json.array().map { .init(json: $0) }
        }
    }

    struct Item: BananaModel {
        let id: Int
        let name: String

        init(json: BananaJSON) {
            id = json.id.int()
            name = json.name.string()
        }
    }

    let jsonData = """
    [
        {
            "id": 0,
            "name": "nix"
        },
        {
            "id": 1,
            "name": "zhu"
        }
    ]
    """.data(using: .utf8)!

    let model = Model.decode(from: jsonData)
    #expect(model.list[0].id == 0)
    #expect(model.list[0].name == "nix")
    #expect(model.list[1].id == 1)
    #expect(model.list[1].name == "zhu")
}

@Test func array2() {
    struct Item: BananaModel {
        let id: Int
        let name: String

        init(json: BananaJSON) {
            id = json.id.int()
            name = json.name.string()
        }
    }

    let jsonData = """
    [
        {
            "id": 0,
            "name": "nix"
        },
        {
            "id": 1,
            "name": "zhu"
        }
    ]
    """.data(using: .utf8)!

    let items = [Item].decode(from: jsonData)
    #expect(items[0].id == 0)
    #expect(items[0].name == "nix")
    #expect(items[1].id == 1)
    #expect(items[1].name == "zhu")

    let item = Item.decode(from: jsonData, at: [0])
    #expect(item.id == 0)
    #expect(item.name == "nix")
}

@Test func array3() {
    struct Item: BananaModel {
        let name: String
        let age: Int

        init(json: BananaJSON) {
            name = json.name.string()
            age = json.age.int()
        }
    }

    let json5String = "[{name:'nix',age:18,}, {name:'zhu',age:20,}]"

    let items = [Item].decode(from: json5String, allowingJSON5: true)
    #expect(items[0].name == "nix")
    #expect(items[0].age == 18)
    #expect(items[1].name == "zhu")
    #expect(items[1].age == 20)

    let item = Item.decode(from: json5String, at: [1], allowingJSON5: true)
    #expect(item.name == "zhu")
    #expect(item.age == 20)
}
