//
//  CountryReadViewController.swift
//  WikiCountries
//
//  Created by Joe Pham on 2021-05-26.
//

import UIKit
import WebKit

class CountryReadViewController: UIViewController, Storyboarded {
	var webView = WKWebView()
	var country: Country!
	
	override func loadView() {
		view = webView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		assert(country != nil, "Please pass a country before showing this view controller")
		title = "Wikipedia: \(country.name)"
		webView.load("https://en.wikipedia.org/wiki/\(country.name.replacingOccurrences(of: " ", with: "_"))")
	}
}
