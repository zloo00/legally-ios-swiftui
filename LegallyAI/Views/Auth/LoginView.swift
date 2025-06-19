//
//  LoginView.swift
//  LegallyAI
//
//  Created by Алуа Жолдыкан on 19.06.2025.
//
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: UserSession
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Вход")
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
                    viewModel.login { result in
                        switch result {
                        case .success(let token):
                            session.login(with: token)
                        case .failure:
                            break
                        }
                    }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Войти")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }

                NavigationLink("Нет аккаунта? Зарегистрироваться", destination: RegisterView())
                    .padding(.top)
            }
            .padding()
        }
    }
}
