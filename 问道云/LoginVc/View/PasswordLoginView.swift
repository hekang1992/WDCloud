//
//  PasswordLoginView.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit
import RxRelay
import ActiveLabel
import MBProgressHUD_WJExtension

class PasswordLoginView: BaseView {
    
    private let isAgreeBinder: BehaviorRelay<Bool> = .init(value: false)
    
    lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "cancelImage"), for: .normal)
        return backBtn
    }()
    
    lazy var eyeBtn: UIButton = {
        let eyeBtn = UIButton(type: .custom)
        eyeBtn.setImage(UIImage(named: "eye_close"), for: .normal)
        eyeBtn.setImage(UIImage(named: "eye_open"), for: .selected)
        return eyeBtn
    }()
    
    lazy var label1: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .mediumFontOfSize(size: 24)
        label.textColor = UIColor.init(cssStr: "#27344C")
        label.text = "密码登录"
        return label
    }()
    
    lazy var phoneTx: UITextField = {
        let phoneTx = UITextField()
        phoneTx.keyboardType = .numberPad
        let attrString = NSMutableAttributedString(string: "请输入手机号码", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#CECECE") as Any,
            .font: UIFont.regularFontOfSize(size: 16)
        ])
        phoneTx.attributedPlaceholder = attrString
        phoneTx.font = .regularFontOfSize(size: 16)
        phoneTx.textColor = UIColor.init(cssStr: "#27344B")
        return phoneTx
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var passTx: UITextField = {
        let passTx = UITextField()
        passTx.keyboardType = .default
        let attrString = NSMutableAttributedString(string: "请输入密码", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#CECECE") as Any,
            .font: UIFont.regularFontOfSize(size: 16)
        ])
        passTx.attributedPlaceholder = attrString
        passTx.font = .regularFontOfSize(size: 16)
        passTx.textColor = UIColor.init(cssStr: "#27344B")
        return passTx
    }()
    
    lazy var lineView1: UIView = {
        let lineView1 = UIView()
        lineView1.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView1
    }()

    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton(type: .custom)
        clickBtn.setImage(UIImage(named: "control_sel"), for: .selected)
        clickBtn.setImage(UIImage(named: "Control_nor"), for: .normal)
        return clickBtn
    }()
    
    lazy var wangjimimaBtn: UIButton = {
        let wangjimimaBtn = UIButton(type: .custom)
        wangjimimaBtn.setTitle("忘记密码", for: .normal)
        wangjimimaBtn.titleLabel?.font = .regularFontOfSize(size: 13)
        wangjimimaBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        return wangjimimaBtn
    }()
    
    lazy var yinsiLabel: ActiveLabel = {
        let yinsiLabel = ActiveLabel()
        yinsiLabel.font = .regularFontOfSize(size: 12)
        yinsiLabel.numberOfLines = 0
        yinsiLabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        yinsiLabel.text = "我已阅读并同意《问道云协议》和《问道云隐私服务政策》条款"
        let customType1 = ActiveType.custom(pattern: "\\b《问道云协议》\\b")
        let customType2 = ActiveType.custom(pattern: "\\b《问道云隐私服务政策》\\b")
        yinsiLabel.enabledTypes.append(customType1)
        yinsiLabel.enabledTypes.append(customType2)
        yinsiLabel.customColor[customType1] = UIColor.init(cssStr: "#547AFF")
        yinsiLabel.customColor[customType2] = UIColor.init(cssStr: "#547AFF")
        yinsiLabel.customSelectedColor[customType1] = UIColor.init(cssStr: "#547AFF")
        yinsiLabel.customSelectedColor[customType2] = UIColor.init(cssStr: "#547AFF")
        yinsiLabel.handleCustomTap(for: customType1) { [weak self] element in
            MBProgressHUD.wj_showPlainText("点击协议", view: nil)
        }
        yinsiLabel.handleCustomTap(for: customType2) { [weak self] element in
            MBProgressHUD.wj_showPlainText("点击政策", view: nil)
        }
        let attributedString = NSMutableAttributedString(string: yinsiLabel.text!)
        yinsiLabel.attributedText = attributedString
        return yinsiLabel
    }()
    
    lazy var sendBtn: UIButton = {
        let sendBtn = UIButton(type: .custom)
        sendBtn.setTitle("登录", for: .normal)
        sendBtn.layer.cornerRadius = 4
        sendBtn.isEnabled = false
        sendBtn.backgroundColor = UIColor.init(cssStr: "#D0D4DA")
        sendBtn.titleLabel?.font = .regularFontOfSize(size: 18)
        sendBtn.setTitleColor(UIColor.init(cssStr: "#FFFFFF"), for: .normal)
        return sendBtn
    }()
    
    lazy var footView: LoginFootView = {
        let footView = LoginFootView()
        return footView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backBtn)
        addSubview(eyeBtn)
        addSubview(label1)
        addSubview(lineView)
        addSubview(phoneTx)
        addSubview(lineView1)
        addSubview(passTx)
        addSubview(clickBtn)
        addSubview(yinsiLabel)
        addSubview(sendBtn)
        addSubview(wangjimimaBtn)
        addSubview(footView)
        backBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(StatusHeightManager.statusBarHeight + 2)
            make.left.equalToSuperview().offset(9)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        label1.snp.makeConstraints { make in
            make.height.equalTo(29)
            make.top.equalTo(backBtn.snp.bottom).offset(42)
            make.left.equalToSuperview().offset(30)
        }
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(label1.snp.bottom).offset(110)
            make.left.equalToSuperview().offset(30)
        }
        phoneTx.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.right.equalTo(lineView.snp.right)
            make.bottom.equalTo(lineView.snp.top).offset(-12)
            make.left.equalTo(lineView.snp.left)
        }
        lineView1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(lineView.snp.bottom).offset(58)
            make.left.equalToSuperview().offset(30)
        }
        wangjimimaBtn.snp.makeConstraints { make in
            make.centerY.equalTo(passTx.snp.centerY)
            make.right.equalToSuperview().offset(-30)
            make.size.equalTo(CGSize(width: 62, height: 19))
        }
        eyeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(passTx.snp.centerY)
            make.right.equalTo(wangjimimaBtn.snp.left).offset(-10)
            make.size.equalTo(CGSize(width: 18, height: 18))
        }
        passTx.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.right.equalTo(eyeBtn.snp.left).offset(-10)
            make.bottom.equalTo(lineView1.snp.top).offset(-12)
            make.left.equalTo(lineView1.snp.left)
        }
        clickBtn.snp.makeConstraints { make in
            make.top.equalTo(lineView1.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 26, height: 26))
        }
        yinsiLabel.snp.makeConstraints { make in
            make.centerY.equalTo(clickBtn.snp.centerY)
            make.left.equalTo(clickBtn.snp.right).offset(6)
            make.right.equalToSuperview().offset(-20)
        }
        sendBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.top.equalTo(yinsiLabel.snp.bottom).offset(15.5)
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

extension PasswordLoginView {
    
    func tapClick() {
        
        isAgreeBinder
            .bind(to: clickBtn.rx.isSelected)
            .disposed(by: disposeBag)
        
        clickBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.clickBtn.isSelected.toggle()
            let bool = !isAgreeBinder.value
            if bool == true {
                self.sendBtn.isEnabled = true
                self.sendBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")
            }else {
                self.sendBtn.isEnabled = false
                self.sendBtn.backgroundColor = UIColor.init(cssStr: "#D0D4DA")
            }
            isAgreeBinder.accept(bool)
        }).disposed(by: disposeBag)
        
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
        
    }
}
