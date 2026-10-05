// HTML読込とReferer設定。旧読込APIと明示的なURL指定を維持する。
import WebKit

extension YTSwiftyPlayer {
    @available(*, deprecated, renamed: "loadDefaultPlayer")
    public func loadPlayer() {
        loadDefaultPlayer()
    }

    public func loadDefaultPlayer() {
        loadDefaultPlayer(baseURLString: Const.defaultBaseURLString)
    }

    /// Bundle IDを取得できないホストや独自HTML配信元では、識別URLを明示できる。
    public func loadDefaultPlayer(baseURLString: String) {
        guard let playerPath = Bundle.yk_frameworkBundle().path(forResource: "player", ofType: "html"),
              let htmlString = try? String(contentsOfFile: playerPath, encoding: .utf8) else { return }
        loadPlayerHTML(htmlString, baseURLString: baseURLString)
    }

    public func loadPlayerHTML(_ htmlString: String, baseURLString: String = Const.defaultBaseURLString) {
        let parameters = buildPlayerParameters()
        loadPlayerHTML(htmlString, parameters: parameters, baseURLString: baseURLString)
    }

    public func loadPlayerHTML(_ htmlString: String, parameters: [String: AnyObject], baseURLString: String = Const.defaultBaseURLString) {
        guard let json = try? JSONSerialization.data(withJSONObject: parameters, options: []),
            let jsonString = String(data: json, encoding: .utf8),
            let baseUrl = URL(string: baseURLString)
            else { return }

        let html = htmlString.replacingOccurrences(of: "%@", with: jsonString)
        loadHTMLString(html, baseURL: baseUrl)
    }

}
