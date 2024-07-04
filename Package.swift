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
            checksum: "2f19066c37560dd095087229afa30f33f3d54276388547e8f6b2aacca3157b3d"
        )
    ]
)
