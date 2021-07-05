//
//  Image+Ratio.swift
//  WikiCountry
//
//  Created by Joe Pham on 2021-06-09.
//

import UIKit

extension UIImage {
	func getImageRatio() -> CGFloat {
		let widthRatio = CGFloat(self.size.width / self.size.height)
		return widthRatio
	}
}
