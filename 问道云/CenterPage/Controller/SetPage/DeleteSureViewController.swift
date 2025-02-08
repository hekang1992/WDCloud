//
//  DeleteSureViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/20.
//

import UIKit

class DeleteSureViewController: WDBaseViewController {
    
    var block: (() -> Void)?
    
    var codeTime = 60
    
    var codeTimer: Timer!
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "注销账号"
        return headView
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.init(cssStr: "#FFF5E1")
        return bgView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.text = "为确保您的账号安全，请验证现有手机号码"
        descLabel.textColor = .init(cssStr: "#FF7D00")
        descLabel.textAlignment = .left
        descLabel.font = .regularFontOfSize(size: 13)
        return descLabel
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.layer.cornerRadius = 3
        nextBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")
        nextBtn.setTitle("下一步", for: .normal)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.isEnabled = false
        nextBtn.backgroundColor = .init(cssStr: "#9FA4AD")
        nextBtn.titleLabel?.font = .regularFontOfSize(size: 16)
        return nextBtn
    }()
    
    lazy var eyeBtn: UIButton = {
        let eyeBtn = UIButton(type: .custom)
        eyeBtn.setImage(UIImage(named: "Control_nor"), for: .normal)
        eyeBtn.setImage(UIImage(named: "control_sel"), for: .selected)
        return eyeBtn
    }()
    
    lazy var yinsiLabel: UILabel = {
        let yinsiLabel = UILabel()
        let fullText = "我已阅读并同意《问道云用户协议》"
        let linkText = "《问道云用户协议》"
        yinsiLabel.font = .regularFontOfSize(size: 12)
        yinsiLabel.numberOfLines = 0
        yinsiLabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        let attributedString = NSMutableAttributedString(string: fullText)
                let range = (fullText as NSString).range(of: linkText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.init(cssStr: "#547AFF"), range: range)
        yinsiLabel.attributedText = attributedString
        yinsiLabel.isUserInteractionEnabled = true
        return yinsiLabel
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F3F3F3")
        return lineView
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.text = GetPhoneNumberManager.getPhoneNum()
        numLabel.textColor = .init(cssStr: "#333333")
        numLabel.textAlignment = .left
        numLabel.font = .mediumFontOfSize(size: 14)
        return numLabel
    }()
    
    lazy var codeTx: UITextField = {
        let codeTx = UITextField()
        codeTx.keyboardType = .phonePad
        let attrString = NSMutableAttributedString(string: "请输入验证码", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#CECECE") as Any,
            .font: UIFont.regularFontOfSize(size: 14)
        ])
        codeTx.attributedPlaceholder = attrString
        codeTx.font = .mediumFontOfSize(size: 14)
        codeTx.textColor = UIColor.init(cssStr: "#27344B")
        return codeTx
    }()
    
    lazy var sendCodeBtn: UIButton = {
        let sendCodeBtn = UIButton(type: .custom)
        sendCodeBtn.setTitle("获取验证码", for: .normal)
        sendCodeBtn.titleLabel?.font = .regularFontOfSize(size: 13)
        sendCodeBtn.contentHorizontalAlignment = .right
        sendCodeBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
        sendCodeBtn.contentHorizontalAlignment = .right
        return sendCodeBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        bgView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(30)
        }
        
        view.addSubview(whiteView)
        whiteView.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(90)
        }
        
        whiteView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        whiteView.addSubview(numLabel)
        numLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26)
            make.height.equalTo(22)
            make.top.equalToSuperview().offset(12.5)
        }
        
        whiteView.addSubview(codeTx)
        codeTx.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(26)
            make.height.equalTo(22)
            make.width.equalTo(160)
            make.bottom.equalToSuperview().offset(-12.5)
        }
        
        whiteView.addSubview(sendCodeBtn)
        sendCodeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(codeTx.snp.centerY)
            make.right.equalToSuperview().offset(-30)
            make.size.equalTo(CGSize(width: 115, height: 18.5))
        }
        
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-60)
            make.left.equalToSuperview().offset(25)
        }
        
        view.addSubview(eyeBtn)
        eyeBtn.snp.makeConstraints { make in
            make.bottom.equalTo(nextBtn.snp.top).offset(-16)
            make.left.equalTo(nextBtn.snp.left)
            make.size.equalTo(CGSize(width: 12, height: 12))
        }
        
        view.addSubview(yinsiLabel)
        yinsiLabel.snp.makeConstraints { make in
            make.centerY.equalTo(eyeBtn.snp.centerY)
            make.height.equalTo(15)
            make.left.equalTo(eyeBtn.snp.right).offset(5)
        }
        
        eyeBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            eyeBtn.isSelected.toggle()
            nextBtn.isEnabled = eyeBtn.isSelected
            nextBtn.backgroundColor = eyeBtn.isSelected ? UIColor.init(cssStr: "#547AFF") : UIColor.init(cssStr: "#9FA4AD")
        }).disposed(by: disposeBag)
        
        self.block = { [weak self] in
            self?.pushWebPage(from: base_url + agreement_url)
        }
        
        sendCodeBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.getCodeInfo()
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
        
        
        nextBtn.rx.tap.subscribe(onNext: { [weak self] in
            ShowAlertManager.showAlert(title: "注销提醒", message: "注销后，当前账号将不可登录，用户信息、会员权益、认证信息、关注监控、下载记录、付款记录等信息会同步删除且不可找回，请确认是否注销。", confirmAction: {
                self?.deleteAccount()
            })
        }).disposed(by: disposeBag)
        
        yinsiLabel.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
            self?.block?()
        }).disposed(by: disposeBag)
        
    }
    
}

extension DeleteSureViewController {
    
    
    func getCodeInfo() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["phone": self.numLabel.text ?? ""]
        man.requestAPI(params: dict,
                       pageUrl: get_code,
                       method: .post) { [weak self] result in
            ViewHud.hideLoadView()
            guard let self = self else { return }
            switch result {
            case .success(let success):
                ToastViewConfig.showToast(message: success.msg ?? "")
                sendCodeBtn.isEnabled = false
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
            self.sendCodeBtn.setTitle("(\(self.codeTime)s后重新获取)", for: .normal)
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        codeTimer.invalidate()
        self.sendCodeBtn.isEnabled = true
        self.sendCodeBtn.setTitle("Resend", for: .normal)
        codeTime = 60
    }

    //删除账号
    func deleteAccount() {
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let phone = self.numLabel.text ?? ""
        let code = self.codeTx.text ?? ""
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["customernumber": customernumber,
                    "phone": phone,
                    "code": code,
                    "state": "2"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/customerinfo/updatecustomerInfoisCustomertype",
                       method: .post) { result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    WDLoginConfig.removeLoginInfo()
                    NotificationCenter.default.post(name: NSNotification.Name(ROOT_VC), object: nil)
                }
                ToastViewConfig.showToast(message: success.msg ?? "")
                break
            case .failure(_):
                break
            }
        }
    }
    
}
