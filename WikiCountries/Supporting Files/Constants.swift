//
//  Constants.swift
//  WikiCountry
//
//  Created by Joe Pham on 2021-06-14.
//

import Foundation

struct Constants {
	static let mainStoryboardName = "Main"
	static let detailStoryboardIdentifier = "CountryDetailViewController"
	static let infoCellIdentifier = "Info"
	static let jsonSourceURL = "https://restcountries.eu/rest/v2/all?fields=name;alpha2Code;capital;population;demonym;area;nativeName;currencies;languages;flag;region;timezones"
	static let jsonFileName = "Countries"
}
