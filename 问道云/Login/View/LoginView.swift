//
//  LoginView.swift
//  问道云
//
//  Created by Andrew on 2024/12/3.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LoginView: BaseView {
    
    var block1: (() -> Void)?
    var block2: (() -> Void)?
    
    private let isAgreeBinder: BehaviorRelay<Bool> = .init(value: false)
    
    lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "cancelImage"), for: .normal)
        return backBtn
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "launchlogo")
        return ctImageView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "查风险 用问道云"
        mlabel.textColor = UIColor.init(cssStr: "#666666")
        mlabel.textAlignment = .center
        mlabel.font = .regularFontOfSize(size: 14)
        return mlabel
    }()
    
    lazy var numlabel: UILabel = {
        let numlabel = UILabel()
        numlabel.text = "+86"
        numlabel.textColor = UIColor.init(cssStr: "#27344B")
        numlabel.textAlignment = .left
        numlabel.font = .mediumFontOfSize(size: 14)
        return numlabel
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
        lineView.backgroundColor = .init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton(type: .custom)
        clickBtn.setImage(UIImage(named: "control_sel"), for: .selected)
        clickBtn.setImage(UIImage(named: "Control_nor"), for: .normal)
        return clickBtn
    }()
    
    lazy var yinsiLabel: UILabel = {
        let fullText = "我已阅读并同意《问道云用户协议》和《问道云隐私政策》"
        let linkText1 = "《问道云用户协议》"
        let linkText2 = "《问道云隐私政策》"
        let attributedString = NSMutableAttributedString(string: fullText)
        let range1 = (fullText as NSString).range(of: linkText1)
        let range2 = (fullText as NSString).range(of: linkText2)
        let linkColor = UIColor.init(cssStr: "#547AFF")
        let yinsiLabel = UILabel()
        yinsiLabel.isUserInteractionEnabled = true
        yinsiLabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        yinsiLabel.font = .regularFontOfSize(size: 12)
        attributedString.addAttributes([.foregroundColor: linkColor!], range: range1)
        attributedString.addAttributes([.foregroundColor: linkColor!], range: range2)
        yinsiLabel.attributedText = attributedString
        return yinsiLabel
    }()
    
    lazy var sendBtn: UIButton = {
        let sendBtn = UIButton(type: .custom)
        sendBtn.setTitle("获取验证码", for: .normal)
        sendBtn.layer.cornerRadius = 4
        sendBtn.isEnabled = false
        sendBtn.backgroundColor = UIColor.init(cssStr: "#D0D4DA")
        sendBtn.titleLabel?.font = .regularFontOfSize(size: 18)
        sendBtn.setTitleColor(UIColor.init(cssStr: "#FFFFFF"), for: .normal)
        return sendBtn
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setTitle("一键登录", for: .normal)
        oneBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        oneBtn.titleLabel?.font = .regularFontOfSize(size: 13)
        oneBtn.backgroundColor = .white
        oneBtn.layer.cornerRadius = 18
        oneBtn.layer.borderWidth = 0.5
        oneBtn.layer.masksToBounds = true
        oneBtn.layer.borderColor = UIColor.init(cssStr: "#CCCCCC")?.cgColor
        return oneBtn
    }()
    
    lazy var mimaBtn: UIButton = {
        let mimaBtn = UIButton(type: .custom)
        mimaBtn.setTitle("密码登录", for: .normal)
        mimaBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        mimaBtn.titleLabel?.font = .regularFontOfSize(size: 13)
        mimaBtn.backgroundColor = .white
        mimaBtn.layer.masksToBounds = true
        mimaBtn.layer.cornerRadius = 18
        mimaBtn.layer.borderWidth = 0.5
        mimaBtn.layer.borderColor = UIColor.init(cssStr: "#CCCCCC")?.cgColor
        return mimaBtn
    }()
    
    lazy var weiBtn: UIButton = {
        let weiBtn = UIButton(type: .custom)
        weiBtn.setImage(UIImage(named: "wechatlogin"), for: .normal)
        weiBtn.adjustsImageWhenHighlighted = false
        return weiBtn
    }()
    
    lazy var footView: LoginFootView = {
        let footView = LoginFootView()
        return footView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backBtn)
        addSubview(ctImageView)
        addSubview(mlabel)
        addSubview(numlabel)
        addSubview(phoneTx)
        addSubview(lineView)
        addSubview(clickBtn)
        addSubview(yinsiLabel)
        addSubview(sendBtn)
        addSubview(oneBtn)
        addSubview(mimaBtn)
        addSubview(weiBtn)
        addSubview(footView)
        
        backBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(StatusHeightManager.statusBarHeight + 2)
            make.left.equalToSuperview().offset(8.5)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        ctImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 53, height: 53))
            make.top.equalTo(backBtn.snp.bottom).offset(23.5)
        }
        mlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(ctImageView.snp.bottom).offset(6)
            make.height.equalTo(20)
        }
        numlabel.snp.makeConstraints { make in
            make.top.equalTo(mlabel.snp.bottom).offset(36.5)
            make.left.equalToSuperview().offset(29.5)
            make.height.equalTo(17)
            make.width.equalTo(34)
        }
        phoneTx.snp.makeConstraints { make in
            make.left.equalTo(numlabel.snp.right).offset(12)
            make.centerY.equalTo(numlabel.snp.centerY)
            make.height.equalTo(22)
            make.right.equalToSuperview().offset(-30)
        }
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalTo(numlabel.snp.left)
            make.top.equalTo(phoneTx.snp.bottom).offset(11)
            make.height.equalTo(0.5)
        }
        clickBtn.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(17.5)
            make.left.equalToSuperview().offset(29)
            make.size.equalTo(CGSize(width: 12, height: 12))
        }
        yinsiLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(15.5)
            make.left.equalTo(clickBtn.snp.right).offset(6)
            make.right.equalToSuperview().offset(-20)
        }
        sendBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.top.equalTo(yinsiLabel.snp.bottom).offset(32.5)
            make.left.equalToSuperview().offset(30)
        }
        oneBtn.snp.makeConstraints { make in
            make.top.equalTo(sendBtn.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(30)
            make.size.equalTo(CGSize(width: 74, height: 36))
        }
        mimaBtn.snp.makeConstraints { make in
            make.top.equalTo(sendBtn.snp.bottom).offset(32)
            make.left.equalTo(oneBtn.snp.right).offset(14)
            make.size.equalTo(CGSize(width: 74, height: 36))
        }
        weiBtn.snp.makeConstraints { make in
            make.top.equalTo(sendBtn.snp.bottom).offset(32)
            make.right.equalToSuperview().offset(-30)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        footView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(51.5)
        }
        yinsiLabel.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] gesture in
                guard let self = self else { return }
                let text = yinsiLabel.text ?? ""
                let range1 = (text as NSString).range(of: "《问道云用户协议》")
                let range2 = (text as NSString).range(of: "《问道云隐私政策》")
                if gesture.didTapAttributedTextInLabel(label: yinsiLabel, inRange: range1) {
                    self.block1?()
                    // 这里可以打开用户协议的链接
                } else if gesture.didTapAttributedTextInLabel(label: yinsiLabel, inRange: range2) {
                    self.block2?()
                    // 这里可以打开隐私政策的链接
                }
            }).disposed(by: disposeBag)
        clickTap()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LoginView {
    
    func clickTap() {
        
        isAgreeBinder
            .bind(to: clickBtn.rx.isSelected)
            .disposed(by: disposeBag)
        
        clickBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.clickBtn.isSelected.toggle()
            let bool = !isAgreeBinder.value
            if bool {
                self.sendBtn.isEnabled = true
                self.sendBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")
            }else {
                self.sendBtn.isEnabled = false
                self.sendBtn.backgroundColor = UIColor.init(cssStr: "#D0D4DA")
            }
            isAgreeBinder.accept(bool)
        }).disposed(by: disposeBag)
        
        phoneTx.rx.text
            .orEmpty
            .map { text in
                let limitedText = String(text.prefix(11))
                return (limitedText, limitedText.count >= 11)
            }
            .distinctUntilChanged { $0.0 == $1.0 }
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (text, isExceeded) in
                guard let self = self else { return }
                self.phoneTx.text = text
                if isExceeded {
                    self.phoneTx.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
        
        phoneTx.rx.controlEvent(.editingChanged)
            .withLatestFrom(phoneTx.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if text.count > 11 {
                    self.phoneTx.text = String(text.prefix(11))
                }
            })
            .disposed(by: disposeBag)
        
    }
}

