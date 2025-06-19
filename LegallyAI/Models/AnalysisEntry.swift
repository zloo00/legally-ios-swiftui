//
//  AnalysisEntry.swift
//  LegallyAI
//
//  Created by Алуа Жолдыкан on 19.06.2025.
//
import Foundation

struct AnalysisEntry: Identifiable, Codable {
    let id: String
    let fileName: String
    let createdAt: String

    var dateFormatted: String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: createdAt) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        return createdAt
    }
}
