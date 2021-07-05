//
//  MainCoordinator.swift
//  WikiCountries
//
//  Created by Joe Pham on 2021-05-24.
//

import UIKit
import SafariServices // remove this if you'd like a WKWebView instead

class MainCoordinator: Coordinator {
	internal var children = [Coordinator]()
	
	internal var navigationController: UINavigationController
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	internal func start() {
		let vc = CountryListViewController.instantiate()
		vc.coordinator = self
		vc.showCountryAction = show(_:)
		navigationController.pushViewController(vc, animated: false)
	}
	
	private func show(_ country: Country) {
		let detailVC = CountryDetailViewController.instantiate()
		detailVC.coordinator = self
		detailVC.countryDetailDataSource.country = country
		detailVC.readCountryAction = read(_:) // change to read(_:) for a WKWebView
		navigationController.pushViewController(detailVC, animated: true)
	}
	
//	Use this function if you'd like a WKWebView instead
//	func read(_ country: Country) {
//		let readVC = CountryReadViewController.instantiate()
//		readVC.country = country
//		navigationController.pushViewController(readVC, animated: true)
//	}
	
	private func read(_ url: URL) {
		// Used a SFSafariViewController
		navigationController.presentSafariVC(with: url)
	}
}
