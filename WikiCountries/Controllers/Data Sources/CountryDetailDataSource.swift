//
//  CountryDetailDataSource.swift
//  WikiCountries
//
//  Created by Joe Pham on 2021-05-20.
//

import UIKit

class CountryDetailDataSource: NSObject {
	internal var country: Country!
	internal func getCountry() -> Country {
		return country
	}
	
	private enum Section: String {
		case flag = "Flag"
		case general = "General"
		case timezones = "Time Zones"
		case languages = "Major Languages"
		case langCodes = "Language Codes"
		case currencies = "Currencies"
	}
	private let sectionTitles: [Section] = [.flag, .general, .timezones, .languages, .langCodes, .currencies]
}

extension CountryDetailDataSource: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return sectionTitles.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch sectionTitles[section] {
		case .flag:
			return 1
		case .general:
			return 5
		case .timezones:
			return country.timezones.count
		case .languages, .langCodes:
			return country.languages.count
		case .currencies:
			return country.currencies.count
		}
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sectionTitles[section].rawValue
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		switch sectionTitles[indexPath.section] {
		case .flag:
			let cell = tableView.dequeueReusableCell(withIdentifier: FlagCell.identifier, for: indexPath)
			if let cell = cell as? FlagCell {
				cell.configure(for: country)
			}
			return cell
		case .general:
			let cell = tableView.dequeueReusableCell(withIdentifier: Constants.infoCellIdentifier, for: indexPath)
			cell.textLabel?.numberOfLines = 0
			switch indexPath.row {
			case 0: cell.textLabel?.text = buildName()
			case 1: cell.textLabel?.text = buildRegion()
			case 2: cell.textLabel?.text = buildDemonym()
			case 3: cell.textLabel?.text = buildCapital()
			case 4: cell.textLabel?.text = buildPopulation()
			case 5: cell.textLabel?.text = buildArea()
			default: return cell
			}
			return cell
		case .timezones:
			let cell = tableView.dequeueReusableCell(withIdentifier: Constants.infoCellIdentifier, for: indexPath)
			cell.textLabel?.numberOfLines = 0
			cell.textLabel?.text = buildTimezone(country.timezones[indexPath.row])
			return cell
		case .languages:
			let cell = tableView.dequeueReusableCell(withIdentifier: Constants.infoCellIdentifier, for: indexPath)
			cell.textLabel?.numberOfLines = 0
			cell.textLabel?.text = buildLanguage(country.languages[indexPath.row])
			return cell
		case .langCodes:
			let cell = tableView.dequeueReusableCell(withIdentifier: Constants.infoCellIdentifier, for: indexPath)
			cell.textLabel?.numberOfLines = 0
			cell.textLabel?.text = buildLangCode(country.languages[indexPath.row])
			return cell
		case .currencies:
			let cell = tableView.dequeueReusableCell(withIdentifier: Constants.infoCellIdentifier, for: indexPath)
			cell.textLabel?.numberOfLines = 0
			cell.textLabel?.text = buildCurrency(country.currencies[indexPath.row])
			return cell
		}
	}
}

extension CountryDetailDataSource {
	fileprivate func buildName() -> String {
		return "Name: \(country.name) · \(country.nativeName)"
	}
	
	fileprivate func buildRegion() -> String {
		if country.region == .empty {
			return "Region: N/A"
		}
		return "Region: \(country.region.rawValue)"
	}
	
	fileprivate func buildDemonym() -> String {
		if country.demonym == "" {
			return "Demonym: N/A"
		}
		return "Demonym: \(country.demonym)"
	}
	
	fileprivate func buildCapital() -> String {
		if country.capital == "" {
			return "Capital: N/A"
		}
		return "Capital: \(country.capital)"
	}
	
	fileprivate func buildPopulation() -> String {
		if let population = Utils.numberFormatter.string(for: country.population) {
			return "Population: \(population)"
		}
		return "Population: N/A"
	}
	
	fileprivate func buildArea() -> String {
		if let area = Utils.numberFormatter.string(for: country.area) {
			return "Area: \(area) km²"
		}
		return "Area: N/A"
	}
	
	fileprivate func buildTimezone(_ timezone: String) -> String {
		return "\(timezone)"
	}
	
	fileprivate func buildLangCode(_ language: Language) -> String {
		if let iso6391 = language.iso6391 {
			return "\(iso6391), \(language.iso6392)"
		}
		return "\(language.iso6392)"
	}
	
	fileprivate func buildLanguage(_ language: Language) -> String {
		return "\(language.name) · \(language.nativeName)"
	}
	
	fileprivate func buildCurrency(_ currency: Currency) -> String {
		let name = currency.name ?? ""
		let code = currency.code ?? ""
		let symbol = currency.symbol ?? ""
		return "\(name) · \(code) · \(symbol)"
	}
	
	internal func createShareText() -> String {
		var text = """
		About \(country.name)
		General
		-\t\(buildName())
		-\t\(buildRegion())
		-\t\(buildDemonym())
		-\t\(buildCapital())
		-\t\(buildPopulation())
		-\t\(buildArea())
		"""
		
		text.append(contentsOf: country.timezones.count == 1 ? "\n1 Time Zone:" : "\n\(country.timezones.count) Time Zones:")
		for timezone in country.timezones {
			text += "\n-\t\(buildTimezone(timezone))"
		}
		
		text.append(contentsOf: country.languages.count == 1 ? "\n1 Major Language:" : "\n\(country.languages.count) Major Languages:")
		for language in country.languages {
			text += "\n-\t\(buildLanguage(language))"
		}
		
		text.append(contentsOf: country.languages.count == 1 ? "\n1 Language Code:" : "\n\(country.languages.count) Language Codes:")
		for code in country.languages {
			text += "\n-\t\(buildLangCode(code))"
		}
		
		text.append(contentsOf: country.currencies.count == 1 ? "\n1 Currency:" : "\n\(country.currencies.count) Currencies:")
		for currency in country.currencies {
			text += "\n-\t\(buildCurrency(currency))"
		}
		
		return text
	}
}
