//
//  UploadViewModel.swift
//  LegallyAI
//
//  Created by Алуа Жолдыкан on 19.06.2025.
//

// ViewModels/UploadViewModel.swift
import Foundation
import SwiftUI

class UploadViewModel: ObservableObject {
    @Published var fileURL: URL?
    @Published var isLoading = false
    @Published var analysisResult: String?
    @Published var errorMessage: String?
    @Published var showResult = false
    @Published var showError = false

    func resetFile() {
        fileURL = nil
    }

    func analyzeDocument() {
        guard let url = fileURL else { return }

        isLoading = true
        showResult = false
        errorMessage = nil

        APIService.shared.uploadDocument(fileURL: url) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let html):
                    self.analysisResult = html
                    self.showResult = true
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
        }
    }
}
