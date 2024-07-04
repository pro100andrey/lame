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
            url: "https://github.com/pro100andrey/lame/archive/refs/tags/1.2.0.zip",
            checksum: "dde436ad81394e7c684ec2edf39d751441971c9e27871342d5625a5e08dc2f47"
        )
    ]
)
