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

            url: "https://github.com/pro100andrey/lame/releases/download/1.2.3/lame.xcframework.zip",
            checksum: "49beb4391e6ae23a6afa37671703359391d678f3a4c329adef47ddad3d58c908"
        )
    ]
)
