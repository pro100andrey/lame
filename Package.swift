// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "lame",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12),
        .macOS(.v10_14),
        .macCatalyst(.v14)
    ],
    products: [
        .library(name: "lame", targets: ["lame"]),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "lame",
            url: "https://github.com/pro100andrey/lame/releases/download/1.2.1/lame.xcframework.zip",
            checksum: "9293938daa1e75f183fe8ac67aa29d3a41dfa7852aeb585c4ef7c6b024659d77"
        )
    ]
)
