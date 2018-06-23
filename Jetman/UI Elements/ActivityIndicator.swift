//
//  ActivityIndicator.swift
//  Jetman
//
//  Created by Thomas Ganley on 6/18/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class ActivityIndicatorView: UIView {
    @IBOutlet fileprivate var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
    }
}
