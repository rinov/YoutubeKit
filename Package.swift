// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "YoutubeKit",
    products: [
        .library(
            name: "YoutubeKit",
            targets: ["YoutubeKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "YoutubeKit",
            dependencies: []),
        .testTarget(
            name: "YoutubeKitTests",
            dependencies: ["YoutubeKit"]),
    ],
    swiftLanguageVersions: [.v5]
)
