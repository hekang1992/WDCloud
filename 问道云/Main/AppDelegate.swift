//
//  AppDelegate.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var tabBarVc: WDTabBarController = {
        let tabBarVc = WDTabBarController()
        return tabBarVc
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        keyBordManager()
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        window?.rootViewController = WDNavigationController(rootViewController: WDLoginViewController())
        window?.makeKeyAndVisible()
        return true
    }

}

extension AppDelegate {
    
    private func keyBordManager() {
        let manager = IQKeyboardManager.shared
        manager.enable = true
        manager.shouldResignOnTouchOutside = true
    }
    
}
