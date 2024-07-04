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
            checksum: "fe9b5769edc54050f819164c6e7733a42e514e9c8073a58664d91e67792ae1d2"
        )
    ]
)
