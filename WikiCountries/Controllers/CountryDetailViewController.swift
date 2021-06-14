//
//  CountryDetailViewController.swift
//  WikiCountries
//
//  Created by Joe Pham on 2021-05-20.
//

import UIKit
import SafariServices

class CountryDetailViewController: UITableViewController, Storyboarded {
	internal weak var coordinator: MainCoordinator?
	internal let countryDetailDataSource = CountryDetailDataSource()
	private var country: Country {
		return countryDetailDataSource.getCountry()
	}
	private var wikipediaUrl: String { return "https://en.wikipedia.org/wiki/\(country.name.replacingOccurrences(of: " ", with: "_"))"
	}
	
	typealias ReadCountryAction = (Country, URL) -> Void
	internal var readCountryAction: ReadCountryAction?
	
	private var pasteBoard = UIPasteboard.general
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = countryDetailDataSource
		tableView.delegate = self
		configureTitleBar()
		configureRightBarButtonItems()
		
	}
	
	fileprivate func configureTitleBar() {
		title = country.name
		navigationItem.largeTitleDisplayMode = .never
	}
	
	fileprivate func configureRightBarButtonItems() {
		var shareButtonItem: UIBarButtonItem {
			return UIBarButtonItem(
				barButtonSystemItem: .action,
				target: self,
				action: #selector(shareFacts)
			)
		}
		var wikiButtonItem: UIBarButtonItem {
			return UIBarButtonItem(
				image: UIImage(systemName: "book"),
				style: .plain,
				target: self,
				action: #selector(readCountry)
			)
		}
		navigationItem.rightBarButtonItems = [shareButtonItem, wikiButtonItem]
	}
	
	@objc
	private func readCountry() {
		guard let url = URL(string: wikipediaUrl) else {
			if Utils.isHapticAvailable {
				Utils.hapticFeedback(from: .button, isSuccessful: false)
			}
			return
		}
		if Utils.isHapticAvailable {
			Utils.hapticFeedback(from: .button, isSuccessful: true)
		}
		readCountryAction?(country, url)
	}
	
	@objc
	private func shareFacts() {
		if Utils.isHapticAvailable {
			Utils.hapticFeedback(from: .button)
		}
		let flag = UIImage(named: Utils.getFlagFileName(code: (country.alpha2Code), type: .HD))
		let text = countryDetailDataSource.createShareText()
		let shareItems = [flag as Any, text]
		
		let vc = UIActivityViewController(activityItems: shareItems,
										  applicationActivities: nil)
		vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(vc, animated: true)
	}
}

extension CountryDetailViewController {
	// This extension enables press and hold to copy the detail view cell's content
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
		if indexPath.section == 0 {
			if Utils.isHapticAvailable { Utils.hapticFeedback(from: .cell, isSuccessful: false) }
			return false
		} // exclude the flag cell
		if Utils.isHapticAvailable { Utils.hapticFeedback(from: .cell, isSuccessful: true) }
		return true
	}
	
	override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
		if (action == #selector(UIResponderStandardEditActions.copy)) {
			return true
		}
		return false
	}
	
	override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
		guard let cell = tableView.cellForRow(at: indexPath) else { return }
		guard cell.textLabel?.text != nil else { return }
		pasteBoard.string = cell.textLabel?.text
	}
}
