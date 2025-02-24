//
//  PasswordLoginViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit

class PasswordLoginViewController: WDBaseViewController {
    
    var phoneStr: String = ""
    
    lazy var passView: PasswordLoginView = {
        let passView = PasswordLoginView()
        return passView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(passView)
        passView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        passView.backBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }).disposed(by: disposeBag)
        
        passView.phoneTx.text = self.phoneStr
        
        passView.block1 = { [weak self] in
            self?.pushWebPage(from: base_url + agreement_url)
        }
        
        passView.block2 = { [weak self] in
            self?.pushWebPage(from: base_url + privacy_url)
        }
        
        tapClick()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passView.phoneTx.becomeFirstResponder()
    }

}

extension PasswordLoginViewController {
    
    func tapClick() {
        self.passView.wangjimimaBtn.rx.tap.subscribe(onNext: { [weak self] in
            let forgetVc = ForgetPasswordViewController()
            forgetVc.phoneStr = self?.phoneStr ?? ""
            self?.navigationController?.pushViewController(forgetVc, animated: true)
        }).disposed(by: disposeBag)
        
        self.passView.loginBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.loginInfo()
        }).disposed(by: disposeBag)
    }
    
    //密码登录
    func loginInfo() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["username": self.passView.phoneTx.text ?? "",
                    "password": self.passView.passTx.text ?? ""]
        man.requestAPI(params: dict,
                       pageUrl: "/auth/customerlogin",
                       method: .post) { result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                //保存登录信息和跳转到首页
                if success.code == 200 {
                    if let model = success.data {
                        let phone = model.userinfo?.username ?? ""
                        let token = model.access_token ?? ""
                        let customernumber = model.customernumber ?? ""
                        WDLoginConfig.saveLoginInfo(phone, token, customernumber)
                    }
                    self.view.endEditing(true)
                    NotificationCenter.default.post(name: NSNotification.Name(ROOT_VC), object: nil)
                    ToastViewConfig.showToast(message: "登录成功")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
