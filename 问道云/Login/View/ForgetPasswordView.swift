//
//  ForgetPasswordView.swift
//  问道云
//
//  Created by Andrew on 2024/12/3.
//

import UIKit
import RxRelay

class ForgetPasswordView: BaseView {
    
    private let isAgreeBinder: BehaviorRelay<Bool> = .init(value: false)
    
    lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "cancelImage"), for: .normal)
        return backBtn
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .left
        descLabel.font = .mediumFontOfSize(size: 24)
        descLabel.textColor = UIColor.init(cssStr: "#27344C")
        descLabel.text = "重置密码"
        return descLabel
    }()
    
    lazy var mLabel: UILabel = {
        let mLabel = UILabel()
        mLabel.textAlignment = .left
        mLabel.font = .mediumFontOfSize(size: 14)
        mLabel.textColor = UIColor.init(cssStr: "#27344C")
        mLabel.text = "中国(+86)"
        return mLabel
    }()
    
    lazy var phoneTx: UITextField = {
        let phoneTx = UITextField()
        phoneTx.keyboardType = .numberPad
        let attrString = NSMutableAttributedString(string: "请输入手机号码", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#CECECE") as Any,
            .font: UIFont.regularFontOfSize(size: 18)
        ])
        phoneTx.attributedPlaceholder = attrString
        phoneTx.font = .regularFontOfSize(size: 18)
        phoneTx.textColor = UIColor.init(cssStr: "#27344B")
        return phoneTx
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var codeTx: UITextField = {
        let codeTx = UITextField()
        codeTx.keyboardType = .phonePad
        let attrString = NSMutableAttributedString(string: "请输入验证码", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#CECECE") as Any,
            .font: UIFont.regularFontOfSize(size: 18)
        ])
        codeTx.attributedPlaceholder = attrString
        codeTx.font = .regularFontOfSize(size: 18)
        codeTx.textColor = UIColor.init(cssStr: "#27344B")
        return codeTx
    }()
    
    lazy var lineView1: UIView = {
        let lineView1 = UIView()
        lineView1.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView1
    }()
    
    lazy var sendCodeBtn: UIButton = {
        let sendCodeBtn = UIButton(type: .custom)
        sendCodeBtn.setTitle("获取验证码", for: .normal)
        sendCodeBtn.titleLabel?.font = .regularFontOfSize(size: 13)
        sendCodeBtn.contentHorizontalAlignment = .right
        sendCodeBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
        return sendCodeBtn
    }()
    
    lazy var lineView2: UIView = {
        let lineView2 = UIView()
        lineView2.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView2
    }()
    
    lazy var eyeBtn: UIButton = {
        let eyeBtn = UIButton(type: .custom)
        eyeBtn.setImage(UIImage(named: "eye_close"), for: .normal)
        eyeBtn.setImage(UIImage(named: "eye_open"), for: .selected)
        return eyeBtn
    }()
    
    lazy var passTx: UITextField = {
        let passTx = UITextField()
        passTx.keyboardType = .default
        let attrString = NSMutableAttributedString(string: "请输入新密码", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#CECECE") as Any,
            .font: UIFont.regularFontOfSize(size: 18)
        ])
        passTx.attributedPlaceholder = attrString
        passTx.font = .regularFontOfSize(size: 18)
        passTx.textColor = UIColor.init(cssStr: "#27344B")
        passTx.isSecureTextEntry = true
        return passTx
    }()
    
    lazy var compBtn: UIButton = {
        let compBtn = UIButton(type: .custom)
        compBtn.setTitle("完成", for: .normal)
        compBtn.layer.cornerRadius = 4
        compBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")
        compBtn.titleLabel?.font = .regularFontOfSize(size: 18)
        compBtn.setTitleColor(UIColor.init(cssStr: "#FFFFFF"), for: .normal)
        return compBtn
    }()
    
    lazy var footView: LoginFootView = {
        let footView = LoginFootView()
        return footView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backBtn)
        addSubview(descLabel)
        addSubview(mLabel)
        addSubview(lineView)
        addSubview(phoneTx)
        addSubview(lineView1)
        addSubview(codeTx)
        addSubview(sendCodeBtn)
        addSubview(lineView2)
        addSubview(passTx)
        addSubview(eyeBtn)
        addSubview(compBtn)
        addSubview(footView)
        backBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(StatusHeightManager.statusBarHeight + 2)
            make.left.equalToSuperview().offset(9)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        descLabel.snp.makeConstraints { make in
            make.height.equalTo(29)
            make.top.equalTo(backBtn.snp.bottom).offset(42)
            make.left.equalToSuperview().offset(30)
        }
        mLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.height.equalTo(17)
            make.top.equalTo(descLabel.snp.bottom).offset(50)
        }
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(mLabel.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(30)
        }
        phoneTx.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.right.equalTo(lineView.snp.right)
            make.bottom.equalTo(lineView.snp.top).offset(-8.5)
            make.left.equalTo(lineView.snp.left)
        }
        lineView1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(lineView.snp.bottom).offset(58)
            make.left.equalToSuperview().offset(30)
        }
        codeTx.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalTo(lineView1.snp.top).offset(-8.5)
            make.left.equalTo(lineView1.snp.left)
        }
        sendCodeBtn.snp.makeConstraints { make in
            make.bottom.equalTo(lineView1.snp.top).offset(-10.5)
            make.right.equalTo(lineView1.snp.right)
            make.size.equalTo(CGSize(width: 115.pix(), height: 18.5))
        }
        lineView2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(lineView1.snp.bottom).offset(58)
            make.left.equalToSuperview().offset(30)
        }
        passTx.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalTo(lineView2.snp.top).offset(-8.5)
            make.left.equalTo(lineView2.snp.left)
        }
        eyeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(passTx.snp.centerY)
            make.right.equalToSuperview().offset(-31)
            make.size.equalTo(CGSize(width: 18, height: 18))
        }
        compBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.top.equalTo(lineView2.snp.bottom).offset(56.5)
            make.left.equalToSuperview().offset(30)
        }
        footView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(51.5)
        }
        
        tapClick()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ForgetPasswordView {
    
    func tapClick() {
        
        eyeBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.eyeBtn.isSelected.toggle()
            if let mimaTx = self?.passTx, let eyeBtn = self?.eyeBtn {
                mimaTx.isSecureTextEntry = !eyeBtn.isSelected
            }
        }).disposed(by: disposeBag)
        
        phoneTx.rx.text
            .orEmpty
            .map { text in
                let limitedText = String(text.prefix(11))
                return (limitedText, limitedText.count >= 11)
            }
            .distinctUntilChanged { $0.0 == $1.0 }
            .subscribe(onNext: { [weak self] (text, isExceeded) in
                guard let self = self else { return }
                self.phoneTx.text = text
                if isExceeded {
                    self.phoneTx.resignFirstResponder()
                }
            }).disposed(by: disposeBag)
        
        phoneTx.rx.controlEvent(.editingChanged)
            .withLatestFrom(phoneTx.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if text.count > 11 {
                    self.phoneTx.text = String(text.prefix(11))
                }
            }).disposed(by: disposeBag)
        
        
        codeTx.rx.text
            .orEmpty
            .map { text in
                let limitedText = String(text.prefix(6))
                return (limitedText, limitedText.count >= 6)
            }
            .distinctUntilChanged { $0.0 == $1.0 }
            .subscribe(onNext: { [weak self] (text, isExceeded) in
                guard let self = self else { return }
                self.codeTx.text = text
                if isExceeded {
                    self.codeTx.resignFirstResponder()
                }
            }).disposed(by: disposeBag)
        
        codeTx.rx.controlEvent(.editingChanged)
            .withLatestFrom(codeTx.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if text.count > 6 {
                    self.codeTx.text = String(text.prefix(6))
                }
            }).disposed(by: disposeBag)
        
        
    }
    
}

