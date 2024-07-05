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
            checksum: "e5ec7cadf25819feac39f5c249252969f7e28e592ea0568993791ec6f7c62c5d"
        )
    ]
)
