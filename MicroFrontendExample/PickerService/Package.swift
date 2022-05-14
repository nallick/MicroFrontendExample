// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "PickerService",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "PickerService", targets: ["PickerService"]),
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
            name: "PickerService",
            dependencies: [
                .product(name: "Apollo", package: "Apollo"),
                .product(name: "CommonTypes", package: "CommonTypes"),
                .product(name: "SwiftCurrent", package: "SwiftCurrent", condition: .when(platforms: [.iOS])),
                .product(name: "SwiftCurrent_UIKit", package: "SwiftCurrent", condition: .when(platforms: [.iOS])),
            ]),
        .testTarget(
            name: "PickerServiceTests",
            dependencies: [
                "PickerService",
                .product(name: "BaseSwiftMocks", package: "BaseSwift"),
                .product(name: "CommonTypes", package: "CommonTypes"),
                .product(name: "SwiftCurrent_Testing", package: "SwiftCurrent"),
                .product(name: "UIUTest", package: "UIUTest"),
            ]),
    ]
)
