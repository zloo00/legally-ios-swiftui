//
//  UploadView.swift
//  LegallyAI
//
//  Created by Алуа Жолдыкан on 19.06.2025.
//
import SwiftUI
import UniformTypeIdentifiers

struct UploadView: View {
    @StateObject private var viewModel = UploadViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Загрузите документ для анализа")
                    .font(.title2)

                Button(action: viewModel.resetFile) {
                    Text("Выбрать файл")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                if viewModel.isLoading {
                    ProgressView("Анализируем...")
                }

                Spacer()
            }
            .padding()
            .fileImporter(
                isPresented: .constant(viewModel.fileURL == nil),
                allowedContentTypes: [UTType.pdf, UTType.plainText, UTType(filenameExtension: "docx")!],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    if let url = urls.first {
                        viewModel.fileURL = url
                        viewModel.analyzeDocument()
                    }
                case .failure(let error):
                    print("Ошибка выбора файла:", error)
                }
            }
            .navigationDestination(isPresented: $viewModel.showResult) {
                if let result = viewModel.analysisResult {
                    ResultView(htmlContent: result)
                }
            }
            .alert("Ошибка", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "Неизвестная ошибка")
            }
        }
    }
}
