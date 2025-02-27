//
//  WDNavigationController.swift
//  问道云
//
//  Created by Andrew on 2024/12/3.
//

import UIKit

class WDNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.isHidden = true
        self.navigationBar.isTranslucent = false
    }
    
}

extension WDNavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
}
