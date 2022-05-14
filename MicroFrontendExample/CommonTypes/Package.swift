// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "CommonTypes",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "CommonTypes", targets: ["CommonTypes"]),
    ],
    dependencies: [
        .package(url: "https://github.com/wwt/SwiftCurrent.git", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "CommonTypes",
            dependencies: [
                .product(name: "SwiftCurrent", package: "SwiftCurrent", condition: .when(platforms: [.iOS])),
            ]),
        .testTarget(
            name: "CommonTypesTests",
            dependencies: ["CommonTypes"]),
    ]
)