class LoginFootView: UIView {
    
    lazy var diView: UIView = {
        let diView = UIView()
        diView.backgroundColor = UIColor.init(cssStr: "#F8F8F8")
        diView.layer.shadowColor = UIColor.init(cssStr: "#CDCDCD")?.cgColor
        diView.layer.shadowOffset = CGSize(width: 0, height: -0.5)
        diView.layer.shadowOpacity = 1
        diView.layer.shadowRadius = 0.5
        return diView
    }()
    
    lazy var dbImageView: UIImageView = {
        let dbImageView = UIImageView()
        dbImageView.image = UIImage(named: "launchlogo")
        return dbImageView
    }()
    
    lazy var tlabel: UILabel = {
        let tlabel = UILabel()
        tlabel.textAlignment = .left
        tlabel.font = .mediumFontOfSize(size: 10)
        tlabel.textColor = UIColor.init(cssStr: "#666666")
        tlabel.numberOfLines = 0
        tlabel.text = "问道云基于公开信息分析生成，仅供参考，并不代表问道云任何暗示之观点或保证。"
        return tlabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(diView)
        diView.addSubview(dbImageView)
        diView.addSubview(tlabel)
        
        diView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        dbImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(9.5)
            make.left.equalToSuperview().offset(14)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        tlabel.snp.makeConstraints { make in
            make.centerY.equalTo(dbImageView.snp.centerY)
            make.right.equalToSuperview().offset(-12)
            make.left.equalTo(dbImageView.snp.right).offset(16.5)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
