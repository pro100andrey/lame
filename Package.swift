// swift-tools-version:5.4
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
        .library(name: "lame", targets: ["lame"]),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "lame",
            url: "https://github.com/pro100andrey/lame/releases/download/1.2.1/lame.xcframework.zip",
            checksum: "ed0d0249e1b3476de437090e933c56af1d849d2957e0415b54c7b7173a841228"
        )
    ]
)
