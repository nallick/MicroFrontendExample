// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "RevealService",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "RevealService", targets: ["RevealService"]),
    ],
    dependencies: [
        .package(path: "../CommonTypes"),
        .package(url: "https://github.com/nallick/Apollo.git", from: "1.0.0"),
        .package(url: "https://github.com/nallick/BaseSwift.git", from: "1.1.1"),
        .package(url: "https://github.com/wwt/SwiftCurrent.git", from: "5.0.0"),
        .package(url: "https://github.com/nallick/UIUTest.git", from: "1.8.0"),
    ],
    targets: [
        .target(
            name: "RevealService",
            dependencies: [
                .product(name: "Apollo", package: "Apollo"),
                .product(name: "CommonTypes", package: "CommonTypes"),
                .product(name: "SwiftCurrent", package: "SwiftCurrent", condition: .when(platforms: [.iOS])),
                .product(name: "SwiftCurrent_UIKit", package: "SwiftCurrent", condition: .when(platforms: [.iOS])),
            ],
            resources: [.copy("RevealService.xcdatamodeld")]),
        .testTarget(
            name: "RevealServiceTests",
            dependencies: [
                "RevealService",
                .product(name: "BaseSwiftMocks", package: "BaseSwift"),
                .product(name: "CommonTypes", package: "CommonTypes"),
                .product(name: "UIUTest", package: "UIUTest"),
            ]),
    ]
)
