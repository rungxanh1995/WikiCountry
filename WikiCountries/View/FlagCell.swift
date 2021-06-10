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
		flagImageView.image = UIImage(named: Utils.getFlagFileName(code: country.alpha2Code, type: .HD))
		flagImageView.layer.borderWidth = 1
		flagImageView.layer.borderColor = UIColor.systemFill.cgColor
		flagImageView.layer.cornerRadius = 7
		flagImageView.layer.masksToBounds = true
		
		let flagHeight: CGFloat = 140
		let flagRatio: CGFloat = flagImageView.image?.getImageRatio() ?? 1.5
		let flagWidth = flagHeight * flagRatio
		NSLayoutConstraint.activate([
			flagImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
			flagImageView.heightAnchor.constraint(equalToConstant: flagHeight),
			flagImageView.widthAnchor.constraint(equalToConstant: flagWidth),
			flagImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
			flagImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			flagImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
		])
	}
}
