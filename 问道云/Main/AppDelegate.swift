//
//  AppDelegate.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit
import DYFStore
import StoreKit
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
        rootVcPush()
        openWechat()
        initIAPSDK()
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        window?.rootViewController = WDNavigationController(rootViewController: self.tabBarVc)
        window?.makeKeyAndVisible()
        return true
    }
    
}

extension AppDelegate: WXApiDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return WXApi.handleOpenUniversalLink(userActivity, delegate: self)
    }
    
    func onReq(_ req: BaseReq) {
        
    }
    
    func onResp(_ resp: BaseResp) {
        if let resp = resp as? SendAuthResp, resp.state == GetIDFVConfig.getIDFV() {
            switch resp.errCode {
            case 0:
                if let code = resp.code {
                    wechatLogin(from: code)
                }
            case -4:
                ToastViewConfig.showToast(message: "拒绝授权")
            case -2:
                ToastViewConfig.showToast(message: "已取消")
            default:
                break
            }
        }
    }
    
    private func wechatLogin(from authorizationCode: String) {
        let dict = ["code": authorizationCode]
        let man = RequestManager()
        man.uploadDataAPI(params: dict, pageUrl: "/auth/wechatlogin", method: .post) { result in
            switch result {
            case .success(let success):
                if let model = success.data {
                    let flag = model.flag ?? ""
                    if model.flag == "0" {
                        ToastViewConfig.showToast(message: success.msg ?? "")
                        let currentVc = UIViewController.getCurrentViewController()
                        let bindVc = BindPhoneViewController()
                        bindVc.wechatopenid = model.wechatopenid ?? ""
                        currentVc.navigationController?.pushViewController(bindVc, animated: true)
                    }else if flag == "1" {
                        ToastViewConfig.showToast(message: "登录成功!")
                        if let model = success.data {
                            let phone = model.userinfo?.userinfo?.sysUser?.phonenumber ?? ""
                            let token = model.userinfo?.access_token ?? ""
                            let customernumber = model.userinfo?.customernumber ?? ""
                            WDLoginConfig.saveLoginInfo(phone, token, customernumber)
                        }
                        NotificationCenter.default.post(name: NSNotification.Name(ROOT_VC), object: nil)
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    private func openWechat() {
        WXApi.registerApp("wx24b1a40f5ff2811e", universalLink: "https://www.wintaocloud.com/iOS/")
    }
    
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
        window?.rootViewController = WDNavigationController(rootViewController: self.tabBarVc)
    }
    
    @objc func goRiskVc(_ notification: Notification) {
        self.tabBarVc.selectedIndex = 1
        
    }
    
    @objc func goDiliVc(_ notification: Notification) {
        self.tabBarVc.selectedIndex = 2
    }
    
}

//内购相关
extension AppDelegate: DYFStoreAppStorePaymentDelegate {
    
    //
    func didReceiveAppStorePurchaseRequest(_ queue: SKPaymentQueue, payment: SKPayment, forProduct product: SKProduct) {
        
    }
    
    func initIAPSDK() {
        SKIAPManager.shared.addStoreObserver()
        DYFStore.default.enableLog = true
        DYFStore.default.addPaymentTransactionObserver()
        DYFStore.default.delegate = self
    }
    
}
