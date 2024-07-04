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
            checksum: "1c5913e616f1a56b2ff9b54fcde2de83e52f7caf90ec4f2e77b7ec4a4aee63d0"
        )
    ]
)
