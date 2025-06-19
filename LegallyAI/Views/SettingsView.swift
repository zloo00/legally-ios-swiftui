//
//  SettingsView.swift
//  LegallyAI
//
//  Created by Алуа Жолдыкан on 19.06.2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var session: UserSession

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Профиль")) {
                    Text("Токен: \(session.token?.prefix(10) ?? "Нет")...")
                }

                Section {
                    Button("Выйти", role: .destructive) {
                        session.logout()
                    }
                }
            }
            .navigationTitle("Настройки")
        }
    }
}
