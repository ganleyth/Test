//
//  WelcomeViewEmbeddedController.swift
//  Jetman
//
//  Created by Thomas Ganley on 3/31/18.
//  Copyright © 2018 Thomas Ganley. All rights reserved.
//

import UIKit

class WelcomeViewEmbeddedController: UIViewController {
    
    func addChild(_ controller: UIViewController) {
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.view.frame = view.frame
        controller.didMove(toParentViewController: self)
    }
    
    func removeChildren() {
        childViewControllers.forEach { (childController) in
            childController.willMove(toParentViewController: nil)
            childController.removeFromParentViewController()
            childController.view.removeFromSuperview()
        }
    }
}
