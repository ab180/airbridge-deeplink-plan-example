//
//  exampleApp.swift
//  example
//
//  Created by ab180 on 4/1/25.
//

import SwiftUI

import Airbridge

@main
struct exampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: handleSchemeDeeplink(url:))
                .onContinueUserActivity(
                    "NSUserActivityTypeBrowsingWeb",
                    perform: handleUniversalLink(userActivity:)
                )
        }
    }
    
    private func handleSchemeDeeplink(url: URL) {
        Airbridge.trackDeeplink(url: url)
        let isHandled = Airbridge.handleDeeplink(url: url) { _ in }
        if !isHandled { return }
    }
    
    private func handleUniversalLink(userActivity: NSUserActivity) {
        Airbridge.trackDeeplink(userActivity: userActivity)
        let isHandled = Airbridge.handleDeeplink(userActivity: userActivity) { _ in }
        if !isHandled { return }
        guard let url = userActivity.webpageURL else { return }
    }
}
