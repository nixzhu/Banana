# Banana

A lightweight, high‑performance JSON decoding library powered by [yyjson](https://github.com/ibireme/yyjson).

## Example

Given the following JSON:

```json
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
```

You can define your models by conforming to the `BananaModel` protocol:

```swift
import Foundation
import Banana

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
```

To decode a full `Mastodon` instance from the JSON string:

```swift
let mastodon = Mastodon.decode(from: jsonString)
```

Or, if you already have the JSON data:

```swift
let mastodon = Mastodon.decode(from: jsonData)
```

To decode only a specific JSON branch, for example `profile.avatar`, specify a path:

```swift
let avatar = Mastodon.Profile.Avatar.decode(from: jsonData, path: ["profile", "avatar"])
```

To decode an array (e.g. `toots`):

```swift
let toots = [Mastodon.Toot].decode(from: jsonData, path: ["toots"])
```
