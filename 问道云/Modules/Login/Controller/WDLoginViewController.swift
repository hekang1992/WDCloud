//
//  WDLoginViewController.swift
//  问道云
//
//  Created by Andrew on 2024/12/3.
//

import UIKit

class WDLoginViewController: WDBaseViewController {
    
    lazy var loginView: LoginView = {
        let loginView = LoginView()
        return loginView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loginView.backBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.loginView.phoneTx.resignFirstResponder()
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        loginView.mimaBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.tapClick()
        }).disposed(by: disposeBag)
        
        //获取验证码
        loginView.sendBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.getCodeInfo()
            self?.loginView.sendBtn.isEnabled = false
        }).disposed(by: disposeBag)
        
        loginView.block1 = { [weak self] in
            self?.pushWebPage(from: base_url + agreement_url)
        }
        
        loginView.block2 = { [weak self] in
            self?.pushWebPage(from: base_url + privacy_url)
        }
        loginView.weiBtn.isHidden = !WXApi.isWXAppInstalled()
        //微信登陆
        loginView.weiBtn.rx.tap.subscribe(onNext: { [weak self] in
            let req = SendAuthReq()
            req.scope = "snsapi_userinfo"
            req.state = GetIDFVConfig.getIDFV()
            WXApi.send(req) { result in
                print("微信result:\(result)")
            }
            self?.loginView.phoneTx.resignFirstResponder()
        }).disposed(by: disposeBag)
        
        //一键登录
        loginView.oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.oneLogin()
        }).disposed(by: disposeBag)
        
        DispatchQueue.main.async {
            self.loginView.phoneTx.becomeFirstResponder()
        }
    }
    
}

extension WDLoginViewController {
    
    func tapClick() {
        //密码登录
        let passwordVc = PasswordLoginViewController()
        passwordVc.phoneStr = self.loginView.phoneTx.text ?? ""
        self.navigationController?.pushViewController(passwordVc, animated: true)
    }
    
    func pushCodeVc() {
        let codeVc = GetCodeViewController()
        codeVc.phoneStr = self.loginView.phoneTx.text ?? ""
        self.navigationController?.pushViewController(codeVc, animated: true)
    }
    
}

/** 网络数据请求 */
extension WDLoginViewController {
    
    //获取验证码
    func getCodeInfo() {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["phone": self.loginView.phoneTx.text ?? "",
                    "sendType": "1"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/messageVerification/sendcode",
                       method: .post) { [weak self] result in
            ViewHud.hideLoadView()
            self?.loginView.sendBtn.isEnabled = true
            switch result {
            case .success(let success):
                if success.code == 200 {
                    self?.pushCodeVc()
                    ToastViewConfig.showToast(message: success.msg ?? "")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    private func oneLogin() {
        //        let manager = NTESQuickLoginManager.sharedInstance()
        //        manager.register(withBusinessID: "5467cd077ec5425c8779ef27b682bb8e")
        //        //是否支持一键登录
        //        let isOneLogin = manager.shouldQuickLogin()
        //        if !isOneLogin {
        //            ToastViewConfig.showToast(message: "您的设备不支持一键登录功能")
        //        }else {
        //            self.oneTouchLoginInfo(from: manager)
        //        }
    }
    
    //    private func oneTouchLoginInfo(from manager: NTESQuickLoginManager) {
    //        manager.getPhoneNumberCompletion { resultDic in
    //            if let boolNum = resultDic["success"] as? NSNumber, boolNum.boolValue {
    //                let securityPhone = resultDic["securityPhone"]
    //                print("securityPhone====\(securityPhone ?? "")")
    //            } else {
    //                // 预取号失败，建议后续直接走降级方案（例如短信）
    //            }
    //        }
    //        
    //    }
    
}


