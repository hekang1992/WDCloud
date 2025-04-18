//
//  BindPhoneViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/4.
//  微信绑定手机号

import UIKit

class BindPhoneViewController: WDBaseViewController {
    
    var wechatopenid: String = ""
    
    var codeTime = 60
    
    var codeTimer: Timer!
    
    lazy var bindView: BindPhoneView = {
        let bindView = BindPhoneView()
        return bindView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(bindView)
        bindView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bindView.sendCodeBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.getCodeInfo()
        }).disposed(by: disposeBag)
        
        bindView.compBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.bindPhone()
        }).disposed(by: disposeBag)
        
        bindView.backBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
    }
    
}

extension BindPhoneViewController {
    
    @objc func updateTime() {
        if codeTime > 0 {
            codeTime -= 1
            self.bindView.sendCodeBtn.setTitle("(\(self.codeTime)s后重新获取)", for: .normal)
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        codeTimer.invalidate()
        self.bindView.sendCodeBtn.isEnabled = true
        self.bindView.sendCodeBtn.setTitle("Resend", for: .normal)
        codeTime = 60
    }
    
}

/** 网络数据请求 */
extension BindPhoneViewController {
    
    //绑定手机号
    func bindPhone() {
        let phone = self.bindView.phoneTx.text ?? ""
        let code = self.bindView.codeTx.text ?? ""
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["code": code,
                    "phone": phone,
                    "wechatopenid": wechatopenid]
        man.requestAPI(params: dict,
                       pageUrl: "/auth/wechatBinding",
                       method: .post) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if success.code == 200 {
                    guard let model = success.data else { return }
                    let phone = model.userinfo?.userinfo?.sysUser?.phonenumber ?? ""
                    let token = model.userinfo?.access_token ?? ""
                    let customernumber = model.userinfo?.customernumber ?? ""
                    let userID = model.userinfo?.userid ?? ""
                    WDLoginConfig.saveLoginInfo(phone, token, customernumber, userID)
                    self.view.endEditing(true)
                    NotificationCenter.default.post(name: NSNotification.Name(ROOT_VC), object: nil)
                    ToastViewConfig.showToast(message: "登录成功")
                }
                ViewHud.hideLoadView()
                break
            case .failure(_):
                ViewHud.hideLoadView()
                break
            }
        }
    }
    
    //获取验证码
    func getCodeInfo() {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["phone": self.bindView.phoneTx.text ?? "", "sendType": "4"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/messageVerification/sendcode",
                       method: .post) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                ToastViewConfig.showToast(message: success.msg ?? "")
                bindView.sendCodeBtn.isEnabled = false
                codeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
                ViewHud.hideLoadView()
                break
            case .failure(_):
                ViewHud.hideLoadView()
                break
            }
        }
    }
    
}
