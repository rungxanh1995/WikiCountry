//
//  CountryCell.swift
//  WikiCountries
//
//  Created by Joe Pham on 2021-05-19.
//

import UIKit

class CountryCell: UITableViewCell {
	@IBOutlet weak var flagImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var capitalNameLabel: UILabel!
	
	static let identifier = "CountryCell"
	/**
	Prepares the cell's UI before being used
	- author:
	Joe Pham
	- parameters:
		- country: The specific Country type for the cell
	*/
	internal func configure(for country: Country) {
		flagImageView.image					= UIImage(named: Utils.getFlagFileName(code: country.alpha2Code, type: .SD))
		flagImageView.layer.borderWidth		= 1
		flagImageView.layer.borderColor		= UIColor.systemFill.cgColor
		flagImageView.layer.cornerRadius	= flagImageView.bounds.size.width / 2
		flagImageView.layer.masksToBounds	= true
		flagImageView.contentMode			= .scaleAspectFill
		nameLabel.text						= country.name
		nameLabel.textColor					= .systemPink
		capitalNameLabel.text				= country.capital
	}
}
