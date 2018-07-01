//
//  RightDetailTableViewCell.swift
//  Jetman
//
//  Created by Thomas Ganley on 7/1/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class RightDetailTableViewCell: UITableViewCell {
    @IBOutlet var primaryLabel: UILabel!
    @IBOutlet var secondaryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    func configureWith(primaryText: String, secondaryText: String? = nil) {
        primaryLabel.text = primaryText
        secondaryLabel.text = secondaryText
    }
}
