//
//  DonateMembershipView.swift
//  问道云
//
//  Created by 何康 on 2024/12/31.
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
        return enterImageView
    }()
    
    lazy var sendBtn: UIButton = {
        let sendBtn = UIButton(type: .custom)
        sendBtn.setImage(UIImage(named: "shifoufaemsimgnor"), for: .normal)
        sendBtn.setImage(UIImage(named: "shifoufaemsimgesel"), for: .selected)
        return sendBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(whiteView)
        whiteView.addSubview(ctImageView)
        addSubview(descLabel)
        addSubview(enterImageView)
        addSubview(sendBtn)
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
        sendBtn.snp.makeConstraints { make in
            make.left.equalTo(descLabel.snp.left)
            make.top.equalTo(enterImageView.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width: 97.5, height: 14))
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
