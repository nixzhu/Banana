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
    dependencies: {
        var result: [Package.Dependency] = [
            .package(
                url: "https://github.com/ibireme/yyjson.git",
                from: "0.11.1"
            ),
        ]

        #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
        result.append(
            .package(
                url: "https://github.com/michaeleisel/JJLISO8601DateFormatter.git",
                from: "0.1.8"
            )
        )
        #endif

        return result
    }(),
    targets: [
        .target(
            name: "Banana",
            dependencies: {
                var result: [Target.Dependency] = [
                    .product(
                        name: "yyjson",
                        package: "yyjson"
                    ),
                ]

                #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
                result.append(
                    .product(
                        name: "JJLISO8601DateFormatter",
                        package: "JJLISO8601DateFormatter"
                    )
                )
                #endif

                return result
            }()
        ),
        .testTarget(
            name: "BananaTests",
            dependencies: ["Banana"]
        ),
    ]
)
