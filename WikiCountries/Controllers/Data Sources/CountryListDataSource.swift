//
//  CountryListDataSource.swift
//  WikiCountries
//
//  Created by Joe Pham on 2021-05-19.
//

import UIKit

class CountryListDataSource: NSObject {
	internal var countries = [Country]()
	internal var filteredCountries = [Country]()
	internal var isFiltering = false
	
	internal func country(at row: Int) -> Country {
		return isFiltering ? filteredCountries[row] : countries[row]
	}
}

extension CountryListDataSource: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		// display "Top Matches" only when results found
		return (isFiltering && filteredCountries.count != 0) ? "Top Matches" : nil
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		(isFiltering && filteredCountries.count == 0) ?
			tableView.setEmptyMessage("No Results")
			:
			tableView.restoreInitialState()
		return isFiltering ? filteredCountries.count : countries.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
				withIdentifier: CountryCell.identifier,
				for: indexPath)
				as? CountryCell else {
			fatalError("Unable to dequeue CountryCell")
		}
		let country = country(at: indexPath.row)
		cell.configure(for: country)
		return cell
	}
}
