//
//  AppDelegate.swift
//  问道云
//
//  Created by Andrew on 2024/12/3.
//

import UIKit
import GTSDK
import DYFStore
import StoreKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    static let shared: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var isLandscape = false {
        didSet {
            if isLandscape {
                _ = self.application(UIApplication.shared, supportedInterfaceOrientationsFor: nil)
            }
        }
    }
    
    //    lazy var tabBarVc: WDTabBarController = {
    //        let tabBarVc = WDTabBarController()
    //        return tabBarVc
    //    }()
    
    var tabBarVc: WDTabBarController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        keyBordManager()
        rootVcPush()
        openWechat()
        initIAPSDK()
        initGeTuiSDK(launchOptions: launchOptions)
        window = UIWindow()
        window?.frame = UIScreen.main.bounds
        window?.rootViewController = LaunchViewController()
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
        if let resp = resp as? SendAuthResp,
           resp.state == GetIDFVConfig.getIDFV() {
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
    
    //微信登录
    private func wechatLogin(from authorizationCode: String) {
        ViewHud.addLoadView()
        let dict = ["code": authorizationCode]
        let man = RequestManager()
        man.uploadDataAPI(params: dict,
                          pageUrl: "/auth/wechatlogin",
                          method: .post) { result in
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
                        ToastViewConfig.showToast(message: "登录成功")
                        if let model = success.data {
                            let phone = model.userinfo?.userinfo?.sysUser?.phonenumber ?? ""
                            let token = model.userinfo?.access_token ?? ""
                            let customernumber = model.userinfo?.customernumber ?? ""
                            let userID = model.userinfo?.userid ?? ""
                            WDLoginConfig.saveLoginInfo(phone, token, customernumber, userID)
                        }
                        NotificationCenter.default.post(name: NSNotification.Name(ROOT_VC), object: nil)
                    }
                }
                ViewHud.hideLoadView()
                break
            case .failure(_):
                ViewHud.hideLoadView()
                break
            }
        }
    }
    
    private func openWechat() {
        WXApi.registerApp("wx24b1a40f5ff2811e", universalLink: "https://h5.wintaocloud.com/iOS/")
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
        let tabBarVc = WDTabBarController()
        self.tabBarVc = tabBarVc
        window?.rootViewController = WDNavigationController(rootViewController: tabBarVc)
    }
    
    @objc func goRiskVc(_ notification: Notification) {
        self.tabBarVc?.selectedIndex = 1
    }
    
    @objc func goDiliVc(_ notification: Notification) {
        self.tabBarVc?.selectedIndex = 2
    }
    
}

//内购相关
extension AppDelegate: DYFStoreAppStorePaymentDelegate {
    
    func didReceiveAppStorePurchaseRequest(_ queue: SKPaymentQueue, payment: SKPayment, forProduct product: SKProduct) {
    }
    
    func initIAPSDK() {
        SKIAPManager.shared.addStoreObserver()
        DYFStore.default.enableLog = true
        DYFStore.default.addPaymentTransactionObserver()
        DYFStore.default.delegate = self
    }
    
}

//推送相关
extension AppDelegate: GeTuiSdkDelegate {
    
    func initGeTuiSDK(launchOptions: [AnyHashable : Any]?) {
        // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
        GeTuiSdk.start(withAppId: kGtAppId,
                       appKey: kGtAppKey,
                       appSecret: kGtAppSecret,
                       delegate: self,
                       launchingOptions: launchOptions)
        
        GeTuiSdk.registerRemoteNotification(.init(arrayLiteral: .alert, .badge, .sound))
        GeTuiSdk.runBackgroundEnable(true)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 在前台时显示通知
        completionHandler([.badge, .sound, .list])
    }
    
    //展示APNs通知
    func geTuiSdkNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.init(arrayLiteral: .badge, .sound, .list))
    }
    
    /// 收到通知信息
    /// - Parameters:
    ///   - userInfo: apns通知内容
    ///   - center: UNUserNotificationCenter（iOS10及以上版本）
    ///   - response: UNNotificationResponse（iOS10及以上版本）
    ///   - completionHandler: 用来在后台状态下进行操作（iOS10以下版本）
    func geTuiSdkDidReceiveNotification(_ userInfo: [AnyHashable : Any], notificationCenter center: UNUserNotificationCenter?, response: UNNotificationResponse?, fetchCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)? = nil) {
        if let userInfo = response?.notification.request.content.userInfo {
            print("接受userInfo======\(userInfo)")
        }
        completionHandler?(.noData)
    }
    
    //接收到通知,可以
    func geTuiSdkDidReceiveSlience(_ userInfo: [AnyHashable : Any], fromGetui: Bool, offLine: Bool, appId: String?, taskId: String?, msgId: String?, fetchCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)? = nil) {
        print("通知userInfo======\(userInfo)")
        completionHandler?(.noData)
    }
    
    func geTuiSdkNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
    
    func geTuiSdkDidRegisterClient(_ clientId: String) {
        print("clientId=====\(clientId)")
        //更新cid信息
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber, "cid": clientId]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/operation/messageVerification/updatecid",
                       method: .post) { result in }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        GeTuiSdk.registerDeviceToken(token)
    }
    
    func geTuiSdkDidOccurError(_ error: Error) {
        
    }
    
}

extension AppDelegate {
    @objc(application:supportedInterfaceOrientationsForWindow:) func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if isLandscape {
            return .all
        } else {
            return .portrait
        }
    }
}
