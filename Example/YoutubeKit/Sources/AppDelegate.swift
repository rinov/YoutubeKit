//
//  AppDelegate.swift
//  YoutubeKit
//
//  Created by Ryo Ishikawa on 12/30/2017.
//  Copyright (c) 2017 Ryo Ishikawa. All rights reserved.
//

import UIKit
import YoutubeKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // (Optional) Call `setAPIKey` or `setAccessToken` to authorize your request for YoutubeDataAPI.
        // Specify requests are necessary from OAuth2.0 access token. e.g. ActivityListRequest
        YoutubeKit.shared.setAPIKey("YOUR_API_KEY")

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

