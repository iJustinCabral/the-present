//
//  PresentApp.swift
//  Present
//
//  Created by Justin Cabral on 6/27/20.
//

import SwiftUI

@main
struct PresentApp: App {
    
    @StateObject private var settings = Settings()
    @State var activeTab = TabIdentifier.day
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $activeTab) {
                TodayView()
                    .environmentObject(settings)
                    .tabItem {
                        Image(systemName: "circle.fill")
                        Text("Day")
                    }
                    .tag(TabIdentifier.day)
                MoonView()
                    .environmentObject(settings)
                    .tabItem {
                        Image(systemName: "circle.fill")
                        Text("Moon")
                    }
                    .tag(TabIdentifier.moon)
                ContentView()
                    .environmentObject(settings)
                    .tabItem {
                        Image(systemName: "circle.fill")
                        Text("Year")
                    }
                    .tag(TabIdentifier.year)
                
                SettingsView()
                    .environmentObject(settings)
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
                    .tag(3)
            }.accentColor(.purple)
            .onOpenURL { url in
                // Determine which tab should be selected when update activeTab
            }
        }
    }
}

enum TabIdentifier: Hashable {
    case day,moon,year
}

extension URL {
    var isDeepLink: Bool {
        return scheme == "dmy"
    }
    
    var tabIdentifier: TabIdentifier? {
        guard isDeepLink else { return nil }
        
        switch host {
        case "day":
            return .day
        case "moon":
            return .moon
        case "year":
            return .year
        default:
            return nil
        }
    }
}
