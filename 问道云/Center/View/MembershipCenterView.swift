//
//  MembershipCenterView.swift
//  问道云
//
//  Created by Andrew on 2024/12/15.
//

import UIKit
import RxRelay

class MembershipCenterView: BaseView {
    
    var typeStr: String?
    
    var vipTypeModel = BehaviorRelay<DataModel?>(value: nil)

    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "huibgimage")
        return ctImageView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "vipjuxingimage")
        return bgImageView
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "centericon")
        return iconImageView
    }()
    
    lazy var phonelabel: UILabel = {
        let phonelabel = UILabel()
        phonelabel.text = GetPhoneNumberManager.getPhoneNum()
        phonelabel.textColor = UIColor.init(cssStr: "#333333")
        phonelabel.textAlignment = .left
        phonelabel.font = .boldFontOfSize(size: 15)
        return phonelabel
    }()
    
    lazy var desclabel: UILabel = {
        let desclabel = UILabel()
        desclabel.textColor = UIColor.init(cssStr: "#999999")
        desclabel.textAlignment = .left
        desclabel.font = .regularFontOfSize(size: 11)
        return desclabel
    }()
    
    lazy var vipImageView: UIImageView = {
        let vipImageView = UIImageView()
        vipImageView.image = UIImage(named: "centernokai")
        return vipImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ctImageView)
        ctImageView.addSubview(bgImageView)
        bgImageView.addSubview(iconImageView)
        bgImageView.addSubview(phonelabel)
        bgImageView.addSubview(desclabel)
        bgImageView.addSubview(vipImageView)
        ctImageView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(StatusHeightManager.navigationBarHeight + 76)
        }
        bgImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 345, height: 63))
        }
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(14)
            make.top.equalToSuperview().offset(14)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        phonelabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.equalTo(iconImageView.snp.right).offset(6)
            make.height.equalTo(21)
        }
        desclabel.snp.makeConstraints { make in
            make.left.equalTo(phonelabel.snp.left)
            make.top.equalTo(phonelabel.snp.bottom).offset(2)
            make.height.equalTo(15)
        }
        vipImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 55, height: 22))
        }
        vipTypeModel.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            let userIdentity = model.userIdentity ?? ""
            let accounttype = model.accounttype ?? 0
            if userIdentity == "2" {
                desclabel.text = "\(model.endtime ?? "") 到期"
                typeStr = (accounttype == 2 || accounttype == 3) ? "tuansvvimage" : "cemtervipimage"
                vipImageView.image = UIImage(named: typeStr ?? "")
            }else if userIdentity == "3" {
                desclabel.text = "\(model.endtime ?? "") 到期"
                typeStr = (accounttype == 2 || accounttype == 3) ? "tuansone" : "tuanone"
                vipImageView.image = UIImage(named: typeStr ?? "")
            }else {
                desclabel.text = "众多VIP专享特权等你解锁"
                vipImageView.image = UIImage(named: "centernokai")
            }
        }).disposed(by: disposeBag)

    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
