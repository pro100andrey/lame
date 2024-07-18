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

            url: "https://github.com/pro100andrey/lame/releases/download/1.2.4/lame.xcframework.zip",
            checksum: "3b9834a974ad70a883544b02ca16b8217cde5dab9532ae1c9b73fbca78d1755a"
        )
    ]
)
