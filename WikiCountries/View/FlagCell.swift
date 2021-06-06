//
//  FlagCell.swift
//  WikiCountries
//
//  Created by Joe Pham on 2021-05-19.
//

import UIKit

class FlagCell: UITableViewCell {
	static let identifier = "FlagCell"
	
	var flagImageView: UIImageView = {
		var imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	
	/**
	Prepares the flag image UI before being used
	
	Don't change the image type to .HD or the flag image will overflow
	
	Don't add top and bottom constraints
	
	No need to calculate image ratio
	- author:
	Joe Pham
	- parameters:
		- country: The specific Country type for the flag
	*/
	internal func configure(for country: Country) {
		self.addSubview(flagImageView)
		flagImageView.image = UIImage(named: Utils.getFlagFileName(code: country.alpha2Code, type: .SD))
		flagImageView.layer.borderWidth = 1
		flagImageView.layer.borderColor = UIColor.systemGray.cgColor
		flagImageView.layer.cornerRadius = 7
		flagImageView.layer.masksToBounds = true
		NSLayoutConstraint.activate([
			flagImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
			flagImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
			flagImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			flagImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
		])
	}
}
