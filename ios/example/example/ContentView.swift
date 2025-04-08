//
//  ContentView.swift
//  example
//
//  Created by ab180 on 4/1/25.
//

import SwiftUI

struct AppInfo: Codable {
    let appName: String
    let appToken: String
}

struct URLSchemeInfo: Codable {
    let schemes: [String]
}

struct DomainInfo: Codable {
    let domains: [String]
}

struct ContentView: View {
    @State private var appInfo: AppInfo?
    @State private var urlSchemes: [String] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let appInfo = appInfo {
                    InfoCard(title: "앱 정보") {
                        InfoRow(label: "앱 이름:", value: appInfo.appName)
                        InfoRow(label: "앱 토큰:", value: appInfo.appToken)
                    }
                }
                if !urlSchemes.isEmpty {
                    InfoCard(title: "URL 스키마") {
                        ForEach(urlSchemes, id: \.self) { scheme in
                            InfoRow(label: "스키마:", value: scheme)
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            loadAppInfo()
            loadURLSchemes()
        }
    }
    
    private func loadAppInfo() {
        guard let url = Bundle.main.url(forResource: "appInfo", withExtension: "json") else {
            print("appInfo.json 파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            appInfo = try JSONDecoder().decode(AppInfo.self, from: data)
        } catch {
            print("앱 정보를 불러오는 중 오류가 발생했습니다: \(error)")
        }
    }
    
    private func loadURLSchemes() {
        guard let url = Bundle.main.url(forResource: "Info", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
              let urlTypes = plist["CFBundleURLTypes"] as? [[String: Any]],
              let firstType = urlTypes.first,
              let schemes = firstType["CFBundleURLSchemes"] as? [String] else {
            print("URL 스키마를 불러오는 중 오류가 발생했습니다.")
            return
        }
        
        urlSchemes = schemes
    }
}

struct InfoCard<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            content
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.semibold)
            Text(value)
        }
    }
}

#Preview {
    ContentView()
}
