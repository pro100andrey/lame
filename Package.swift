// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "lame",
    platforms: [
        .iOS(.v12),
        .macCatalyst(.v13),
        .macOS(.v10_13),
        .tvOS(.v12),
    ],
      products: [
        .library(
            name: "lame",
            targets: ["lame"]
        ),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "lame",

            url: "https://github.com/pro100andrey/lame/releases/download/1.2.2/lame.xcframework.zip",
            checksum: "c9f913ec1487d78d3ee59ff7e965d1d50f8ff5c729b7f8c83da6a5f64214e63a"
        )
    ]
)
