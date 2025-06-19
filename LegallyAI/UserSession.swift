//
//  UserSession.swift
//  LegallyAI
//
//  Created by Алуа Жолдыкан on 19.06.2025.
//
import SwiftUI


class UserSession: ObservableObject {
    @Published var isAuthenticated = false
    @Published var token: String?
    @Published var role: String?

    init() {
        if let token = UserDefaults.standard.string(forKey: "token") {
            self.token = token
            self.isAuthenticated = true
            fetchRole()
        }
    }

    func login(with token: String) {
        self.token = token
        self.isAuthenticated = true
        UserDefaults.standard.set(token, forKey: "token")
        fetchRole()
    }

    func logout() {
        self.token = nil
        self.isAuthenticated = false
        self.role = nil
        UserDefaults.standard.removeObject(forKey: "token")
    }

    func fetchRole() {
        guard let token = token else { return }
        APIService.shared.getRole { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let role):
                    self.role = role
                case .failure(let error):
                    print("Ошибка получения роли:", error.localizedDescription)
                    self.role = nil
                }
            }
        }

    }
}
