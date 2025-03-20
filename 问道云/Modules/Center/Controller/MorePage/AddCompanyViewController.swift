//
//  AddCompanyViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/17.
//

import UIKit

class AddCompanyViewController: WDBaseViewController {
    
    var isClickLeft: Bool = true
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "添加企业"
        return headView
    }()
    
    lazy var oneView: UIView = {
        let oneView = UIView()
        oneView.backgroundColor = .white
        return oneView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "tianjiaaddcompany")
        return ctImageView
    }()
    
    lazy var twoView: UIView = {
        let twoView = UIView()
        twoView.backgroundColor = .white
        return twoView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "添加方式"
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .mediumFontOfSize(size: 14)
        return nameLabel
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setImage(UIImage(named: "cycleselectedimage"), for: .normal)
        oneBtn.setTitle("统一社会信用代码", for: .normal)
        oneBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        oneBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setImage(UIImage(named: "Control_nor"), for: .normal)
        twoBtn.setTitle("企业名称", for: .normal)
        twoBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        twoBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        return twoBtn
    }()
    
    lazy var submitBtn: UIButton = {
        let submitBtn = UIButton(type: .custom)
        submitBtn.setTitle("提交", for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.layer.cornerRadius = 3
        submitBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        submitBtn.backgroundColor = .init(cssStr: "#547AFF")
        return submitBtn
    }()
   
    lazy var threeView: UIView = {
        let threeView = UIView()
        threeView.backgroundColor = .white
        return threeView
    }()
    
    lazy var fourView: UIView = {
        let fourView = UIView()
        fourView.isHidden = true
        fourView.backgroundColor = .white
        return fourView
    }()
    
    lazy var threeLabel: UILabel = {
        let threeLabel = UILabel()
        let title = "* 统一社会信用代码"
        threeLabel.textColor = .init(cssStr: "#333333")
        threeLabel.font = .mediumFontOfSize(size: 14)
        threeLabel.attributedText = GetRedStrConfig.getRedStr(from: "*", fullText: title, colorStr: "#F55B5B")
        threeLabel.textAlignment = .left
        return threeLabel
    }()
    
    lazy var threeTx: UITextField = {
        let threeTx = UITextField()
        let attrString = NSMutableAttributedString(string: "请输入企业的统一社会信用代码", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
            .font: UIFont.regularFontOfSize(size: 14)
        ])
        threeTx.attributedPlaceholder = attrString
        threeTx.font = UIFont.regularFontOfSize(size: 14)
        threeTx.textColor = UIColor.init(cssStr: "#333333")
        threeTx.leftView = UIView(frame: CGRectMake(0, 0, 5, 20))
        threeTx.leftViewMode = .always
        threeTx.layer.cornerRadius = 5
        threeTx.layer.borderWidth = 1
        threeTx.layer.borderColor = UIColor.init(cssStr: "#D6D6D6")?.cgColor
        return threeTx
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        let title = "* 联系方式"
        phoneLabel.textColor = .init(cssStr: "#333333")
        phoneLabel.font = .mediumFontOfSize(size: 14)
        phoneLabel.attributedText = GetRedStrConfig.getRedStr(from: "*", fullText: title, colorStr: "#F55B5B")
        phoneLabel.textAlignment = .left
        return phoneLabel
    }()
    
    lazy var phoneTx: UITextField = {
        let phoneTx = UITextField()
        let attrString = NSMutableAttributedString(string: "请输入联系方式", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
            .font: UIFont.regularFontOfSize(size: 14)
        ])
        phoneTx.attributedPlaceholder = attrString
        phoneTx.font = UIFont.regularFontOfSize(size: 14)
        phoneTx.textColor = UIColor.init(cssStr: "#333333")
        phoneTx.leftView = UIView(frame: CGRectMake(0, 0, 5, 20))
        phoneTx.leftViewMode = .always
        phoneTx.layer.cornerRadius = 5
        phoneTx.layer.borderWidth = 1
        phoneTx.layer.borderColor = UIColor.init(cssStr: "#D6D6D6")?.cgColor
        return phoneTx
    }()
    
    lazy var cLabel: UILabel = {
        let cLabel = UILabel()
        let title = "* 企业名称"
        cLabel.textColor = .init(cssStr: "#333333")
        cLabel.font = .mediumFontOfSize(size: 14)
        cLabel.attributedText = GetRedStrConfig.getRedStr(from: "*", fullText: title, colorStr: "#F55B5B")
        cLabel.textAlignment = .left
        return cLabel
    }()
    
    lazy var cTx: UITextField = {
        let cTx = UITextField()
        let attrString = NSMutableAttributedString(string: "请输入企业名称", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
            .font: UIFont.regularFontOfSize(size: 14)
        ])
        cTx.attributedPlaceholder = attrString
        cTx.font = UIFont.regularFontOfSize(size: 14)
        cTx.textColor = UIColor.init(cssStr: "#333333")
        cTx.leftView = UIView(frame: CGRectMake(0, 0, 5, 20))
        cTx.leftViewMode = .always
        cTx.layer.cornerRadius = 5
        cTx.layer.borderWidth = 1
        cTx.layer.borderColor = UIColor.init(cssStr: "#D6D6D6")?.cgColor
        return cTx
    }()
    
    lazy var pLabel: UILabel = {
        let pLabel = UILabel()
        let title = "* 所属省份"
        pLabel.textColor = .init(cssStr: "#333333")
        pLabel.font = .mediumFontOfSize(size: 14)
        pLabel.attributedText = GetRedStrConfig.getRedStr(from: "*", fullText: title, colorStr: "#F55B5B")
        pLabel.textAlignment = .left
        return pLabel
    }()
    
    lazy var pTx: UITextField = {
        let pTx = UITextField()
        let attrString = NSMutableAttributedString(string: "请输入企业所在省份", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
            .font: UIFont.regularFontOfSize(size: 14)
        ])
        pTx.attributedPlaceholder = attrString
        pTx.font = UIFont.regularFontOfSize(size: 14)
        pTx.textColor = UIColor.init(cssStr: "#333333")
        pTx.leftView = UIView(frame: CGRectMake(0, 0, 5, 20))
        pTx.leftViewMode = .always
        pTx.layer.cornerRadius = 5
        pTx.layer.borderWidth = 1
        pTx.layer.borderColor = UIColor.init(cssStr: "#D6D6D6")?.cgColor
        return pTx
    }()
    
    lazy var nuLabel: UILabel = {
        let nuLabel = UILabel()
        let title = "* 联系方式"
        nuLabel.textColor = .init(cssStr: "#333333")
        nuLabel.font = .mediumFontOfSize(size: 14)
        nuLabel.attributedText = GetRedStrConfig.getRedStr(from: "*", fullText: title, colorStr: "#F55B5B")
        nuLabel.textAlignment = .left
        return nuLabel
    }()
    
    lazy var nuTx: UITextField = {
        let nuTx = UITextField()
        let attrString = NSMutableAttributedString(string: "请输入联系方式", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
            .font: UIFont.regularFontOfSize(size: 14)
        ])
        nuTx.attributedPlaceholder = attrString
        nuTx.font = UIFont.regularFontOfSize(size: 14)
        nuTx.textColor = UIColor.init(cssStr: "#333333")
        nuTx.leftView = UIView(frame: CGRectMake(0, 0, 5, 20))
        nuTx.leftViewMode = .always
        nuTx.layer.cornerRadius = 5
        nuTx.layer.borderWidth = 1
        nuTx.layer.borderColor = UIColor.init(cssStr: "#D6D6D6")?.cgColor
        return nuTx
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(oneView)
        oneView.addSubview(ctImageView)
        
        view.addSubview(twoView)
        twoView.addSubview(nameLabel)
        twoView.addSubview(twoBtn)
        twoView.addSubview(oneBtn)
        
        view.addSubview(submitBtn)
        view.addSubview(threeView)
        view.addSubview(fourView)
        
        threeView.addSubview(threeLabel)
        threeView.addSubview(threeTx)
        threeView.addSubview(phoneLabel)
        threeView.addSubview(phoneTx)
        
        twoView.snp.makeConstraints { make in
            make.top.equalTo(oneView.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        oneView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom)
            make.height.equalTo(110)
        }
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.left.equalToSuperview().offset(14)
            make.size.equalTo(CGSize(width: 346, height: 89))
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
        twoBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(17)
        }
        oneBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(twoBtn.snp.left).offset(-18)
            make.height.equalTo(17)
        }
        
        threeView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(twoView.snp.bottom)
            make.height.equalTo(168)
        }
        threeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(20)
        }
        threeTx.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(threeLabel.snp.bottom).offset(6)
        }
        phoneLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(threeTx.snp.bottom).offset(24)
        }
        phoneTx.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(phoneLabel.snp.bottom).offset(6)
        }
        
        submitBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(40.pix())
            make.left.equalToSuperview().offset(45)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        fourView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(twoView.snp.bottom)
            make.height.equalTo(252)
        }
        
        fourView.addSubview(cLabel)
        fourView.addSubview(cTx)
        
        fourView.addSubview(pLabel)
        fourView.addSubview(pTx)
        
        fourView.addSubview(nuLabel)
        fourView.addSubview(nuTx)
        
        cLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(20)
        }
        cTx.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(cLabel.snp.bottom).offset(6)
        }
        
        pLabel.snp.makeConstraints { make in
            make.top.equalTo(cTx.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(20)
        }
        pTx.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(pLabel.snp.bottom).offset(6)
        }
        
        nuLabel.snp.makeConstraints { make in
            make.top.equalTo(pTx.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(20)
        }
        nuTx.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(nuLabel.snp.bottom).offset(6)
        }
        
        oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.threeView.isHidden = false
            self.fourView.isHidden = true
            self.isClickLeft = true
            self.oneBtn.setImage(UIImage(named: "cycleselectedimage"), for: .normal)
            self.twoBtn.setImage(UIImage(named: "Control_nor"), for: .normal)
            self.cTx.text = ""
            self.pTx.text = ""
            self.nuTx.text = ""
        }).disposed(by: disposeBag)
        
        twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.threeView.isHidden = true
            self.fourView.isHidden = false
            self.isClickLeft = false
            self.oneBtn.setImage(UIImage(named: "Control_nor"), for: .normal)
            self.twoBtn.setImage(UIImage(named: "cycleselectedimage"), for: .normal)
            self.threeTx.text = ""
            self.phoneTx.text = ""
        }).disposed(by: disposeBag)
        
        submitBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if isClickLeft {
                leftInfo()
            }else {
                rightInfo()
            }
        }).disposed(by: disposeBag)
        
    }

}

