//
//  LegallyAIApp.swift
//  LegallyAI
//
//  Created by Алуа Жолдыкан on 19.06.2025.
//

import SwiftUI

@main
struct LegallyAIApp: App {
    @StateObject var session = UserSession()

    var body: some Scene {
        WindowGroup {
            if session.isAuthenticated {
                MainTabView()
                    .environmentObject(session)
            } else {
                LoginView()
                    .environmentObject(session)
            }
        }
    }
}
