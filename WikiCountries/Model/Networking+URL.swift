//
//  Networking+URL.swift
//  WikiCountries
//
//  Created by Joe Pham on 2021-05-24.
//

import Foundation

extension Bundle {
	func decode<T: Decodable>(from resourceString: String, isNetworkConnected: Bool) -> T {
		guard let url = isNetworkConnected ? URL(string: resourceString) : Bundle.main.url(forResource: resourceString, withExtension: "json") else {
			fatalError("Unable to decode URL from \(resourceString)")
		}
		guard let data = try? Data(contentsOf: url) else {
			fatalError("Failed to load data from \(resourceString)")
		}
		guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
			fatalError("Failed to decode data from \(resourceString)")
		}
		return decoded
	}
}
