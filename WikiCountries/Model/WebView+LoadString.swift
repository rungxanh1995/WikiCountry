//
//  WebView+LoadString.swift
//  WikiCountries
//
//  Created by Joe Pham on 2021-05-26.
//

import WebKit

extension WKWebView {
	func load(_ urlString: String) {
		guard let url = URL(string: urlString) else { return }
		let request = URLRequest(url: url)
		load(request)
	}
}
