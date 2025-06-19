//
//  HistoryViewModel.swift
//  LegallyAI
//
//  Created by Алуа Жолдыкан on 19.06.2025.
//
import Foundation

class HistoryViewModel: ObservableObject {
    @Published var entries: [AnalysisEntry] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchHistory() {
        isLoading = true
        errorMessage = nil

        APIService.shared.fetchHistory { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    self.entries = data
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
