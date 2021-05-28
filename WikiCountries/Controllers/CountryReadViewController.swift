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
	private var navigationDelegate = NavigationDelegate()
	private var wikipediaUrl: String { return "https://en.wikipedia.org/wiki/\(country.name.replacingOccurrences(of: " ", with: "_"))"
	}
	
	override func loadView() {
		webView.navigationDelegate = navigationDelegate
		view = webView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		assert(country != nil, "Please pass a country before showing this view controller")
		title = "Wikipedia: \(country.name)"
		webView.load(wikipediaUrl)
		
		let shareButtonItem = UIBarButtonItem(
			barButtonSystemItem: .action,
			target: self,
			action: #selector(shareWikiLink))
		navigationItem.rightBarButtonItem = shareButtonItem
	}
	
	@objc
	func shareWikiLink() {
		if Utils.isHapticAvailable {
			Utils.hapticFeedback(from: .button)
		}
		guard let url = webView.url?.absoluteURL else { return }
		var shareItems = [Any]()
		shareItems.append(url)
		
		let vc = UIActivityViewController(activityItems: shareItems,
										  applicationActivities: nil)
		vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(vc, animated: true)
	}
}
