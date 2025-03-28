//
//  DonateMembershipView.swift
//  问道云
//
//  Created by Andrew on 2024/12/31.
//  赠送好友页面

import UIKit
import RxRelay

class DonateMembershipView: BaseView {
    
    var vipTypeModel = BehaviorRelay<DataModel?>(value: nil)
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
    }()

    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "zengsonghaoyouhuiimge")
        return ctImageView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.text = "输入好友手机号码"
        descLabel.textColor = .init(cssStr: "#666666")
        descLabel.font = .mediumFontOfSize(size: 12)
        return descLabel
    }()

    lazy var enterImageView: UIImageView = {
        let enterImageView = UIImageView()
        enterImageView.image = UIImage(named: "phoneenter")
        enterImageView.isUserInteractionEnabled = true
        return enterImageView
    }()
    
    //通讯录
    lazy var contactBtn: UIButton = {
        let contactBtn = UIButton(type: .custom)
        return contactBtn
    }()
    
    lazy var sendBtn: UIButton = {
        let sendBtn = UIButton(type: .custom)
        sendBtn.adjustsImageWhenHighlighted = false
        sendBtn.setImage(UIImage(named: "shifoufaemsimgnor"), for: .normal)
        sendBtn.setImage(UIImage(named: "shifoufaemsimgesel"), for: .selected)
        return sendBtn
    }()
    
    lazy var phoneTx: UITextField = {
        let phoneTx = UITextField()
        phoneTx.keyboardType = .numberPad
        let attrString = NSMutableAttributedString(string: "请输入要赠送的好友手机号码", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#CECECE") as Any,
            .font: UIFont.regularFontOfSize(size: 12)
        ])
        phoneTx.attributedPlaceholder = attrString
        phoneTx.font = .regularFontOfSize(size: 14)
        phoneTx.textColor = UIColor.init(cssStr: "#27344B")
        return phoneTx
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(whiteView)
        whiteView.addSubview(ctImageView)
        addSubview(descLabel)
        addSubview(enterImageView)
        addSubview(sendBtn)
        enterImageView.addSubview(phoneTx)
        enterImageView.addSubview(contactBtn)
        whiteView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(350)
        }
        ctImageView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(StatusHeightManager.navigationBarHeight + 135)
        }
        descLabel.snp.makeConstraints { make in
            make.height.equalTo(16.5)
            make.top.equalTo(ctImageView.snp.bottom).offset(-40)
            make.left.equalToSuperview().offset(16)
        }
        enterImageView.snp.makeConstraints { make in
            make.left.equalTo(descLabel.snp.left)
            make.top.equalTo(descLabel.snp.bottom).offset(4)
            make.size.equalTo(CGSize(width: 343, height: 54.5))
        }
        phoneTx.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(9.5)
            make.size.equalTo(CGSize(width: 210.pix(), height: 31.5))
        }
        contactBtn.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 50, height: 31))
        }
        sendBtn.snp.makeConstraints { make in
            make.left.equalTo(descLabel.snp.left)
            make.top.equalTo(enterImageView.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width: 97.5, height: 14))
        }
        
        
        phoneTx.rx.controlEvent(.editingChanged)
            .withLatestFrom(phoneTx.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.phoneTx.text = String(text.prefix(11))
            })
            .disposed(by: disposeBag)
        
        
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
