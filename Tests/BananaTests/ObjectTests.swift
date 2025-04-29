import Foundation
import Testing
@testable import Banana

@Test func object1() {
    struct User: BananaModel {
        struct Mastodon: BananaModel {
            struct Profile: BananaModel {
                let username: String
                let nickname: String
                let avatarURL: URL
                let mp3URL: URL

                init(json: BananaJSON) {
                    username = json.username.string()
                    nickname = json.nickname.string()
                    avatarURL = json.avatar_url.url()
                    mp3URL = json.mp3_url.url()
                }
            }

            struct Toot: BananaModel {
                let id: Int
                let content: String
                let isProtected: Bool
                let createdAt: Date

                init(json: BananaJSON) {
                    id = json.id.int(.compatible)
                    content = json.content.string()
                    isProtected = json.is_protected.bool(.custom(parseBool))
                    createdAt = json.created_at.date(.custom(parseDate))
                }
            }

            let profile: Profile
            let toots: [Toot]

            init(json: BananaJSON) {
                profile = .init(json: json.profile)
                toots = json.toots.array().map { .init(json: $0) }

                #expect(json.toots[-1].id.intIfPresent() == nil)
                #expect(toots[0].id == 1)
                #expect(toots[1].id == 2)
                #expect(toots[2].id == 88_888_888_888_888_888)
                #expect(toots[3].id == 99_999_999_999_999_999)
                #expect(toots.map { $0.isProtected } == [false, true, false, true])
            }
        }

        let id: Int
        let name: String
        let mastodon: Mastodon

        init(json: BananaJSON) {
            id = json.id.int()
            name = json.name.string()
            mastodon = .init(json: json.mastodon)

            let mastodonInfo = json.mastodon.dictionary()
            #expect(mastodonInfo["profile"]?.username.string() == "@nixzhu@mastodon.social")
        }
    }

    let jsonString = """
        {
            "id": 42,
            "name": "NIX 👨‍👩‍👧‍👦/🐣",
            "int": 18,
            "mastodon": {
                "profile": {
                    "username": "@nixzhu@mastodon.social",
                    "nickname": "NIX",
                    "avatar_url": "https://files.mastodon.social/accounts/avatars/109/329/064/034/222/219/original/371901c6daa01207.png",
                    "mp3_url": "https://freetyst.nf.migu.cn/public/product9th/product45/2022/07/2210/2009年06月26日博尔普斯/标清高清/MP3_320_16_Stero/60054701923104030.mp3",
                    "extra_info": {},
                    "extra_list": []
                },
                "toots": [
                    {
                        "id": 1,
                        "content": "Hello World!",
                        "is_protected": false,
                        "created_at": "1234567890"
                    },
                    {
                        "id": 2,
                        "content": "How do you do?",
                        "is_protected": "true",
                        "created_at": 1234567890
                    },
                    {
                        "id": "88888888888888888",
                        "content": "A4纸不发货了",
                        "is_protected": 0,
                        "created_at": "8888888888"
                    },
                    {
                        "id": "99999999999999999",
                        "content": "春季快乐！",
                        "is_protected": 1,
                        "created_at": "2012-04-23T18:25:43.511Z"
                    }
                ]
            }
        }
        """

    let model = User.decode(from: jsonString)

    #expect(model.id == 42)
    #expect(model.name == "NIX 👨‍👩‍👧‍👦/🐣")
    #expect(model.mastodon.profile.username == "@nixzhu@mastodon.social")

    #expect(
        model.mastodon.profile.avatarURL.absoluteString ==
            "https://files.mastodon.social/accounts/avatars/109/329/064/034/222/219/original/371901c6daa01207.png"
    )

    #expect(
        model.mastodon.profile.mp3URL.absoluteString ==
            "https://freetyst.nf.migu.cn/public/product9th/product45/2022/07/2210/2009%E5%B9%B406%E6%9C%8826%E6%97%A5%E5%8D%9A%E5%B0%94%E6%99%AE%E6%96%AF/%E6%A0%87%E6%B8%85%E9%AB%98%E6%B8%85/MP3_320_16_Stero/60054701923104030.mp3"
    )

    #expect(model.mastodon.toots[0].isProtected == false)
    #expect(model.mastodon.toots[0].id == 1)

    #expect(
        model.mastodon.toots[0].createdAt == .init(timeIntervalSince1970: 1_234_567_890)
    )

    #expect(model.mastodon.toots[1].isProtected == true)
    #expect(model.mastodon.toots[1].id == 2)

    #expect(
        model.mastodon.toots[1].createdAt == .init(timeIntervalSince1970: 1_234_567_890)
    )

    #expect(model.mastodon.toots[2].isProtected == false)
    #expect(model.mastodon.toots[2].id == 88_888_888_888_888_888)

    #expect(
        model.mastodon.toots[2].createdAt == .init(timeIntervalSince1970: 8_888_888_888)
    )

    #expect(model.mastodon.toots[3].isProtected == true)
    #expect(model.mastodon.toots[3].id == 99_999_999_999_999_999)

    #expect(
        model.mastodon.toots[3].createdAt.timeIntervalSince1970 == 1_335_205_543.511
    )

    let toots = [User.Mastodon.Toot].decode(from: jsonString, path: ["mastodon", "toots"])

    #expect(toots[1].isProtected == true)
    #expect(toots[1].id == 2)

    #expect(
        toots[1].createdAt == .init(timeIntervalSince1970: 1_234_567_890)
    )
}

@Test func object2() {
    let jsonString = """
        {
            "id": 10,
            "contact_info": {
                "email": "test@test.com"
            },
            "preferences": {
                "contact": {
                    "newsletter": true
                }
            }
        }
        """

    struct User: BananaModel {
        let id: Int
        let email: String
        let isSubscribedToNewsletter: Bool

        init(json: BananaJSON) {
            id = json.id.int()
            email = json.contact_info.email.string()
            isSubscribedToNewsletter = json.preferences.contact.newsletter.bool()
        }
    }

    let user = User.decode(from: jsonString)

    #expect(user.id == 10)
    #expect(user.email == "test@test.com")
    #expect(user.isSubscribedToNewsletter == true)
}

private func parseBool(json: BananaJSON) -> Bool? {
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
        switch value.lowercased() {
        case "true":
            return true
        case "false":
            return false
        default:
            break
        }
    }

    return nil
}

private func parseDate(json: BananaJSON) -> Date? {
    if let date = json.dateIfPresent(.unixSeconds) {
        return date
    }

    if let date = json.dateIfPresent(.iso8601) {
        return date
    }

    return nil
}
