//
//  AuthViewModel.swift
//  LegallyAI
//
//  Created by Алуа Жолдыкан on 19.06.2025.
//


import Foundation

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""

    func login(completion: @escaping (Result<String, Error>) -> Void) {
        errorMessage = ""
        isLoading = true

        APIService.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let token):
                    completion(.success(token))
                case .failure(let error):
                    self.errorMessage = "Неверный email или пароль"
                    completion(.failure(error))
                }
            }
        }
    }

    func register(completion: @escaping (Result<Void, Error>) -> Void) {
        errorMessage = ""
        isLoading = true

        APIService.shared.register(email: email, password: password) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    self.errorMessage = "Не удалось зарегистрироваться"
                    completion(.failure(error))
                }
            }
        }
    }
}
