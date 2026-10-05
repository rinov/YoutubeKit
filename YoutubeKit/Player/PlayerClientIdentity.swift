// YouTubeのクライアント識別情報。アプリIDをHTTPSのRefererに変換する。
import Foundation

internal enum PlayerClientIdentity {
    static let autoplayBlockedEvent = "onAutoplayBlocked"

    static func baseURLString(bundleIdentifier: String?) -> String {
        guard let identifier = bundleIdentifier, !identifier.isEmpty,
              identifier.unicodeScalars.allSatisfy({
                  CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.-").contains($0)
              }) else {
            // アプリIDが存在しない既存ホストは、明示的なbaseURL指定で移行できる。
            return YTSwiftyPlayer.Const.basePlayerURLString
        }
        return "https://" + identifier.lowercased()
    }
}
