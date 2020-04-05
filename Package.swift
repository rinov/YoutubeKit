// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "YoutubeKit",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "YoutubeKit",
            targets: ["YoutubeKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "YoutubeKit",
            dependencies: [])
    ],
    swiftLanguageVersions: [.v5]
)
