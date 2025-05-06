import Foundation
import Testing
@testable import Banana

@Test func example() async throws {
    let jsonString = """
        {
            "profile": {
                "nickname": "NIX",
                "username": "@nixzhu@mastodon.social",
                "avatar": {
                    "url": "https://example.com/nixzhu.png",
                    "width": 200,
                    "height": 200
                }
            },
            "toots": [
                {
                    "id": 1,
                    "content": "Hello World!",
                    "created_at": "2024-10-05T09:41:00.789Z"
                },
                {
                    "id": 2,
                    "content": "How do you do?",
                    "created_at": "2025-04-29T22:23:24.567Z"
                }
            ]
        }
        """

    let mastodon = Mastodon.decode(from: jsonString)
    #expect(mastodon.profile.nickname == "NIX")
    #expect(mastodon.profile.username == "@nixzhu@mastodon.social")
    #expect(mastodon.profile.avatar.url.absoluteString == "https://example.com/nixzhu.png")
    #expect(mastodon.profile.avatar.width == 200)
    #expect(mastodon.toots[0].id == 1)
    #expect(mastodon.toots[0].content == "Hello World!")
    #expect(mastodon.toots[0].createdAt.timeIntervalSince1970 == 1_728_121_260.789)

    let jsonData = jsonString.data(using: .utf8)!

    let avatar = Mastodon.Profile.Avatar.decode(from: jsonData, path: ["profile", "avatar"])
    #expect(avatar.url.absoluteString == "https://example.com/nixzhu.png")
    #expect(avatar.height == 200)

    let toots = [Mastodon.Toot].decode(from: jsonData, path: ["toots"])
    #expect(toots[1].id == 2)
    #expect(toots[1].content == "How do you do?")
    #expect(toots[1].createdAt.timeIntervalSince1970 == 1_745_965_404.567)
}

struct Mastodon: BananaModel {
    let profile: Profile
    let toots: [Toot]

    init(json: BananaJSON) {
        profile = .init(json: json.profile)
        toots = json.toots.array().map { .init(json: $0) }
    }
}

extension Mastodon {
    struct Profile: BananaModel {
        let nickname: String
        let username: String
        let avatar: Avatar

        init(json: BananaJSON) {
            nickname = json.nickname.string()
            username = json.username.string()
            avatar = .init(json: json.avatar)
        }
    }
}

extension Mastodon.Profile {
    struct Avatar: BananaModel {
        let url: URL
        let width: Double
        let height: Double

        init(json: BananaJSON) {
            url = json["url"].url()
            width = json.width.double()
            height = json.height.double()
        }
    }
}

extension Mastodon {
    struct Toot: BananaModel {
        let id: Int
        let content: String
        let createdAt: Date

        init(json: BananaJSON) {
            id = json.id.int()
            content = json.content.string()
            createdAt = json.created_at.date()
        }
    }
}
