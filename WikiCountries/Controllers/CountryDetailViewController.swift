//
//  CountryDetailViewController.swift
//  WikiCountries
//
//  Created by Joe Pham on 2021-05-20.
//

import UIKit
import SafariServices

class CountryDetailViewController: UITableViewController, Storyboarded {
	weak var coordinator: MainCoordinator?
	let countryDetailDataSource = CountryDetailDataSource()
	var country: Country {
		return countryDetailDataSource.getCountry()
	}
	private var wikipediaUrl: String { return "https://en.wikipedia.org/wiki/\(country.name.replacingOccurrences(of: " ", with: "_"))"
	}
	
	typealias ReadCountryAction = (Country, URL) -> Void
	var readCountryAction: ReadCountryAction?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = countryDetailDataSource
		tableView.delegate = self
		title = country.name
		navigationItem.largeTitleDisplayMode = .never
		
		let shareButtonItem = UIBarButtonItem(
			barButtonSystemItem: .action,
			target: self,
			action: #selector(shareFacts))
		let wikiButtonItem = UIBarButtonItem(
			image: UIImage(systemName: "book"),
			style: .plain,
			target: self,
			action: #selector(readCountry))
		navigationItem.rightBarButtonItems = [shareButtonItem, wikiButtonItem]
	}
	
	@objc
	func readCountry() {
		if Utils.isHapticAvailable {
			Utils.hapticFeedback(from: .button)
		}
		guard let url = URL(string: wikipediaUrl) else { return }
		readCountryAction?(country, url)
	}
	
	@objc
	func shareFacts() {
		if Utils.isHapticAvailable {
			Utils.hapticFeedback(from: .button)
		}
		var shareItems = [Any]()
		if let flag = UIImage(named: Utils.getFlagFileName(code: (country.alpha2Code), type: .HD))?.pngData() {
			shareItems.append(flag)
		}
		shareItems.append(countryDetailDataSource.getSharedText())
		
		let vc = UIActivityViewController(activityItems: shareItems,
										  applicationActivities: nil)
		vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(vc, animated: true)
	}
}

extension CountryDetailViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
