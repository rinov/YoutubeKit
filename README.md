# YoutubeKit

`YoutubeKit` はYouTube IFrameプレイヤーとYouTube Data API向けのiOSライブラリです。

[![Swift](https://img.shields.io/badge/Swift-5-blue.svg)](https://img.shields.io/badge/Swift-5-blue.svg)
[![Cocoapods](https://img.shields.io/badge/Cocoapods-compatible-brightgreen.svg)](https://img.shields.io/badge/Cocoapods-compatible-brightgreen.svg)
[![License](https://img.shields.io/badge/LICENSE-MIT-yellowgreen.svg)](https://img.shields.io/badge/LICENSE-MIT-yellowgreen.svg)

## Important Referecens
`YoutubeKit` is created based on the following references. If you are unsure whether it is a normal behavior or a bug, please check the following documents first.

- [YoutubeDataAPI (V3)](https://developers.google.com/youtube/v3/docs/)

- [Youtube IFrame Player API](https://developers.google.com/youtube/iframe_api_reference)

## Example

`Example` に動画再生とData APIのサンプルがあります。

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
- WKWebViewを使用したIFrameプレイヤー
- 型付きのパラメータ指定（`VideoEmbedParameter`）

## YoutubeDataAPI
This library supports `YoutubeDataAPI (v3)`. For the details is [Here](https://developers.google.com/youtube/v3/docs/).

Available API lists:
- Actitivty(list)
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

// この例では任意のdelegateメソッドのデフォルト実装を使用する。
extension VideoPlayerController: YTSwiftyPlayerDelegate {}
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

### プレイヤーの識別と失敗通知

`loadDefaultPlayer()` とURLを省略した `loadPlayerHTML` は、ホストアプリのBundle IDから
`https://<bundle-id>` を生成し、YouTubeにRefererとして渡します。
独自ホストでは `loadDefaultPlayer(baseURLString:)` または既存の `baseURLString:` で明示できます。
Bundle IDがない場合は従来のURLにフォールバックするため、利用側で識別URLを指定してください。
既存の `Const.basePlayerURLString` と明示的なURL指定は維持します。

`player(_:didReceiveErrorCode:)` は153（識別情報不足）を含む全エラーを通知します。
既存の型付き `didReceiveError` は既知のコードに対して引き続き先に呼ばれます。
`autoplayBlocked(_:)` は自動再生拒否を通知します。ユーザー操作による再生を案内してください。
両メソッドはデフォルト実装があるため、既存delegateの変更は不要です。
独自HTMLテンプレートでは同梱HTMLの `onAutoplayBlocked` 転送関数も取り込んでください。

参考: [YouTubeの識別要件](https://developers.google.com/youtube/terms/required-minimum-functionality)

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
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

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

## 廃止済み機能からの移行

既存コードのため型・enumケース・関数の引数は保持し、削除ではなく非推奨警告を追加しています。
YouTube側で終了した機能は、古いAPIを呼び続けても復活しません。

| 旧機能 | 現在の扱い |
|---|---|
| `ActivityInsertRequest` / `GuideCategoriesListRequest` | サービス終了。直接の代替APIなし |
| `Filter.ChannelList.categoryID` / `Filter.SearchList.relatedToVideoID` | サービス終了。ID指定や通常検索への設計変更が必要 |
| `VideoListType.search` | Data APIで検索し、取得した動画IDをプレイヤーに渡す |
| `showModestbranding` / `setPlaybackQuality` / `availableQualityLevels` | 効果なし・非対応。プレイヤーに任せる |
| `suggestedQuality` 引数 | 呼び出し互換性のため保持。YouTubeに無視される |
| `showRelatedVideo(false)` | 関連動画を同一チャンネルに限定する。完全な非表示ではない |

根拠: [Data APIの変更履歴](https://developers.google.com/youtube/v3/revision_history)、
[IFrame変更履歴](https://developers.google.com/youtube/iframe_api_revision_history)、
[プレイヤーパラメータ](https://developers.google.com/youtube/player_parameters)。

## Requirements

iOS 13以降。SwiftPMのtools versionは5.3、ライブラリの言語モードはSwift 5です。
Swift 6コンパイラの使用とSwift 6言語モードへの移行は別の設定です。
通信APIは従来のcompletionと任意のDecodableレスポンスに対応します。
completion内のUI更新は `.main` キューを使い、共有する可変参照は利用側でも同期してください。
`ResponseError.unexpectedResponse(Any)` は互換性のため維持し、任意のペイロードのスレッド安全性は保証しません。
ExampleはiOS 13以降のSceneライフサイクルを使用します。

## 開発時の検証

`python3 Scripts/run-tests.py` でパッケージの回帰テストとExampleの起動テストを実行します。
インストール済みの最新iPhone Simulatorを自動選択します。APIキーは不要です。
最新SDKが要求する最低OSは `--deployment-target 15.0` で検証ビルドだけに指定できます。
配布するパッケージとCocoaPodsの最低対応はiOS 13のままです。
CIはXcode 26系とXcode 27系で同じテストを実行します。
実機では再生・全画面切替・回転・バックグラウンド復帰も確認してください。

## Installation

### Swift Package Manager
Add the following to your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/rinov/YoutubeKit.git", from: "0.13.0")
]
```

### CocoaPods（旧導入方法）

既存利用者向けにpodspecと `pod 'YoutubeKit'` は維持しています。新規導入はSwiftPMを推奨します。

### Carthage（旧導入方法）

現行リポジトリには共有frameworkターゲットがありません。新規導入はSwiftPMを推奨します。
既存利用者は動作確認済みのバージョンを固定し、移行前にリソース読込を検証してください。

## Author

Github: [https://github.com/rinov](https://github.com/rinov)

Twitter: [https://twitter.com/rinov0321](https://twitter.com/rinov0321)

Email: rinov[at]rinov.jp

## License

YoutubeKit is available under the MIT license.
