// swift-tools-version:5.3
// YoutubeKitの配布設定。iOS 13とSwift 5モードを維持して既存アプリを保護する。
import PackageDescription

let package = Package(
    name: "YoutubeKit",
    platforms: [
        .iOS(.v13)
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
            path: "YoutubeKit",
            resources: [.process("Resources"), .copy("PrivacyInfo.xcprivacy")]
        ),
        .testTarget(name: "YoutubeKitTests", dependencies: ["YoutubeKit"], path: "Tests/YoutubeKitTests")
    ],
    swiftLanguageVersions: [.v5]
)
