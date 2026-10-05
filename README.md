# YoutubeKit
<!-- Installation and usage guidance for consumers of the public API. -->

`YoutubeKit` is an iOS library for the YouTube IFrame Player and YouTube Data API.

[![Swift](https://img.shields.io/badge/Swift-5-blue.svg)](https://img.shields.io/badge/Swift-5-blue.svg)
[![Cocoapods](https://img.shields.io/badge/Cocoapods-compatible-brightgreen.svg)](https://img.shields.io/badge/Cocoapods-compatible-brightgreen.svg)
[![License](https://img.shields.io/badge/LICENSE-MIT-yellowgreen.svg)](https://img.shields.io/badge/LICENSE-MIT-yellowgreen.svg)

## References
`YoutubeKit` is created based on the following references. If you are unsure whether it is a normal behavior or a bug, please check the following documents first.

- [YoutubeDataAPI (V3)](https://developers.google.com/youtube/v3/docs/)
- [Youtube IFrame Player API](https://developers.google.com/youtube/iframe_api_reference)

## Example

The `Example` project demonstrates video playback and Data API requests.

|Example1|Example2|
|:-:|:-:|
|![Feed](https://github.com/rinov/Storage/blob/master/YoutubeKit/feed.gif)|![Comment](https://github.com/rinov/Storage/blob/master/YoutubeKit/comment.gif)|
|Example3|Example4|
|![Floating](https://github.com/rinov/Storage/blob/master/YoutubeKit/floating.gif)|![Rotate](https://github.com/rinov/Storage/blob/master/YoutubeKit/rotate.gif)|

## YTSwiftyPlayer
`YTSwiftyPlayer` is a video player that supports Youtube IFrame API.

Features:

- A WKWebView-based IFrame player
- Typed player parameters (`VideoEmbedParameter`)

## YoutubeDataAPI
This library supports `YoutubeDataAPI (v3)`. For the details is [Here](https://developers.google.com/youtube/v3/docs/).

Available API lists:

- Activity(list)
- Caption(list)
- Channel(list)
- ChannelSections(list)
- Comment(list)
- CommentThreads(list)
- PlaylistItems(list)
- Playlists(list)
- Search(list)
- Subscriptions(list)
- VideoAbuseReportReasons(list)
- VideoCategories(list)
- Videos(list)

# Get Started

```swift
import UIKit
import YoutubeKit

final class VideoPlayerController: UIViewController {

    private var player: YTSwiftyPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a new player
        player = YTSwiftyPlayer(
            frame: .zero,
            playerVars: [
                .playsInline(false),
                .videoID("_6u6UrtXUEI"),
                .loopVideo(true),
                .showRelatedVideo(false),
                .autoplay(true)
            ])

        view = player
        player.delegate = self

        // Load video player
        player.loadDefaultPlayer()
    }
}

// Use the default implementations of the optional delegate callbacks.
extension VideoPlayerController: YTSwiftyPlayerDelegate {}
```

### YTSwiftyPlayerDelegate
`YTSwiftyPlayerDelegate` provides default implementations of these callbacks:

```swift
func playerReady(_ player: YTSwiftyPlayer)
func player(_ player: YTSwiftyPlayer, didUpdateCurrentTime currentTime: Double)
func player(_ player: YTSwiftyPlayer, didChangeState state: YTSwiftyPlayerState)
func player(_ player: YTSwiftyPlayer, didChangePlaybackRate playbackRate: Double)
func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError)
func player(_ player: YTSwiftyPlayer, didReceiveErrorCode code: Int)
func autoplayBlocked(_ player: YTSwiftyPlayer)
func player(_ player: YTSwiftyPlayer, didChangeQuality quality: YTSwiftyVideoQuality)
func apiDidChange(_ player: YTSwiftyPlayer)
func youtubeIframeAPIReady(_ player: YTSwiftyPlayer)
func youtubeIframeAPIFailedToLoad(_ player: YTSwiftyPlayer)
```

### Player identity and failure callbacks

`loadDefaultPlayer()` and `loadPlayerHTML` without an explicit URL derive
`https://<bundle-id>` from the host app's bundle ID for the YouTube Referer.
Custom hosts can supply `loadDefaultPlayer(baseURLString:)` or the existing `baseURLString:` argument.
Without a valid bundle ID, the legacy URL is used; supply an explicit app identity URL in that case.
`Const.basePlayerURLString` and explicit base URLs remain supported.

`player(_:didReceiveErrorCode:)` reports all error codes, including 153 (missing client identity).
The existing typed `didReceiveError` callback still runs first for known codes.
`autoplayBlocked(_:)` reports blocked autoplay; allow the user to start playback with a tap.
Both new callbacks have default implementations, so existing delegates need no changes.
Custom HTML templates should also forward `onAutoplayBlocked`, as the bundled template does.
The Example logs raw error codes and blocked autoplay for troubleshooting.

See [YouTube's client identity requirements](https://developers.google.com/youtube/terms/required-minimum-functionality).

### Call IFrame API during playback.
```swift
// Pause the video.
player.pauseVideo()

// Seek to a whole or fractional second.
player.seek(to: 15, allowSeekAhead: true)
player.seek(to: 15.5, allowSeekAhead: true)

// Set a mute.
player.mute()

// Load another video.
player.loadVideo(videoID: "M7lc1UVf-VE")
```

`Int` values and method references remain supported; NaN and infinity are ignored. The bundled HTML uses the device viewport width. See [GitHub Issues](https://github.com/rinov/YoutubeKit/issues) for current bugs and requests.

### Get video information using YoutubeDataAPI
First, Get API key from [Here](https://console.developers.google.com/apis).

Next, add this code in your AppDelegate.

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // Set your API key here
    YoutubeKit.shared.setAPIKey("Your API key")

    return true
}
```

For iOS-restricted API keys, requests automatically include the host app's bundle ID.
See [API key restrictions](Documentation/API-key-restrictions.md) for setup and custom headers.

And then you can use `YoutubeDataAPI` request like this.

```swift
// Get youtube chart ranking
let request = VideoListRequest(part: [.id, .statistics], filter: .chart)

// Send a request.
YoutubeAPI.shared.send(request) { result in
    switch result {
    case .success(let response):
        print(response)
    case .failure(let error):
        print(error)
    }
}
```

### Fetch the next page (Pagination)
```swift
var nextPageToken: String?
...

// Send some request
YoutubeAPI.shared.send(request) { [weak self] result in
    switch result {
    case .success(let response):

        // Save nextPageToken
        self?.nextPageToken = response.nextPageToken
    case .failure(let error):
        print(error)
    }
}
...

// Set nextPageToken
let request = VideoListRequest(part: [.id], filter: .chart, nextPageToken: nextPageToken)
```

### Authorization Request
If you want authorized request such as a getting your activity in Youtube, you set your access token before sending a request.
To use `GoogleSignIn`, you can easily get your access token.
`pod 'GoogleSignIn'`

First, add this code in your AppDelegate.

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // Set your access token for autheticate request
    YoutubeKit.shared.setAccessToken("Your access token")

    return true
}
```

And then you can use request requiring authorization, this is an example to get your Youtube activity.

```swift
// Get your Youtube activity
let request = ActivityListRequest(part: [.snippet], filter: .mine(true))

// Send a request.
YoutubeAPI.shared.send(request) { result in
    switch result {
    case .success(let video):
        print(video)
    case .failure(let error):
        print(error)
    }
}
```

## Migrating from retired YouTube features

Existing types, enum cases, and arguments are retained with deprecation warnings.
Keeping a client API available does not restore a feature removed by YouTube.

| Legacy feature | Current behavior or migration |
|---|---|
| `ActivityInsertRequest` / `GuideCategoriesListRequest` | Retired by YouTube; no direct replacement |
| `Filter.ChannelList.categoryID` / `Filter.SearchList.relatedToVideoID` | Retired; use supported ID filters or search queries |
| `VideoListType.search` | Search with the Data API and pass the returned video IDs to the player |
| `showModestbranding` / `setPlaybackQuality` / `availableQualityLevels` | Unsupported or ignored; let YouTube control branding and quality |
| `suggestedQuality` argument | Retained for source compatibility; ignored by YouTube |
| `showRelatedVideo(false)` | Limits related videos to the same channel; does not hide them |

Sources: [Data API revision history](https://developers.google.com/youtube/v3/revision_history),
[IFrame revision history](https://developers.google.com/youtube/iframe_api_revision_history),
[player parameters](https://developers.google.com/youtube/player_parameters).

## Requirements

iOS 13 or later. SwiftPM tools version is 5.3; the default Swift language mode is 5.
Using a Swift 6 compiler does not require switching the application's language mode to Swift 6.
The networking API retains completion handlers and arbitrary `Decodable` response types.
Use the `.main` callback queue for UI updates and synchronize mutable references shared by your app.
`ResponseError.unexpectedResponse(Any)` is retained; arbitrary payloads are not guaranteed thread-safe.
The Example uses the iOS 13 scene lifecycle.

## Development and release verification

Run `python3 Scripts/run-tests.py` for package regression tests and hosted Example tests.
It selects the latest installed iPhone Simulator; no API key is needed for automated tests.
Use `--language-mode 6` to test Swift 6 and `--deployment-target 15.0` when required by the SDK.
This override only affects validation builds; package and CocoaPods deployment targets remain iOS 13.
CI runs on Xcode 26 and 27. See [release preparation](RELEASING.md) for live playback checks and publishing.

## Installation

### Swift Package Manager
Add the following to your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/rinov/YoutubeKit.git", from: "0.14.0")
]
```

### CocoaPods (existing integrations)

The podspec remains available for existing users. SwiftPM is recommended for new integrations.
Use `pod 'YoutubeKit', '~> 0.14.0'` after this version is published to CocoaPods.
Upgrading from the previously published 0.9.0 requires iOS 13 (0.9.0 supported iOS 11).
Applications that still support iOS 11 or 12 must remain on a compatible older version.

### Carthage (legacy)

The current repository has no shared framework target; use SwiftPM for new integrations.
Existing users should pin their validated version and verify resource loading before migrating.

## Author

[rinov](https://github.com/rinov) · [Twitter](https://twitter.com/rinov0321) · rinov[at]rinov.jp

## License

YoutubeKit is available under the MIT license.
