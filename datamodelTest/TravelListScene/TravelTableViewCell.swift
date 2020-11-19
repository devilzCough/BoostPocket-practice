//
//  TravelTableViewCell.swift
//  datamodelTest
//
//  Created by sihyung you on 2020/11/18.
//  Copyright © 2020 SihyungYou. All rights reserved.
//

import UIKit

class TravelTableViewCell: UITableViewCell {
    static let identifier = "TravelTableViewCell"
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    
    func configure(with travel: Travel) {
        self.nameLabel.text = travel.title
    }
}
