//
//  CountryDetailViewController.swift
//  WikiCountries
//
//  Created by Joe Pham on 2021-05-20.
//

import UIKit
import SafariServices

class CountryDetailViewController: UITableViewController, Storyboarded {
	
	// uncomment this if want to use coordinator
//	internal weak var coordinator:	MainCoordinator?
//	typealias ReadCountryAction		= (URL) -> Void
//	internal var readCountryAction: ReadCountryAction?
	
	internal let dataSource			= CountryDetailDataSource()
	private var country: Country	{ return dataSource.getCountry() }
	
	private var pasteBoard			= UIPasteboard.general
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource	= dataSource
		tableView.delegate		= self
		configureTitleBar()
	}
	
	
	final func configureTitleBar() {
		title = country.name
		configureToolbarItems()
	}
	
	
	final func configureToolbarItems() {
		
		let read = UIAction(title: "Read on Wikipedia", image: SFSymbol.book, handler: { [weak self] action in self?.readCountry(action)
		})
		
		let share = UIAction(title: "Share Facts", image: SFSymbol.share, handler: { [weak self] action in self?.shareFacts(action)
		})
		
		let	actions	= [read, share]
		let menu	= UIMenu(title: "More", image: nil, identifier: nil, options: [], children: actions)
		let more	= UIBarButtonItem(title: nil, image: SFSymbol.more, primaryAction: nil, menu: menu)
		let done	= UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
		
		navigationItem.leftBarButtonItem	= done
		navigationItem.rightBarButtonItem	= more
	}
	
	
	@objc
	final func dismissVC() { dismiss(animated: true) }
	
	
	final func readCountry(_ action: UIAction) {
		let wikipediaUrl: String = "https://en.wikipedia.org/wiki/\(country.name.replacingOccurrences(of: " ", with: "_"))"
		guard let url = URL(string: wikipediaUrl) else {
			if UIDevice.isHapticAvailable { UIDevice.hapticFeedback(from: .button, isSuccessful: false) }
			return
		}
		if UIDevice.isHapticAvailable { UIDevice.hapticFeedback(from: .button, isSuccessful: true) }
		
		presentSafariVC(with: url)
		
//		readCountryAction?(url) // use this if want to go with coordinator instead
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
