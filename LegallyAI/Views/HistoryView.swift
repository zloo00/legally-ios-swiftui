//
//  HistoryView.swift
//  LegallyAI
//
//  Created by Алуа Жолдыкан on 19.06.2025.
//


import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Загрузка...")
                } else if let error = viewModel.errorMessage {
                    Text("Ошибка: \(error)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if viewModel.entries.isEmpty {
                    Text("Нет предыдущих анализов")
                        .foregroundColor(.gray)
                } else {
                    List(viewModel.entries, id: \.id) { entry in
                        VStack(alignment: .leading) {
                            Text(entry.fileName)
                                .fontWeight(.semibold)
                            Text(entry.dateFormatted)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("История")
            .onAppear {
                viewModel.fetchHistory()
            }
        }
    }
}
