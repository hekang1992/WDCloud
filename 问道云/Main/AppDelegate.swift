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
    
    lazy var tabBarVc: WDTabBarController = {
        let tabBarVc = WDTabBarController()
        return tabBarVc
    }()
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        keyBordManager()
        rootVcPush()
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        window?.rootViewController = WDNavigationController(rootViewController: tabBarVc)
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
    
    func rootVcPush() {
        NotificationCenter.default.addObserver(self, selector: #selector(setUpRootVc(_ :)), name: NSNotification.Name(ROOT_VC), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goRiskVc(_ :)), name: NSNotification.Name(RISK_VC), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goDiliVc(_ :)), name: NSNotification.Name(DILI_VC), object: nil)
    }
    
    @objc func setUpRootVc(_ notification: Notification) {
        window?.rootViewController = WDNavigationController(rootViewController: tabBarVc)
    }
    
    @objc func goRiskVc(_ notification: Notification) {
        tabBarVc.selectedIndex = 1
        window?.rootViewController = WDNavigationController(rootViewController: tabBarVc)
    }
    
    @objc func goDiliVc(_ notification: Notification) {
        tabBarVc.selectedIndex = 2
        window?.rootViewController = WDNavigationController(rootViewController: tabBarVc)
    }
    
}
