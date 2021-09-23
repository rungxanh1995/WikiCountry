//
//  MainCoordinator.swift
//  WikiCountries
//
//  Created by Joe Pham on 2021-05-24.
//

import UIKit
import SafariServices // remove this if you'd like a WKWebView instead

class MainCoordinator: Coordinator {
	internal var children			= [Coordinator]()
	
	internal var navigationController: UINavigationController
	init(navigationController: UINavigationController) {
		self.navigationController	= navigationController
	}
	
	internal func start() {
		let vc						= CountryListViewController.instantiate()
		vc.coordinator				= self
		vc.showCountryAction		= show(_:)
		navigationController.pushViewController(vc, animated: false)
	}
	
	private func show(_ country: Country) {
		let detailVC				= CountryDetailViewController.instantiate()
		detailVC.dataSource.country	= country
		
		// enclose in a navController to get bar buttons in modal VC
		let navController 			= UINavigationController(rootViewController: detailVC)
		navigationController.present(navController, animated: true)
		
		// Uncomment this if decided to go with pushViewController instead of a modal VC
//		detailVC.coordinator		= self
//		detailVC.readCountryAction	= read(_:)
//		navigationController.pushViewController(detailVC, animated: false)
	}

	
//	private func read(_ url: URL) {
//		// Use a SFSafariViewController
//		navigationController.presentSafariVC(with: url)
//	}
}
