//
//  Constants.swift
//  WikiCountries
//
//  Created by Joe Pham on 2021-05-19.
//

import UIKit

enum Utils {
	static let prefixSD			= "flag_sd_"
	static let prefixHD			= "flag_hd_"
	static let fileExtension	= ".png"
	
	enum FlagType {
		case HD
		case SD
	}
	
	static func getFlagFileName(code: String, type: FlagType) -> String {
		return getFlagPrefix(type: type) + code + fileExtension
	}
	
	static func getFlagPrefix(type: FlagType) -> String {
		switch type {
		case .HD: return Utils.prefixHD
		case .SD: return Utils.prefixSD
		}
	}
}

extension Utils {
	static let numberFormatter: NumberFormatter = {
		let formatter			= NumberFormatter()
		formatter.numberStyle	= .decimal
		return formatter
	}()
}
