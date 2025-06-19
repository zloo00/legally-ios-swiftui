//
//  MainTabView.swift
//  LegallyAI
//
//  Created by Алуа Жолдыкан on 19.06.2025.
//


import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            UploadView()
                .tabItem {
                    Label("Анализ", systemImage: "doc.text.magnifyingglass")
                }

            HistoryView()
                .tabItem {
                    Label("История", systemImage: "clock.arrow.circlepath")
                }

            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gearshape")
                }
        }
    }
}
