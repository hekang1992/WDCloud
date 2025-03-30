//
//  PopPhoneEmailView.swift
//  问道云
//
//  Created by Andrew on 2025/3/7.
//

import UIKit
import RxRelay
import MapKit

class PopPhoneEmailView: BaseView {
    
    var addressBlock: ((addressListModel) -> Void)?
    var websiteBlock: ((websitesListModel) -> Void)?
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()

    lazy var bgViwe: UIView = {
        let bgViwe = UIView()
        bgViwe.backgroundColor = .init(cssStr: "#F3F3F3")
        return bgViwe
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
    }()
    
    lazy var grayView: UIView = {
        let grayView = UIView()
        grayView.layer.cornerRadius = 4
        grayView.backgroundColor = .init(cssStr: "#D8D8D8")
        return grayView
    }()
    
    lazy var phoneView: PhoneEmailNameView = {
        let phoneView = PhoneEmailNameView()
        phoneView.phonelabel.text = "电话号码"
        phoneView.phonelabel.textColor = UIColor.init(cssStr: "#333333")
        phoneView.phonelabel.textAlignment = .left
        phoneView.phonelabel.font = .mediumFontOfSize(size: 15)
        return phoneView
    }()
    
    lazy var addressView: PhoneEmailNameView = {
        let addressView = PhoneEmailNameView()
        addressView.phonelabel.text = "地址"
        addressView.phonelabel.textColor = UIColor.init(cssStr: "#333333")
        addressView.phonelabel.textAlignment = .left
        addressView.phonelabel.font = .mediumFontOfSize(size: 15)
        return addressView
    }()
    
    lazy var websiteView: PhoneEmailNameView = {
        let websiteView = PhoneEmailNameView()
        websiteView.phonelabel.text = "网址"
        websiteView.phonelabel.textColor = UIColor.init(cssStr: "#333333")
        websiteView.phonelabel.textAlignment = .left
        websiteView.phonelabel.font = .mediumFontOfSize(size: 15)
        return websiteView
    }()
    
    lazy var emailView: PhoneEmailNameView = {
        let emailView = PhoneEmailNameView()
        emailView.phonelabel.text = "邮箱"
        emailView.phonelabel.textColor = UIColor.init(cssStr: "#333333")
        emailView.phonelabel.textAlignment = .left
        emailView.phonelabel.font = .mediumFontOfSize(size: 15)
        return emailView
    }()
    
    lazy var wechatView: PhoneEmailNameView = {
        let wechatView = PhoneEmailNameView()
        wechatView.phonelabel.text = "公众号"
        wechatView.phonelabel.textColor = UIColor.init(cssStr: "#333333")
        wechatView.phonelabel.textAlignment = .left
        wechatView.phonelabel.font = .mediumFontOfSize(size: 15)
        return wechatView
    }()
    
    lazy var phoneStackView: UIStackView = {
        let phoneStackView = UIStackView()
        phoneStackView.axis = .vertical
        phoneStackView.spacing = 1
        phoneStackView.translatesAutoresizingMaskIntoConstraints = false
        return phoneStackView
    }()
    
    lazy var addressStackView: UIStackView = {
        let addressStackView = UIStackView()
        addressStackView.axis = .vertical
        addressStackView.spacing = 1
        addressStackView.translatesAutoresizingMaskIntoConstraints = false
        return addressStackView
    }()
    
    lazy var websiteStackView: UIStackView = {
        let websiteStackView = UIStackView()
        websiteStackView.axis = .vertical
        websiteStackView.spacing = 1
        websiteStackView.translatesAutoresizingMaskIntoConstraints = false
        return websiteStackView
    }()
    
    lazy var emailStackView: UIStackView = {
        let emailStackView = UIStackView()
        emailStackView.axis = .vertical
        emailStackView.spacing = 1
        emailStackView.translatesAutoresizingMaskIntoConstraints = false
        return emailStackView
    }()
    
    lazy var wechatStackView: UIStackView = {
        let wechatStackView = UIStackView()
        wechatStackView.axis = .vertical
        wechatStackView.spacing = 1
        wechatStackView.translatesAutoresizingMaskIntoConstraints = false
        return wechatStackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgViwe)
        bgViwe.addSubview(scrollView)
        
