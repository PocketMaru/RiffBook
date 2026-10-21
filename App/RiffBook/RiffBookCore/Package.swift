// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "RiffBookCore",
    platforms: [
        .iOS("27.0")
    ],
    products: [
        .library(
            name: "RiffBookCore",
            targets: ["RiffBookCore"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/sqlite-data",
            from: "1.0.0"
        ),
        .package(
            url: "git@github.com:PocketMaru/AmbidDesignSystem",
            from: "0.9.0"
        )
    ],
    targets: [
        .target(
            name: "RiffBookCore",
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
                .product(
                    name: "SQLiteData",
                    package: "sqlite-data"
                ),
                .product(
                    name: "DesignSystem",
                    package: "AmbidDesignSystem"
                )
            ],
            resources: [
                .process("Theme/Assets.xcassets"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .testTarget(
            name: "RiffBookCoreTests",
            dependencies: ["RiffBookCore"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
    ]
)
