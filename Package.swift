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
            url: "https://github.com/pro100andrey/lame/releases/download/1.2.1/lame.xcframework.zip",
            checksum: "8da284cb6d36ebb157a6ed68a0c5fd5842530a2b1b40e7f5dedcb8b6bbdc3a19"
        )
    ]
)