        bgViwe.addSubview(whiteView)
        whiteView.addSubview(grayView)
        
        scrollView.addSubview(phoneView)
        scrollView.addSubview(phoneStackView)
        
        scrollView.addSubview(addressView)
        scrollView.addSubview(addressStackView)
        
        scrollView.addSubview(websiteView)
        scrollView.addSubview(websiteStackView)
        
        scrollView.addSubview(emailView)
        scrollView.addSubview(emailStackView)
        
        scrollView.addSubview(wechatView)
        scrollView.addSubview(wechatStackView)
        
        
        
        bgViwe.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(600)
        }
        whiteView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(13)
        }
        
        scrollView.snp.makeConstraints { make in
            make.width.equalTo(SCREEN_WIDTH)
            make.left.bottom.equalToSuperview()
            make.top.equalTo(whiteView.snp.bottom)
        }
        
        grayView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(4)
            make.size.equalTo(CGSize(width: 35.pix(), height: 5.pix()))
        }
        
        phoneView.snp.makeConstraints { make in
            make.height.equalTo(38)
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
        }
        phoneStackView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(phoneView.snp.bottom)
        }
        
        addressView.snp.makeConstraints { make in
            make.top.equalTo(phoneStackView.snp.bottom).offset(4)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(38)
        }
        addressStackView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(addressView.snp.bottom)
        }
        
        websiteView.snp.makeConstraints { make in
            make.top.equalTo(addressStackView.snp.bottom).offset(4)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(38)
        }
        websiteStackView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(websiteView.snp.bottom)
        }
        
        emailView.snp.makeConstraints { make in
            make.top.equalTo(websiteStackView.snp.bottom).offset(4)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(38)
        }
        emailStackView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(emailView.snp.bottom)
        }
        
        wechatView.snp.makeConstraints { make in
            make.top.equalTo(emailStackView.snp.bottom).offset(4)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(38)
        }
        wechatStackView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(wechatView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            let phoneList = model.phoneList ?? []
            let addressList = model.addressList ?? []
            let websitesList = model.websitesList ?? []
            let emailList = model.emailList ?? []
            let wechatList = model.wechatList ?? []
            
            phoneView.phonelabel.text = "电话号码\(phoneList.count)"
            addressView.phonelabel.text = "地址\(addressList.count)"
            websiteView.phonelabel.text = "网址\(websitesList.count)"
            emailView.phonelabel.text = "邮箱\(emailList.count)"
            wechatView.phonelabel.text = "公众号\(wechatList.count)"
            
            //电话
            for (_, model) in phoneList.enumerated() {
                let phoneListView = PhoneEmailListView()
                let phone = model.phone ?? ""
                let year = model.year ?? ""
                let source = model.source ?? ""
                let orgCount = model.orgCount ?? ""
                phoneListView.namelabel.text = phone
                phoneListView.desclabel.text = year + source
                phoneListView
                    .rx
                    .tapGesture()
                    .when(.recognized)
                    .subscribe { [weak self] _ in
                        self?.goPhoneInfo(from: model)
                }.disposed(by: disposeBag)
                if !orgCount.isEmpty && orgCount != "0" {
                    phoneListView.numlabel.isHidden = false
                    phoneListView.numlabel.attributedText = GetRedStrConfig.getRedStr(from: orgCount, fullText: "同电话企业\(orgCount)", colorStr: "#FF7D00", font: .regularFontOfSize(size: 11))
                }else {
                    phoneListView.numlabel.isHidden = true
                }
                phoneStackView.addArrangedSubview(phoneListView)
            }
            
            //地址
            for (_, model) in addressList.enumerated() {
                let phoneListView = PhoneEmailListView()
                let address = model.address ?? ""
                let source = model.source ?? ""
                let type = model.type ?? ""
                let orgCount = model.orgCount ?? ""
                phoneListView.namelabel.text = address
                phoneListView.desclabel.text = source
                phoneListView
                    .rx
                    .tapGesture()
                    .when(.recognized)
                    .subscribe { [weak self] _ in
                        self?.addressBlock?(model)
                }.disposed(by: disposeBag)
                if !type.isEmpty {
                    phoneListView.tagLabel.isHidden = false
                    phoneListView.tagLabel.text = type
                }else {
                    phoneListView.tagLabel.isHidden = true
                }
                if !orgCount.isEmpty && orgCount != "0" {
                    phoneListView.numlabel.isHidden = false
                    phoneListView.numlabel.attributedText = GetRedStrConfig.getRedStr(from: orgCount, fullText: "同注册地址\(orgCount)", colorStr: "#FF7D00", font: .regularFontOfSize(size: 11))
                }else {
                    phoneListView.numlabel.isHidden = true
                }
                addressStackView.addArrangedSubview(phoneListView)
            }
            
            //官网
            for (_, model) in websitesList.enumerated() {
                let phoneListView = PhoneEmailListView()
                let website = model.website ?? ""
                let type = model.icpFlag ?? false
                let owFlag = model.owFlag ?? false
                phoneListView
                    .rx
                    .tapGesture()
                    .when(.recognized)
                    .subscribe { [weak self] _ in
                        self?.websiteBlock?(model)
                }.disposed(by: disposeBag)
                if type {
                    phoneListView.tagLabel.text = "ICP"
                    phoneListView.tagLabel.isHidden = false
                }else {
                    phoneListView.tagLabel.isHidden = true
                }
                if owFlag {
                    phoneListView.numlabel.text = "官网"
                    phoneListView.numlabel.backgroundColor = .init(cssStr: "#547AFF")
                    phoneListView.numlabel.textColor = .white
                    phoneListView.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
                    phoneListView.numlabel.isHidden = false
                }else {
                    phoneListView.numlabel.isHidden = true
                }
                phoneListView.namelabel.text = website
                phoneListView.desclabel.text = "企业网址"
                websiteStackView.addArrangedSubview(phoneListView)
            }
            
            //邮箱
            for (_, model) in emailList.enumerated() {
                let phoneListView = PhoneEmailListView()
                let address = model.email ?? ""
                let source = model.source ?? ""
                let orgCount = model.orgCount ?? ""
                //地址
                phoneListView.namelabel.text = address
                phoneListView.desclabel.text = source
                if !orgCount.isEmpty && orgCount != "0" {
                    phoneListView.numlabel.isHidden = false
                    phoneListView.numlabel.attributedText = GetRedStrConfig.getRedStr(from: orgCount, fullText: "同邮箱企业\(orgCount)", colorStr: "#FF7D00", font: .regularFontOfSize(size: 11))
                }else {
                    phoneListView.numlabel.isHidden = true
                }
                emailStackView.addArrangedSubview(phoneListView)
            }
            
            //公众号
            for (_, model) in wechatList.enumerated() {
                let phoneListView = PhoneEmailListView()
                let address = model.wechat ?? ""
                let source = model.title ?? ""
                let orgCount = model.orgCount ?? ""
                phoneListView.namelabel.text = address
                phoneListView.desclabel.text = source
                if !orgCount.isEmpty && orgCount != "0" {
                    phoneListView.numlabel.isHidden = false
                    phoneListView.numlabel.attributedText = GetRedStrConfig.getRedStr(from: orgCount, fullText: "同公众号企业\(orgCount)", colorStr: "#FF7D00", font: .regularFontOfSize(size: 11))
                }else {
                    phoneListView.numlabel.isHidden = true
                }
                wechatStackView.addArrangedSubview(phoneListView)
            }
            
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PopPhoneEmailView: UIScrollViewDelegate {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgViwe.setTopCorners(radius: 10)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
    
}

extension PopPhoneEmailView {
    
    private func goPhoneInfo(from model: phoneListModel) {
        let phone = model.phone ?? ""
        makePhoneCall(phoneNumber: phone)
    }
    
    private func goEmailInfo(from model: phoneListModel) {
        
    }
    
    func makePhoneCall(phoneNumber: String) {
        guard let url = URL(string: "tel://\(phoneNumber)") else {
            print("无效的电话号码")
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("设备不支持拨打电话")
        }
    }
    
}
