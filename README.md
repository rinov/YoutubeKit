# YoutubeKit

`YoutubeKit` is a video player that fully supports `Youtube IFrame API` and `YoutubeDataAPI` to easily create Youtube applications.

[![Swift](https://img.shields.io/badge/Swift-4-blue.svg)](https://img.shields.io/badge/Swift-4-blue.svg)
[![Cocoapods](https://img.shields.io/badge/Cocoapods-compatible-brightgreen.svg)](https://img.shields.io/badge/Cocoapods-compatible-brightgreen.svg)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg)]((https://img.shields.io/badge/Carthage-compatible-brightgreen.svg))
[![License](https://img.shields.io/badge/LICENSE-MIT-yellowgreen.svg)](https://img.shields.io/badge/LICENSE-MIT-yellowgreen.svg)

## Important Referecens
`YoutubeKit` is created based on the following references. If you are unsure whether it is a normal behavior or a bug, please check the following documents first.

- [YoutubeDataAPI (V3)](https://developers.google.com/youtube/v3/docs/)

- [Youtube IFrame Player API](https://developers.google.com/youtube/iframe_api_reference)

## Example

This is an app using `YoutubeKit`. A simple video playback example is included into `Example`.
You can create these functions very easily by using `YoutubeKit`.

|Example1|Example2|
|:-:|:-:|
|![Feed](https://github.com/rinov/Storage/blob/master/YoutubeKit/feed.gif)|![Comment](https://github.com/rinov/Storage/blob/master/YoutubeKit/comment.gif)|
|Example3|Example4|
|![Floating](https://github.com/rinov/Storage/blob/master/YoutubeKit/floating.gif)|![Rotate](https://github.com/rinov/Storage/blob/master/YoutubeKit/rotate.gif)|

## What is YoutubeKit?
`YoutubeKit` provides useful functions to create Youtube applications. It consists of the following two functions.

- `YTSwiftyPlayer (WKWebView + HTML5 + IFrame API)`

- `YoutubeDataAPI`

## YTSwiftyPlayer
`YTSwiftyPlayer` is a video player that supports Youtube IFrame API.

Features:
- High performance (Performance is 30% better than traditional UIWebView based player)
- Low memory impact (maximum 70% off)
- Type safe parameter interface(All IFrame API's parameters are supported as `VideoEmbedParameter`)

## YoutubeDataAPI
This library supports `YoutubeDataAPI (v3)`. For the details is [Here](https://developers.google.com/youtube/v3/docs/).

Available API lists:
- Actitivty(list)
- Actitivty(insert)
- Caption(list)
- Channel(list)
- ChannelSections(list)
- Comment(list)
- CommentThreads(list)
- GuideCategories(list)
- PlaylistItems(list)
- Playlists(list)
- Search(list)
- Subscriptions(list)
- VideoAbuseReportReasons(list)
- VideoCategories(list)
- Videos(list)

# Get Started

Playback the youtube video.

```swift
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
                .videoID("9AALILYu58w"),
                .loopVideo(true),
                .showRelatedVideo(false),
                .autoplay(true)
            ])

        view = player
        player.delegate = self

        // Load video player
        let playerPath = Bundle(for: ViewController.self).path(forResource: "player", ofType: "html")!
        let htmlString = try! String(contentsOfFile: playerPath, encoding: .utf8)
        player.loadPlayerHTML(htmlString)
    }
}

```

### YTSwiftyPlayerDelegate
`YTSwiftyPlayerDelegate`  supports folowing delegate methods.

```swift
func playerReady(_ player: YTSwiftyPlayer)
func player(_ player: YTSwiftyPlayer, didUpdateCurrentTime currentTime: Double)
func player(_ player: YTSwiftyPlayer, didChangeState state: YTSwiftyPlayerState)
func player(_ player: YTSwiftyPlayer, didChangePlaybackRate playbackRate: Double)
func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError)
func player(_ player: YTSwiftyPlayer, didChangeQuality quality: YTSwiftyVideoQuality) 
func apiDidChange(_ player: YTSwiftyPlayer)    
func youtubeIframeAPIReady(_ player: YTSwiftyPlayer)    
func youtubeIframeAPIFailedToLoad(_ player: YTSwiftyPlayer)
```

### Call IFrame API during playback.
```swift
// Pause the video.
player.pauseVideo()

// Seek after 15 seconds.
player.seek(to: 15, allowSeekAhead: true)

// Set a mute.
player.mute()

// Load another video.
player.loadVideo(videoID: "abcde")
```

### Get video information using YoutubeDataAPI
First, Get API key from [Here](https://console.developers.google.com/apis).

Next, add this code in your AppDelegate.

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    // Set your API key here
    YoutubeKit.shared.setAPIKey("Your API key")

    return true
}

```

And then you can use `YoutubeDataAPI` request like this.

```swift
// Get youtube chart ranking
let request = VideoListRequest(part: [.id, .statistics], filter: .chart)

// Send a request.
YoutubeAPI.shared.send(request) { result in
    switch result {
    case .success(let response):
        print(response)
    case .failed(let error):
        print(error)
    }
}

```

Example of response here.

```ruby
VideoList(items: [YoutubeKit.Video(etag: "\"A8kisgyDEbllhHF9ooXPFFrkc/nR6_A9oyIoLTJuucY_UXeasjYNU\"",
kind: "youtube#video",
id: "jeiDjeJgF0",
contentDetails: nil,
statistics: Optional(YoutubeKit.Statistics.VideoList(dislikeCount: "1631", likeCount: "60307", commentCount: Optional("8675"), favoriteCount: "0", viewCount: "1259046")),
snippet: nil,
status: nil),
etag: "\"J67fSnfblalhHF0foXPiFFrkc/TZGPJdE22-LilSv4-3VNoPw1cS4\"",
kind: "youtube#videoListResponse",
pageInfo: YoutubeKit.PageInfo(resultsPerPage: 5, totalResults: 200))
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
        self?.nextPage = response.nextPageToken
    case .failed(let error):
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
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

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
    case .failed(let error):
        print(error)
    }
}
```

## Requirements
Xcode 12+

Swift 5+

## Installation

### Swift Package Manager
Add the following to your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/rinov/YoutubeKit.git", from: "0.7.0")
]
```

### Cocoapods

```
$ pod repo update
```

And add this to your Podfile:


```ruby
pod 'YoutubeKit'
```

and

`$ pod install`

### Carthage
Add this to your Cartfile:

`github "rinov/YoutubeKit"`

and

`$ carthage update`


## Author

Github: [https://github.com/rinov](https://github.com/rinov)

Twitter: [https://twitter.com/rinov0321](https://twitter.com/rinov0321)

Email: rinov[at]rinov.jp

## License

YoutubeKit is available under the MIT license.
