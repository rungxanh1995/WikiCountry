//
//  Environment+Device.swift
//  WikiCountry
//
//  Created by Joe Pham on 2021-06-02.
//

import UIKit

extension UIDevice {
	/// Checks if we run in Mac Catalyst Optimized For Mac Idiom
	var isCatalystMacIdiom: Bool {
		if #available(iOS 14, *) {
			return UIDevice.current.userInterfaceIdiom == .mac
		} else {
			return false
		}
	}
}
