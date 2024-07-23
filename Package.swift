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

            url: "https://github.com/pro100andrey/lame/releases/download/1.2.5/lame.xcframework.zip",
            checksum: "56717d3ece5424fbe3929251d75fa362047208226b3c00b38b6cdaab4260100c"
        )
    ]
)
