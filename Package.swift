// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MaterialForm",
    products: [
        .library(
            name: "MaterialForm",
            targets: ["MaterialForm"]),
        .library(
            name: "MaterialFormSwiftUI",
            targets: ["MaterialFormSwiftUI"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "MaterialForm",
            dependencies: []),
        .target(
            name: "MaterialFormSwiftUI",
            dependencies: ["MaterialForm"]),
        .testTarget(
            name: "MaterialFormTests",
            dependencies: ["MaterialForm", "MaterialFormSwiftUI"]),
    ]
)
