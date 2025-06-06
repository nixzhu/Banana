// swift-tools-version: 6.0

import PackageDescription

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
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
#else
let packageDependencies: [Package.Dependency] = [
    .package(
        url: "https://github.com/ibireme/yyjson.git",
        from: "0.11.1"
    ),
]
#endif

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
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
#else
let targetDependencies: [Target.Dependency] = [
    .product(
        name: "yyjson",
        package: "yyjson"
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
