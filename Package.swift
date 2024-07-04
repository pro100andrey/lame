// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "lame",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12),
        .macOS(.v10_14),
        .macCatalyst(.v10_14)
    ],
    products: [
        .library(
            name: "lame",
            targets: ["lame"]),
    ],
    targets: [
        .binaryTarget(
            name: "lame",
            path: "./lame.xcframework"
        ),
    ]
)
