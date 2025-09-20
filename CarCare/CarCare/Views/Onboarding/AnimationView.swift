//
//  LottieView.swift
//  CarCare
//
//  Created by Ordinateur elena on 20/09/2025.
//

import SwiftUI
import WebKit

struct AnimationView: UIViewRepresentable {
	let name: String
	
	func makeUIView(context: Context) -> WKWebView {
		let webView = WKWebView()
		webView.isUserInteractionEnabled = false
		webView.isOpaque = false                 // ✅ Rend le WebView transparent
		webView.backgroundColor = .clear         // ✅ Fond transparent
		webView.scrollView.backgroundColor = .clear
		return webView
	}
	
	func updateUIView(_ uiView: WKWebView, context: Context) {
		if let path = Bundle.main.path(forResource: name, ofType: "gif") {
			let data = try! Data(contentsOf: URL(fileURLWithPath: path))
			uiView.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: URL(fileURLWithPath: path))
		}
	}
}

