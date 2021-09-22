//
//  CountryDetailViewController.swift
//  WikiCountries
//
//  Created by Joe Pham on 2021-05-20.
//

import UIKit
import SafariServices

class CountryDetailViewController: UITableViewController, Storyboarded {
	
	internal weak var coordinator:	MainCoordinator?
	internal let dataSource			= CountryDetailDataSource()
	private var country: Country	{ return dataSource.getCountry() }
	
	typealias ReadCountryAction		= (URL) -> Void
	internal var readCountryAction: ReadCountryAction?
	
	private var pasteBoard			= UIPasteboard.general
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource	= dataSource
		tableView.delegate		= self
		configureTitleBar()
		configureRightBarButtonItems()
	}
	
	
	final func configureTitleBar() {
		title = country.name
		navigationItem.largeTitleDisplayMode	= .automatic
		navigationItem.backButtonDisplayMode	= .minimal
	}
	
	
	final func configureRightBarButtonItems() {
		
		let read = UIAction(title: "Read on Wikipedia", image: SFSymbol.book, handler: { [weak self] action in self?.readCountry(action)
		})
		
		let share = UIAction(title: "Share Facts", image: SFSymbol.share, handler: { [weak self] action in self?.shareFacts(action)
		})
		
		let	actions	= [read, share]
		let menu = UIMenu(title: "More", image: nil, identifier: nil, options: [], children: actions)
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: SFSymbol.more, primaryAction: nil, menu: menu)
	}
	
	
	final func readCountry(_ action: UIAction) {
		let wikipediaUrl: String = "https://en.wikipedia.org/wiki/\(country.name.replacingOccurrences(of: " ", with: "_"))"
		guard let url = URL(string: wikipediaUrl) else {
			if UIDevice.isHapticAvailable { UIDevice.hapticFeedback(from: .button, isSuccessful: false) }
			return
		}
		if UIDevice.isHapticAvailable { UIDevice.hapticFeedback(from: .button, isSuccessful: true) }
		readCountryAction?(url)
	}
	
	
	final func shareFacts(_ action: UIAction) {
		if UIDevice.isHapticAvailable { UIDevice.hapticFeedback(from: .button) }
		let flag = UIImage(named: Utils.getFlagFileName(code: (country.alpha2Code), type: .HD))
		let text = dataSource.createShareText()
		let shareItems = [flag as Any, text]
		
		let vc = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
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
			if UIDevice.isHapticAvailable { UIDevice.hapticFeedback(from: .cell, isSuccessful: false) }
			return false
		} // exclude the flag cell
		if UIDevice.isHapticAvailable { UIDevice.hapticFeedback(from: .cell, isSuccessful: true) }
		return true
	}
	
	override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
		if (action == #selector(UIResponderStandardEditActions.copy)) { return true }
		return false
	}
	
	override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
		guard let cell = tableView.cellForRow(at: indexPath) else { return }
		guard cell.textLabel?.text != nil else { return }
		pasteBoard.string = cell.textLabel?.text
	}
}
