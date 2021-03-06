//
//  ViewController.swift
//  WikiCountries
//
//  Created by Joe Pham on 2021-05-19.
//

import UIKit

class CountryListViewController: UITableViewController, Storyboarded {
	internal weak var coordinator: MainCoordinator?
	private var dataSource = CountryListDataSource()
	
	typealias ShowCountryAction = (Country) -> Void
	internal var showCountryAction: ShowCountryAction?
	
	private let searchController = UISearchController(searchResultsController: nil)
	private var isSearchBarEmpty: Bool {
		return searchController.searchBar.text?.isEmpty ?? true
	}
	private var isFiltering: Bool {
		return searchController.isActive && !isSearchBarEmpty
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureDataSource()
		configureDelegate()
		/**
		If decided to change the macOS version to "Optimized Interface for Mac",
		then include a conditional to exclude refreshControl if not a Mac idiom
		*/
		if !(UIDevice.isCatalystMacIdiom) { configurePullToRefresh() }
		tableView.rowHeight = 65
		configureTitleBar()
		configureSearchController()
		DispatchQueue.global(qos: .userInteractive).async { [weak self] in
			guard let self = self else { return }
			self.populateCountryList()
			DispatchQueue.main.async { self.tableView.reloadData() }
		}
	}
}

extension CountryListViewController {
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if UIDevice.isHapticAvailable { UIDevice.hapticFeedback(from: .cell) }
		let country = dataSource.country(at: indexPath.row)
		showCountryAction?(country)
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	final func configureDataSource() {
		tableView.dataSource = dataSource
	}
	
	final func configureDelegate() {
		tableView.delegate = self
	}
	
	fileprivate func configureSearchController() {
		definesPresentationContext					= true
		searchController.searchBar.placeholder		= "Search Countries, Capitals, Demonyms"
		searchController.searchResultsUpdater		= self
		searchController.obscuresBackgroundDuringPresentation = false
		navigationItem.searchController				= searchController
		navigationItem.hidesSearchBarWhenScrolling	= DeviceTypes.isiPhoneSE ? true : false
	}
	
	fileprivate func populateCountryList() {
		
		#warning("RESTCountries URL has changed. Resort to decoding from backup json file")
		
		dataSource.countries = Bundle.main.decode(from: Constants.jsonFileName, isNetworkConnected: false)
		
//		if NetworkMonitor.shared.isConnected {
//			/// Connected to the internet => Using json data from url
//			dataSource.countries = Bundle.main.decode(from: Constants.jsonSourceURL, isNetworkConnected: true)
//		} else {
//			/// No internet => Using backup json file from app bundle
//			dataSource.countries = Bundle.main.decode(from: Constants.jsonFileName, isNetworkConnected: false)
//		}
	}
	
	fileprivate func configureTitleBar() {
		title = "WikiCountry"
		navigationController?.navigationBar.prefersLargeTitles = true
	}
}

extension CountryListViewController: UISearchResultsUpdating {
	
	internal func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		filterContentForSearchText(searchBar.text!)
	}
}

extension CountryListViewController {
	private func configurePullToRefresh() {
		tableView.refreshControl			= UIRefreshControl()
		tableView.refreshControl?.tintColor = UIColor.systemPink
		tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
	}
	
	/// Enables pull to refresh on iDevices
	///
	/// Perform a device check before performing this function. Otherwise the app would crash in Mac Catalyst
	@objc
	private func didPullToRefresh(_ sender: Any) {
		DispatchQueue.global(qos: .userInteractive).async { [weak self] in
			guard let self = self else { return }
			self.populateCountryList()
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
				self.tableView.reloadData()
				self.tableView.refreshControl?.endRefreshing()
			}
		}
	}
	
	fileprivate func filterContentForSearchText(_ searchText: String) {
		dataSource.isFiltering			= isFiltering
		dataSource.filteredCountries	= dataSource.countries.filter {
			$0.name.lowercased().contains(searchText.lowercased()) ||
			$0.capital.lowercased().contains(searchText.lowercased()) ||
			$0.demonym.lowercased().contains(searchText.lowercased())
		}
		tableView.reloadData()
	}
}
