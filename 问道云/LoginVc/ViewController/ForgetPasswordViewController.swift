//
//  ForgetPasswordViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit

class ForgetPasswordViewController: WDBaseViewController {
    
    var phoneStr: String = ""
    
    var codeTime = 60
    
    var codeTimer: Timer!
    
    lazy var forgetView: ForgetPasswordView = {
        let forgetView = ForgetPasswordView()
        return forgetView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(forgetView)
        forgetView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        forgetView.phoneTx.text = phoneStr
        
        forgetView.sendCodeBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.getCodeInfo()
        }).disposed(by: disposeBag)
        
        forgetView.compBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.submitPasswordInfo()
        }).disposed(by: disposeBag)
        
        tapClick()
        
    }
    
}

extension ForgetPasswordViewController {
    
    func tapClick() {
        self.forgetView.backBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    func getCodeInfo() {
        let man = RequestManager()
        let dict = ["phone": self.forgetView.phoneTx.text ?? ""]
        man.requestAPI(params: dict, pageUrl: get_code, method: .post) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                ToastViewConfig.showToast(message: success.msg ?? "")
                forgetView.sendCodeBtn.isEnabled = false
                codeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
                break
            case .failure(_):
                break
            }
        }
    }
    
    @objc func updateTime() {
        if codeTime > 0 {
            codeTime -= 1
            self.forgetView.sendCodeBtn.setTitle("(\(self.codeTime)s后重新获取)", for: .normal)
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        codeTimer.invalidate()
        self.forgetView.sendCodeBtn.isEnabled = true
        self.forgetView.sendCodeBtn.setTitle("Resend", for: .normal)
        codeTime = 60
    }
    
    func submitPasswordInfo() {
        let man = RequestManager()
        let dict = ["phone": self.forgetView.phoneTx.text ?? "",
                    "code": self.forgetView.codeTx.text ?? "",
                    "password": self.forgetView.passTx.text ?? ""]
        man.requestAPI(params: dict, pageUrl: rest_password, method: .post) { [weak self] result in
            switch result {
            case .success(let success):
                ToastViewConfig.showToast(message: success.msg ?? "")
                self?.navigationController?.popViewController(animated: true)
                break
            case .failure(_):
                break
            }
        }
    }
}
