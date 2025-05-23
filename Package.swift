// swift-tools-version: 6.0

import PackageDescription

#if os(Linux)
let packageDependencies: [Package.Dependency] = [
    .package(
        url: "https://github.com/ibireme/yyjson.git",
        from: "0.11.1"
    ),
]
#else
let packageDependencies: [Package.Dependency] = [
    .package(
        url: "https://github.com/ibireme/yyjson.git",
        from: "0.11.1"
    ),
    .package(
        url: "https://github.com/michaeleisel/JJLISO8601DateFormatter.git",
        from: "0.1.8"
    ),
]
#endif

#if os(Linux)
let targetDependencies: [Target.Dependency] = [
    .product(
        name: "yyjson",
        package: "yyjson"
    ),
]
#else
let targetDependencies: [Target.Dependency] = [
    .product(
        name: "yyjson",
        package: "yyjson"
    ),
    .product(
        name: "JJLISO8601DateFormatter",
        package: "JJLISO8601DateFormatter"
    ),
]
#endif

let package = Package(
    name: "Banana",
    products: [
        .library(
            name: "Banana",
            targets: ["Banana"]
        ),
    ],
    dependencies: packageDependencies,
    targets: [
        .target(
            name: "Banana",
            dependencies: targetDependencies
        ),
        .testTarget(
            name: "BananaTests",
            dependencies: ["Banana"]
        ),
    ]
)
