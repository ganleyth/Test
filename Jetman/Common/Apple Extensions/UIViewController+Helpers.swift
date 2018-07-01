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
    
    func animateCenterPresentation(of subView: UIView, shouldShow: Bool, completion: (() -> Void)?) {
        if shouldShow {
            view.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
            subView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            subView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
        
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            subView.alpha = shouldShow ? 1 : 0
        }) { (_) in
            completion?()
        }
    }
}
