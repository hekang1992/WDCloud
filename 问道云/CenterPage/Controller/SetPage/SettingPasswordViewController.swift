//
//  SettingPasswordViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/13.
//  设置密码页面

import UIKit
import RxSwift

class SettingPasswordViewController: WDBaseViewController {
    
    var codeTime = 60
    
    var codeTimer: Timer!
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "密码设置"
        return headView
    }()
    
    lazy var phonelabel: UILabel = {
        let phonelabel = UILabel()
        phonelabel.textColor = UIColor.init(cssStr: "#333333")
        phonelabel.textAlignment = .left
        phonelabel.font = .mediumFontOfSize(size: 14)
        let phone = GetPhoneNumberManager.getPhoneNum()
        phonelabel.text = phone
        return phonelabel
    }()
    
    lazy var codeBtn: UIButton = {
        let codeBtn = UIButton(type: .custom)
        codeBtn.setTitleColor(UIColor.init(cssStr: "#307CFF"), for: .normal)
        codeBtn.setTitle("获取验证码", for: .normal)
        codeBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        codeBtn.contentHorizontalAlignment = .right
        return codeBtn
    }()
    
    lazy var codeTx: UITextField = {
        let codeTx = UITextField()
        codeTx.keyboardType = .numberPad
        let attrString = NSMutableAttributedString(string: "请输入验证码", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
            .font: UIFont.regularFontOfSize(size: 14)
        ])
        codeTx.attributedPlaceholder = attrString
        codeTx.font = .regularFontOfSize(size: 14)
        codeTx.textColor = UIColor.init(cssStr: "#333333")
        return codeTx
    }()
    
    lazy var passoneTx: UITextField = {
        let passoneTx = UITextField()
        passoneTx.isSecureTextEntry = true
        passoneTx.keyboardType = .default
        let attrString = NSMutableAttributedString(string: "请输入新密码", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
            .font: UIFont.regularFontOfSize(size: 14)
        ])
        passoneTx.attributedPlaceholder = attrString
        passoneTx.font = .regularFontOfSize(size: 14)
        passoneTx.textColor = UIColor.init(cssStr: "#333333")
        return passoneTx
    }()
    
    lazy var passtwoTx: UITextField = {
        let passtwoTx = UITextField()
        passtwoTx.keyboardType = .default
        let attrString = NSMutableAttributedString(string: "请再次输入密码", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
            .font: UIFont.regularFontOfSize(size: 14)
        ])
        passtwoTx.attributedPlaceholder = attrString
        passtwoTx.font = .regularFontOfSize(size: 14)
        passtwoTx.textColor = UIColor.init(cssStr: "#333333")
        return passtwoTx
    }()
    
    lazy var eyeBtn: UIButton = {
        let eyeBtn = UIButton(type: .custom)
        eyeBtn.setImage(UIImage(named: "closeeye"), for: .normal)
        eyeBtn.setImage(UIImage(named: "openeye"), for: .selected)
        return eyeBtn
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        sureBtn.setTitleColor(.white, for: .normal)
        sureBtn.setTitle("完成", for: .normal)
        sureBtn.backgroundColor = UIColor.init(cssStr: "#307CFF")
        sureBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        sureBtn.layer.cornerRadius = 3
        return sureBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        
        let bgView = UIView()
        bgView.backgroundColor = .white
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(6)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        bgView.addSubview(phonelabel)
        phonelabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(26)
            make.height.equalTo(20)
        }
        bgView.addSubview(codeBtn)
        codeBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-19)
            make.size.equalTo(CGSize(width: 115, height: 20))
        }
        
        let bgView1 = UIView()
        bgView1.backgroundColor = .white
        view.addSubview(bgView1)
        bgView1.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom).offset(0.5)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        bgView1.addSubview(codeTx)
        codeTx.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26)
            make.height.equalTo(45)
            make.right.equalToSuperview()
        }
        
        
        let bgView2 = UIView()
        bgView2.backgroundColor = .white
        view.addSubview(bgView2)
        bgView2.snp.makeConstraints { make in
            make.top.equalTo(bgView1.snp.bottom).offset(6)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        bgView2.addSubview(passoneTx)
        passoneTx.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26)
            make.height.equalTo(45)
            make.right.equalToSuperview()
        }
        bgView2.addSubview(eyeBtn)
        eyeBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 18, height: 18))
            make.right.equalToSuperview().offset(-19)
        }
        
        let bgView3 = UIView()
        bgView3.backgroundColor = .white
        view.addSubview(bgView3)
        bgView3.snp.makeConstraints { make in
            make.top.equalTo(bgView2.snp.bottom).offset(0.5)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        bgView3.addSubview(passtwoTx)
        passtwoTx.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26)
            make.height.equalTo(45)
            make.right.equalToSuperview()
        }
        
        let desclabel = UILabel()
        desclabel.text = "*密码为8-20位字母/数字/字符（除空格），至少两种组合"
        desclabel.textColor = UIColor.init(cssStr: "#307CFF")
        desclabel.textAlignment = .center
        desclabel.font = .regularFontOfSize(size: 11)
        view.addSubview(desclabel)
        desclabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalTo(bgView3.snp.bottom).offset(9)
        }
        
        view.addSubview(sureBtn)
        sureBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-96)
            make.size.equalTo(CGSize(width: 285, height: 40))
        }
        
        //验证码
        codeTx.rx.text
            .orEmpty
            .map { text in
                let limitedText = String(text.prefix(6))
                return (limitedText, limitedText.count >= 6)
            }
            .distinctUntilChanged { $0.0 == $1.0 }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (text, isExceeded) in
                guard let self = self else { return }
                self.codeTx.text = text
                if isExceeded {
                    self.codeTx.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
        
        codeTx.rx.controlEvent(.editingChanged)
            .withLatestFrom(codeTx.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if text.count > 6 {
                    self.codeTx.text = String(text.prefix(6))
                }
            })
            .disposed(by: disposeBag)
        
        //闭眼
        eyeBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.eyeBtn.isSelected.toggle()
            if let mimaTx = self?.passoneTx, let eyeBtn = self?.eyeBtn {
                mimaTx.isSecureTextEntry = !eyeBtn.isSelected
            }
        }).disposed(by: disposeBag)
        
        //密码
        passoneTx.rx.text
            .orEmpty
            .map { text in
                let limitedText = String(text.prefix(20))
                return (limitedText, limitedText.count >= 20)
            }
            .distinctUntilChanged { $0.0 == $1.0 }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (text, isExceeded) in
                guard let self = self else { return }
                self.passoneTx.text = text
                if isExceeded {
                    self.passoneTx.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
        
        passoneTx.rx.controlEvent(.editingChanged)
            .withLatestFrom(passoneTx.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if text.count > 6 {
                    self.passoneTx.text = String(text.prefix(20))
                }
            })
            .disposed(by: disposeBag)
        
        //获取验证码
        codeBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.getCode()
        }).disposed(by: disposeBag)
        
        //完成
        sureBtn.rx.tap.subscribe(onNext: { [weak self] in
            let onePass = PasswordConfig.isPasswordValid(self?.passoneTx.text ?? "")
            let twoPass = PasswordConfig.isPasswordValid(self?.passtwoTx.text ?? "")
            if onePass && twoPass {
                if onePass != twoPass {
                    ToastViewConfig.showToast(message: "密码不正确!")
                }else {
                    self?.setPasswordInfo()
                }
            }else {
                ToastViewConfig.showToast(message: "密码格式不符合!")
            }
        }).disposed(by: disposeBag)
        
    }
    
}

extension SettingPasswordViewController {
    
    //获取验证码
    func getCode() {
        let man = RequestManager()
        let dict = ["phone": self.phonelabel.text ?? ""]
        man.requestAPI(params: dict, pageUrl: get_code, method: .post) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                ToastViewConfig.showToast(message: success.msg ?? "")
                self.codeBtn.isEnabled = false
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
            self.codeBtn.setTitle("(\(self.codeTime)s后重新获取)", for: .normal)
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        codeTimer.invalidate()
        self.codeBtn.isEnabled = true
        self.codeBtn.setTitle("Resend", for: .normal)
        codeTime = 60
    }
    
    //设置密码
    func setPasswordInfo() {
        let man = RequestManager()
        let dict = ["code": self.codeTx.text ?? "",
                    "phone": self.phonelabel.text ?? "",
                    "password": self.passoneTx.text ?? ""]
        man.requestAPI(params: dict, pageUrl: "/operation/messageVerification/resetpassword", method: .post) { [weak self] result in
            switch result {
            case .success(_):
                ToastViewConfig.showToast(message: "密码设置成功!")
                self?.navigationController?.popToRootViewController(animated: true)
                break
            case .failure(_):
                break
            }
        }
    }
    
}
