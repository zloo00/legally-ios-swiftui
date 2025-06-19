//
//  APIService.swift
//  LegallyAI
//
//  Created by Алуа Жолдыкан on 19.06.2025.
//
import Foundation

class APIService {
    static let shared = APIService()
    private init() {}

    private let baseURL = "https://d371-2a0d-b201-1081-82df-6408-f971-7425-bd73.ngrok-free.app"

    // MARK: - Login
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/login") else {
            completion(.failure(APIError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      let data = data else {
                    completion(.failure(APIError.invalidResponse))
                    return
                }

                if httpResponse.statusCode == 200 {
                    do {
                        let result = try JSONDecoder().decode(TokenResponse.self, from: data)
                        UserDefaults.standard.set(result.token, forKey: "token")
                        completion(.success(result.token))
                    } catch {
                        completion(.failure(APIError.decodingError))
                    }
                } else {
                    completion(.failure(APIError.custom("Неверный email или пароль")))
                }
            }
        }.resume()
    }

    // MARK: - Register
    func register(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/api/register") else {
            completion(.failure(APIError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(APIError.invalidResponse))
                    return
                }

                if httpResponse.statusCode == 201 {
                    completion(.success(()))
                } else {
                    completion(.failure(APIError.custom("Ошибка регистрации")))
                }
            }
        }.resume()
    }

    // MARK: - Upload Document
    func uploadDocument(fileURL: URL, completion: @escaping (Result<String, Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            completion(.failure(APIError.unauthorized))
            return
        }

        guard let url = URL(string: "\(baseURL)/api/analyze") else {
            completion(.failure(APIError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        var data = Data()
        let filename = fileURL.lastPathComponent
        let mimetype = mimeType(for: filename)

        if let fileData = try? Data(contentsOf: fileURL) {
            data.append("--\(boundary)\r\n")
            data.append("Content-Disposition: form-data; name=\"document\"; filename=\"\(filename)\"\r\n")
            data.append("Content-Type: \(mimetype)\r\n\r\n")
            data.append(fileData)
            data.append("\r\n")
            data.append("--\(boundary)--\r\n")
        } else {
            completion(.failure(APIError.custom("Не удалось прочитать файл")))
            return
        }

        request.httpBody = data

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data,
                      let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(APIError.invalidResponse))
                    return
                }

                if httpResponse.statusCode == 200 {
                    if let html = String(data: data, encoding: .utf8) {
                        completion(.success(html))
                    } else {
                        completion(.failure(APIError.invalidData))
                    }
                } else {
                    let message = String(data: data, encoding: .utf8) ?? "Ошибка анализа"
                    completion(.failure(APIError.custom(message)))
                }
            }
        }.resume()
    }

    // MARK: - Fetch History
    func fetchHistory(completion: @escaping (Result<[AnalysisEntry], Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            completion(.failure(APIError.unauthorized))
            return
        }

        guard let url = URL(string: "\(baseURL)/api/history") else {
            completion(.failure(APIError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data,
                      let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(APIError.invalidResponse))
                    return
                }

                if httpResponse.statusCode == 200 {
                    do {
                        let result = try JSONDecoder().decode([AnalysisEntry].self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(APIError.decodingError))
                    }
                } else {
                    completion(.failure(APIError.custom("Ошибка загрузки истории")))
                }
            }
        }.resume()
    }

    // MARK: - Get Role
    func getRole(completion: @escaping (Result<String, Error>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            completion(.failure(APIError.unauthorized))
            return
        }

        guard let url = URL(string: "\(baseURL)/api/role") else {
            completion(.failure(APIError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data,
                      let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(APIError.invalidResponse))
                    return
                }

                if httpResponse.statusCode == 200 {
                    if let role = String(data: data, encoding: .utf8) {
                        completion(.success(role.trimmingCharacters(in: .whitespacesAndNewlines)))
                    } else {
                        completion(.failure(APIError.invalidData))
                    }
                } else {
                    completion(.failure(APIError.custom("Ошибка получения роли")))
                }
            }
        }.resume()
    }

    // MARK: - Helpers
    private func mimeType(for filename: String) -> String {
        if filename.hasSuffix(".pdf") {
            return "application/pdf"
        } else if filename.hasSuffix(".docx") {
            return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        } else {
            return "text/plain"
        }
    }
}

// MARK: - Extensions

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}


// MARK: - Errors

enum APIError: LocalizedError {
    case unauthorized
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingError
    case custom(String)

    var errorDescription: String? {
        switch self {
        case .unauthorized: return "Пользователь не авторизован"
        case .invalidURL: return "Некорректный URL"
        case .invalidResponse: return "Некорректный ответ от сервера"
        case .invalidData: return "Невозможно прочитать данные"
        case .decodingError: return "Ошибка обработки ответа"
        case .custom(let message): return message
        }
    }
}
