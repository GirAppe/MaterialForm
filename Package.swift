// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MaterialForm",
    platforms:  [.iOS(.v10), .tvOS(.v11)],
    products: [
        .library(
            name: "MaterialForm",
            targets: ["MaterialForm"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MaterialForm",
            dependencies: []
        ),
        .testTarget(
            name: "MaterialFormTests",
            dependencies: ["MaterialForm"]
        ),
    ]
)
