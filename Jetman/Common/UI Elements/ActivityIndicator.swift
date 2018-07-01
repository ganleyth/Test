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
    
    func endActivityAnimation(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { [weak self] in
            guard let this = self else { return }
            this.alpha = 0
        }) { (_) in
            completion?()
        }
    }
}
