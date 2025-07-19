// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Banana",
    products: [
        .library(
            name: "Banana",
            targets: ["Banana"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/ibireme/yyjson.git",
            from: "0.11.1"
        ),
    ],
    targets: [
        .target(
            name: "Banana",
            dependencies: [
                .product(
                    name: "yyjson",
                    package: "yyjson"
                ),
            ]
        ),
        .testTarget(
            name: "BananaTests",
            dependencies: ["Banana"]
        ),
    ]
)
