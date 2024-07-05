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
            checksum: "622e43b1386f266af4a481aa197d2a5e4572849bbab0119d84608d672063c6a5"
        )
    ]
)
