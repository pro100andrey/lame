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
            checksum: "a53f7b7273431417481b9c9946674b5821e6fffb5654b863782551a122816788"
        )
    ]
)
