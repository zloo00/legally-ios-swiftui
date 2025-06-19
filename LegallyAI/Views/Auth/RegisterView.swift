//
//  RegisterView.swift
//  LegallyAI
//
//  Created by Алуа Жолдыкан on 19.06.2025.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var session: UserSession
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        VStack(spacing: 24) {
            Text("Регистрация")
                .font(.title.bold())

            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            SecureField("Пароль", text: $viewModel.password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
            }

            Button(action: {
                viewModel.register { result in
                    if case .success = result {
                        dismiss()
                    }
                }
            }) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Создать аккаунт")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }

            Button("Уже есть аккаунт? Войти") {
                dismiss()
            }
            .padding(.top)
        }
        .padding()
    }
}
