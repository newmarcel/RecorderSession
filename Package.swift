// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "RecorderSession",
    platforms: [
        .iOS(.v14),
        .macOS(.v12),
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
