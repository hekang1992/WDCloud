//
//  SettingViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/13.
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
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(StatusHeightManager.navigationBarHeight)
        }
        headView.backBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
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
            .subscribe(onNext: {_ in
                ToastViewConfig.showToast(message: "账号管理")
            }).disposed(by: disposeBag)
        
        settingView.twoListView.bgView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: {_ in
                ToastViewConfig.showToast(message: "消息推送")
            }).disposed(by: disposeBag)
        
        settingView.threeListView.bgView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                ShowAlertManager.showAlert(title: "提示", message: "是否确认清除缓存?", confirmAction: {
                    GetCacheConfig.clearCache()
                    ViewHud.addLoadView()
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
            .subscribe(onNext: {_ in
                ToastViewConfig.showToast(message: "第三方")
            }).disposed(by: disposeBag)
        
        settingView.sixListView.bgView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.pushWebPage(from: information_collection)
            }).disposed(by: disposeBag)
        
        //用户协议
        settingView.sevListView.bgView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.pushWebPage(from: agreement_url)
            }).disposed(by: disposeBag)
        
        //隐私协议
        settingView.eigListView.bgView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.pushWebPage(from: privacy_url)
            }).disposed(by: disposeBag)
        
        //会员协议
        settingView.nineListView.bgView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.pushWebPage(from: membership_agreement)
            }).disposed(by: disposeBag)
        
        settingView.tenListView.bgView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: {_ in
                ToastViewConfig.showToast(message: "权限设置")
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
                ToastViewConfig.showToast(message: "退出账号")
            }).disposed(by: disposeBag)
    }
    
}
