//
//  SettingViewController.swift
//  问道云
//
//  Created by Andrew on 2024/12/13.
//  设置页面

import UIKit

class SettingViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "设置"
        return headView
    }()
    
    lazy var settingView: SettingView = {
        let settingView = SettingView()
        return settingView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(settingView)
        settingView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(4)
            make.left.right.bottom.equalToSuperview()
        }
        
        addClickInfo()
    }
    
    
}

extension SettingViewController {
    
    //添加点击方法
    func addClickInfo() {
        settingView.oneListView.bgView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let accountVc = AccountManagerViewController()
                self?.navigationController?.pushViewController(accountVc, animated: true)
            }).disposed(by: disposeBag)
        
        settingView.twoListView.bgView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let pushVc = MessagePushCenterViewController()
                self?.navigationController?.pushViewController(pushVc, animated: true)
            }).disposed(by: disposeBag)
        
        settingView.threeListView.bgView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                ShowAlertManager.showAlert(title: "提示", message: "是否确认清除缓存?", confirmAction: {
                    ViewHud.addLoadView()
                    GetCacheConfig.clearCache()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        ViewHud.hideLoadView()
                        ToastViewConfig.showToast(message: "清理缓存成功")
                        self?.settingView.threeListView.rightlabel.text = "0.00MB"
                    }
                })
            }).disposed(by: disposeBag)
        
        settingView.fourListView.bgView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: {_ in
                let appurl = "https://apps.apple.com/cn/app/%E9%97%AE%E9%81%93%E4%BA%91/id6505061459?l=zh-cn"
                let appStoreSearchURL = URL(string: appurl)!
                if UIApplication.shared.canOpenURL(appStoreSearchURL) {
                    UIApplication.shared.open(appStoreSearchURL, options: [:]) { success in
                        if success {
                            print("Successfully opened App Store search")
                        } else {
                            print("Failed to open App Store search")
                        }
                    }
                } else {
                    print("Cannot open App Store search URL")
                }
            }).disposed(by: disposeBag)
        
        settingView.fiveListView.bgView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let pageUrl = base_url + "/tripartite-agreement"
                self?.pushWebPage(from: pageUrl)
            }).disposed(by: disposeBag)
        
        settingView.sixListView.bgView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.pushWebPage(from: base_url + information_collection)
            }).disposed(by: disposeBag)
        
        //用户协议
        settingView.sevListView.bgView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.pushWebPage(from: base_url + agreement_url)
            }).disposed(by: disposeBag)
        
        //隐私协议
        settingView.eigListView.bgView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.pushWebPage(from: base_url + privacy_url)
            }).disposed(by: disposeBag)
        
        //会员协议
        settingView.nineListView.bgView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.pushWebPage(from: base_url + membership_agreement)
            }).disposed(by: disposeBag)
        
        settingView.tenListView.bgView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let authVc = SettingAuthorityViewController()
                self?.navigationController?.pushViewController(authVc, animated: true)
            }).disposed(by: disposeBag)
        
        //关于我们
        settingView.eleListView.bgView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self]_ in
                let aboutVc = AboutUsViewController()
                self?.navigationController?.pushViewController(aboutVc, animated: true)
            }).disposed(by: disposeBag)
        
        settingView.exitBtn
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                ShowAlertManager.showAlert(title: "提示", message: "是否退出账号?", confirmAction: {
                    self?.logout()
                })
            }).disposed(by: disposeBag)
    }
    
    //退出账号
    func logout() {
        let man = RequestManager()
        let dict = [String: Any]()
        man.requestAPI(params: dict,
                       pageUrl: "/auth/logout",
                       method: .delete) { result in
            switch result {
            case .success(_):
                WDLoginConfig.removeLoginInfo()
                ToastViewConfig.showToast(message: "退出成功")
                NotificationCenter.default.post(name: NSNotification.Name(ROOT_VC), object: nil)
                break
            case .failure(_):
                break
            }
        }
    }
    
}
