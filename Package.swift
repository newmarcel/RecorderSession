// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "RecorderSession",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "RecorderSession",
            targets: ["RecorderSession"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "RecorderSession",
            dependencies: []
        ),
        .testTarget(
            name: "RecorderSessionTests",
            dependencies: ["RecorderSession"],
            resources: [
                .copy("Resources/Cassettes.bundle"),
            ]
        ),
    ]
)
