//
//  ResultView.swift
//  LegallyAI
//
//  Created by Алуа Жолдыкан on 19.06.2025.
//


import SwiftUI
import WebKit

struct ResultView: View {
    let htmlContent: String

    var body: some View {
        ScrollView {
            HTMLView(htmlContent: htmlContent)
                .frame(minHeight: 400)
        }
        .navigationTitle("Результат")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HTMLView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        webview.isOpaque = false
        webview.backgroundColor = .clear
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}
