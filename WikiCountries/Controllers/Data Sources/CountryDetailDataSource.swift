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
		case languages = "Major Languages"
		case langCodes = "Language Codes"
		case currencies = "Currencies"
	}
	private let sectionTitles: [Section] = [.flag, .general, .languages, .langCodes, .currencies]
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
			let cell = tableView.dequeueReusableCell(withIdentifier: Utils.infoCellIdentifier, for: indexPath)
			cell.textLabel?.numberOfLines = 0
			switch indexPath.row {
			case 0: cell.textLabel?.text = buildName()
			case 1: cell.textLabel?.text = buildDemonym()
			case 2: cell.textLabel?.text = buildCapital()
			case 3: cell.textLabel?.text = buildPopulation()
			case 4: cell.textLabel?.text = buildArea()
			default: return cell
			}
			return cell
		case .languages:
			let cell = tableView.dequeueReusableCell(withIdentifier: Utils.infoCellIdentifier, for: indexPath)
			cell.textLabel?.numberOfLines = 0
			cell.textLabel?.text = buildLanguage(country.languages[indexPath.row])
			return cell
		case .langCodes:
			let cell = tableView.dequeueReusableCell(withIdentifier: Utils.infoCellIdentifier, for: indexPath)
			cell.textLabel?.numberOfLines = 0
			cell.textLabel?.text = buildLangCode(country.languages[indexPath.row])
			return cell
		case .currencies:
			let cell = tableView.dequeueReusableCell(withIdentifier: Utils.infoCellIdentifier, for: indexPath)
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
		return "Population: unknown"
	}
	
	fileprivate func buildArea() -> String {
		if let area = Utils.numberFormatter.string(for: country.area) {
			return "Area: \(area) km²"
		}
		return "Area: N/A"
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
		let name = currency.name ?? "Unknown name"
		let code = currency.code ?? "Unknown code"
		let symbol = currency.symbol ?? "Unknown symbol"
		return "\(name) · \(code) · \(symbol)"
	}
	
	internal func getSharedText() -> String {
		var text = """
		About \(country.name)
		General
		-\t\(buildName())
		-\t\(buildDemonym())
		-\t\(buildCapital())
		-\t\(buildPopulation())
		-\t\(buildArea())
		Languages
		"""
		for language in country.languages {
			text += "\n-\t\(buildLanguage(language))"
		}
		text.append(contentsOf: "\nLanguage Codes")
		for code in country.languages {
			text += "\n-\t\(buildLangCode(code))"
		}
		text.append(contentsOf: "\nCurrencies")
		for currency in country.currencies {
			text += "\n-\t\(buildCurrency(currency))"
		}
		return text
	}
}
