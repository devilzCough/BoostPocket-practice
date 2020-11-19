//
//  CountryTableViewCell.swift
//  datamodelTest
//
//  Created by sihyung you on 2020/11/18.
//  Copyright © 2020 SihyungYou. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    static let identifier = "CountryTableViewCell"
    
    @IBOutlet var countryName: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.accessoryType = .none
    }
    
    func configure(with country: Country) {
        if let identifier = country.identifier,
            let countryName = country.countryName,
            let flagImage = country.flag
        {
            let currencySymbol = getCurrencySymbol(of: identifier)
            self.countryName.text = "\(currencySymbol)\(countryName)"
            self.flagImage.image = UIImage(data: flagImage)
        }
        
    }
    
    private func getCurrencySymbol(of identifer: String) -> String {
        let locale = NSLocale(localeIdentifier: identifer)
        return locale.currencySymbol
    }
    
}
