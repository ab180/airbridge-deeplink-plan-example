//
//  AppInfo.swift
//  example
//
//  Created by ab180 on 4/8/25.
//

import Foundation

struct AppInfo: Codable {
    let appName: String
    let appToken: String
    
    static func current() -> AppInfo? {
        guard let url = Bundle.main.url(forResource: "appInfo", withExtension: "json"),
        let data = try? Data(contentsOf: url) else {
            return nil
        }
        
        return try? JSONDecoder().decode(AppInfo.self, from: data)
    }
}
