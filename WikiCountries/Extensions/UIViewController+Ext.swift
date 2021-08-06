//
//  UIViewController+Ext.swift
//  WikiCountry
//
//  Created by Joe Pham on 2021-07-04.
//

import UIKit
import SafariServices

extension UIViewController {
	
	func presentSafariVC(with url: URL) {
		let safariVC = SFSafariViewController(url: url)
		safariVC.preferredControlTintColor	= .systemPink
		safariVC.modalPresentationStyle		= .automatic
		present(safariVC, animated: true)
	}
}
