//
//  PopChangePeopleView.swift
//  问道云
//
//  Created by 何康 on 2025/1/3.
//  转让

import UIKit
import RxRelay

class PopChangePeopleView: BaseView {
    
    var model = BehaviorRelay<rowsModel?>(value: nil)
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .init(cssStr: "#F6F6F6")
        return bgView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "转让提示"
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .center
        mlabel.font = .mediumFontOfSize(size: 18)
        mlabel.backgroundColor = .white
        return mlabel
    }()
    
    lazy var onelabel: UILabel = {
        let onelabel = UILabel()
        onelabel.text = "转让前"
        onelabel.textColor = UIColor.init(cssStr: "#666666")
        onelabel.textAlignment = .left
        onelabel.font = .regularFontOfSize(size: 12)
        return onelabel
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        return iconImageView
    }()
    
    lazy var phonelabel: UILabel = {
        let phonelabel = UILabel()
        phonelabel.textColor = UIColor.init(cssStr: "#333333")
        phonelabel.textAlignment = .left
        phonelabel.font = .regularFontOfSize(size: 14)
        return phonelabel
    }()
    
    lazy var typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.text = "默认部门"
        typeLabel.textColor = .init(cssStr: "#9FA4AD")
        typeLabel.font = .regularFontOfSize(size: 11)
        typeLabel.textAlignment = .left
        return typeLabel
    }()
    
    lazy var twolabel: UILabel = {
        let twolabel = UILabel()
        twolabel.text = "转让给"
        twolabel.textColor = UIColor.init(cssStr: "#666666")
        twolabel.textAlignment = .left
        twolabel.font = .regularFontOfSize(size: 12)
        return twolabel
    }()
    
    lazy var oneWhiteView: UIView = {
        let oneWhiteView = UIView()
        oneWhiteView.backgroundColor = .white
        return oneWhiteView
    }()
    
    lazy var twoWhiteView: UIView = {
        let twoWhiteView = UIView()
        twoWhiteView.backgroundColor = .white
        return twoWhiteView
    }()
    
    lazy var nameTx: UITextField = {
        let nameTx = UITextField()
        let attrString = NSMutableAttributedString(string: "请输入成员姓名", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#CECECE") as Any,
            .font: UIFont.regularFontOfSize(size: 13)
        ])
        nameTx.textAlignment = .left
        nameTx.attributedPlaceholder = attrString
        nameTx.font = .regularFontOfSize(size: 14)
        nameTx.textColor = UIColor.init(cssStr: "#27344B")
        return nameTx
    }()
    
    lazy var phoneTx: UITextField = {
        let phoneTx = UITextField()
        phoneTx.keyboardType = .numberPad
        let attrString = NSMutableAttributedString(string: "请输入成员手机号码", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#CECECE") as Any,
            .font: UIFont.regularFontOfSize(size: 13)
        ])
        phoneTx.textAlignment = .left
        phoneTx.attributedPlaceholder = attrString
        phoneTx.font = .regularFontOfSize(size: 14)
        phoneTx.textColor = UIColor.init(cssStr: "#27344B")
        return phoneTx
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.init(cssStr: "#27344B"), for: .normal)
        cancelBtn.titleLabel?.font = .regularFontOfSize(size: 18)
        cancelBtn.backgroundColor = .white
        return cancelBtn
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        sureBtn.setTitle("确认", for: .normal)
        sureBtn.setTitleColor(.white, for: .normal)
        sureBtn.titleLabel?.font = .regularFontOfSize(size: 18)
        sureBtn.backgroundColor = .init(cssStr: "#547AFF")
        return sureBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(mlabel)
        bgView.addSubview(onelabel)
        bgView.addSubview(whiteView)
        
        whiteView.addSubview(iconImageView)
        whiteView.addSubview(phonelabel)
        whiteView.addSubview(typeLabel)
        
        whiteView.addSubview(twolabel)
        
        bgView.addSubview(oneWhiteView)
        bgView.addSubview(twoWhiteView)
        
        oneWhiteView.addSubview(nameTx)
        twoWhiteView.addSubview(phoneTx)
        
        bgView.addSubview(cancelBtn)
        bgView.addSubview(sureBtn)
        
        bgView.snp.makeConstraints { make in
            make.height.equalTo(400)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        mlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(51)
            make.top.equalToSuperview()
        }
        onelabel.snp.makeConstraints { make in
            make.top.equalTo(mlabel.snp.bottom).offset(14.5)
            make.left.equalToSuperview().offset(12.5)
            make.height.equalTo(16.5)
        }
        whiteView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(onelabel.snp.bottom).offset(2)
            make.height.equalTo(56)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.left.equalToSuperview().offset(12)
        }
        phonelabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.left.equalTo(iconImageView.snp.right).offset(11)
            make.height.equalTo(20)
        }
        typeLabel.snp.makeConstraints { make in
            make.left.equalTo(phonelabel.snp.left)
            make.top.equalTo(phonelabel.snp.bottom)
            make.height.equalTo(15)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        twolabel.snp.makeConstraints { make in
            make.top.equalTo(whiteView.snp.bottom).offset(20.5)
            make.left.equalToSuperview().offset(12.5)
            make.height.equalTo(16.5)
        }
        
        oneWhiteView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(twolabel.snp.bottom).offset(2)
            make.height.equalTo(56)
        }
        
        twoWhiteView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(oneWhiteView.snp.bottom).offset(2)
            make.height.equalTo(56)
        }
        
        nameTx.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.5)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        phoneTx.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12.5)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.bottom.left.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalTo(SCREEN_WIDTH * 0.5)
        }
        sureBtn.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalTo(SCREEN_WIDTH * 0.5)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            let name = model.name ?? ""
            let username = model.username ?? ""
            iconImageView.image = UIImage.imageOfText(name, size: (30, 30))
            phonelabel.text = PhoneNumberFormatter.formatPhoneNumber(phoneNumber: username)
        }).disposed(by: disposeBag)
        
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
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension PopChangePeopleView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.setTopCorners(radius: 10)
    }
    
}