extension AddCompanyViewController {
    
    private func leftInfo() {
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let entityid = self.threeTx.text ?? ""
        let addtype = "1"
        let phone = self.phoneTx.text ?? ""
        let dict = ["customernumber": customernumber,
                    "entityid": entityid,
                    "addtype": addtype,
                    "phone": phone]
        let man = RequestManager()
        man.requestAPI(params: dict, pageUrl: "/operation/operationAddentity/add", method: .post) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    ToastViewConfig.showToast(message: "添加成功")
                    self.navigationController?.popViewController(animated: true)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    private func rightInfo() {
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let entityname = self.cTx.text ?? ""
        let addtype = "2"
        let province = self.pTx.text ?? ""
        let phone = self.nuTx.text ?? ""
        let dict = ["customernumber": customernumber,
                    "entityname": entityname,
                    "province": province,
                    "addtype": addtype,
                    "phone": phone]
        let man = RequestManager()
        man.requestAPI(params: dict, pageUrl: "/operation/operationAddentity/add", method: .post) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    ToastViewConfig.showToast(message: "添加成功")
                    self.navigationController?.popViewController(animated: true)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        oneBtn.layoutButtonEdgeInsets(style: .left, space: 4)
        twoBtn.layoutButtonEdgeInsets(style: .left, space: 4)
    }
    
}
