//
//  ContentView.swift
//  example
//
//  Created by ab180 on 4/1/25.
//

import SwiftUI

struct ContentView: View {
    @State private var urlSchemes: [String] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let appInfo = AppInfo.current() {
                    InfoCard(title: "App Info") {
                        InfoRow(label: "App Name:", value: appInfo.appName)
                        InfoRow(label: "App Token:", value: appInfo.appToken)
                    }
                }
                if !urlSchemes.isEmpty {
                    InfoCard(title: "URL Scheme") {
                        ForEach(urlSchemes, id: \.self) { scheme in
                            InfoRow(label: "Scheme:", value: scheme)
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            loadURLSchemes()
        }
    }
    
    private func loadURLSchemes() {
        guard let url = Bundle.main.url(forResource: "Info", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
              let urlTypes = plist["CFBundleURLTypes"] as? [[String: Any]],
              let firstType = urlTypes.first,
              let schemes = firstType["CFBundleURLSchemes"] as? [String] else {
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
