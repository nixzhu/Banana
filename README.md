[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fnixzhu%2FBanana%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/nixzhu/Banana)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fnixzhu%2FBanana%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/nixzhu/Banana)

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

To decode a `Mastodon` instance from the JSON string:

```swift
let mastodon = Mastodon.decode(from: jsonString)
```

Or, if you already have the JSON data:

```swift
let mastodon = Mastodon.decode(from: jsonData)
```

To decode a specific JSON branch, for example `profile.avatar`, specify it's path:

```swift
let avatar = Mastodon.Profile.Avatar.decode(from: jsonData, path: ["profile", "avatar"])
```

To decode an array (e.g. `toots`):

```swift
let toots = [Mastodon.Toot].decode(from: jsonData, path: ["toots"])
```

Or decode only the first toot:

```swift
let toot = Mastodon.Toot.decode(from: jsonData, path: ["toots", 0])
```

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift`compiler.

Once your Swift package is set up, add Banana as a dependency to the `dependencies` value in your `Package.swift` file or to the package list in Xcode.

```swift
dependencies: [
    .package(url: "https://github.com/nixzhu/Banana.git", from: "0.5.0"),
]
```

Typically, you will want to depend on the `Banana` target:

```swift
.product(name: "Banana", package: "Banana")
```
