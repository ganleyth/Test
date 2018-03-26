//
//  UIViewController+Helpers.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/25/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentInfoAlertWith(title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(dismissAction)
        
        present(alert, animated: true, completion: nil)
    }
}
