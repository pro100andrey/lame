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
        .library(name: "lame", type: .dynamic, targets: ["lame"]),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "lame",

            url: "https://github.com/pro100andrey/lame/releases/download/1.2.2/lame.xcframework.zip",
            checksum: "54009fe84ea7dce3a8ed89277db6087b6639d3756fc52b2b3ff04cbf82f4b428"
        )
    ]
)
