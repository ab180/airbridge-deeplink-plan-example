//
//  AppDelegate.swift
//  example
//
//  Created by ab180 on 4/8/25.
//

import UIKit

import Airbridge

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        if let appName = AppInfo.current()?.appName,
           let appToken = AppInfo.current()?.appToken {
            let option = AirbridgeOptionBuilder(name: appName, token: appToken)
                .setAutoDetermineTrackingAuthorizationTimeout(second: 0)
                .build()
            Airbridge.initializeSDK(option: option)
        } else {
            print("Fail to initialize Airbridge SDK. Please check your appName and appToken")
        }

        return true
    }
}
