//
//  ViewController.swift
//  WikiCountries
//
//  Created by Joe Pham on 2021-05-19.
//

import UIKit

class CountryListViewController: UITableViewController, Storyboarded {
	internal weak var coordinator: MainCoordinator?
	private var countryListDataSource = CountryListDataSource()
	
	typealias ShowCountryAction = (Country) -> Void
	internal var showCountryAction: ShowCountryAction?
	
	private let searchController = UISearchController(searchResultsController: nil)
	private var isSearchBarEmpty: Bool {
		return searchController.searchBar.text?.isEmpty ?? true
	}
	private var isFiltering: Bool {
		return searchController.isActive && !isSearchBarEmpty
	}
	
	fileprivate func configureSearchController() {
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search Countries, Capitals, Demonyms"
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		definesPresentationContext = true
	}
	
	fileprivate func populateCountryList() {
		countryListDataSource.countries = Bundle.main.decode(from: Utils.jsonSourceURL)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = countryListDataSource
		tableView.delegate = self
		if !UIDevice.current.isCatalystMacIdiom {
		tableView.refreshControl = UIRefreshControl()
		tableView.refreshControl?.tintColor = UIColor.systemPink
		tableView.refreshControl?.addTarget(self,
											action: #selector(didPullToRefresh(_:)),
											for: .valueChanged)
		}
		tableView.rowHeight = 68
		title = "WikiCountry"
		navigationController?.navigationBar.prefersLargeTitles = true
		configureSearchController()
		DispatchQueue.global(qos: .userInteractive).async { [weak self] in
			self?.populateCountryList()
			DispatchQueue.main.async {
				self?.tableView.reloadData()
			}
		}
	}
}

extension CountryListViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if Utils.isHapticAvailable {
			Utils.hapticFeedback(from: .cell)
		}
		let country = countryListDataSource.country(at: indexPath.row)
		showCountryAction?(country)
	}
}

extension CountryListViewController: UISearchResultsUpdating {
	internal func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		filterContentForSearchText(searchBar.text!)
	}
}

extension CountryListViewController {
	fileprivate func filterContentForSearchText(_ searchText: String) {
		countryListDataSource.isFiltering = isFiltering
		countryListDataSource.filteredCountries = countryListDataSource.countries.filter { (country: Country) -> Bool in
			return country.name.lowercased().contains(searchText.lowercased()) || country.capital.lowercased().contains(searchText.lowercased()) || country.demonym.lowercased().contains(searchText.lowercased())
		}
		tableView.reloadData()
	}
}

extension CountryListViewController {
	/// Enables pull to refresh on iDevices
	///
	/// Perform a device check before performing this function. Otherwise the app would crash in Mac Catalyst
	@objc
	func didPullToRefresh(_ sender: Any) {
		DispatchQueue.global(qos: .userInteractive).async { [weak self] in
			self?.populateCountryList()
			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
				self?.tableView.reloadData()
				self?.tableView.refreshControl?.endRefreshing()
			}
		}
	}
}
