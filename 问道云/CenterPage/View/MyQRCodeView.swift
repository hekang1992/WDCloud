//
//  MyQRCodeView.swift
//  问道云
//
//  Created by 何康 on 2024/12/20.
//

import UIKit

class MyQRCodeView: BaseView {

    lazy var bgImgView: UIImageView = {
        let tmp = UIImageView(image: UIImage(named: "my_qrCode_bg"))
        return tmp
    }()
    
    lazy var telLabel: UILabel = {
        let telLabel = UILabel()
        let phone = UserDefaults.standard.object(forKey: WDY_PHONE) as? String ?? ""
        telLabel.text = PhoneNumberFormatter.formatPhoneNumber(phoneNumber: phone)
        telLabel.textColor = .black
        telLabel.font = .mediumFontOfSize(size: 18)
        return telLabel
    }()
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "centericon")
        return icon
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .init(cssStr: "#E5F4FF")
        bgView.layer.cornerRadius = 4
        return bgView
    }()
    
    lazy var descLabel: UILabel = {
        let tmp = UILabel()
        tmp.text = "邀您使用问道云APP"
        tmp.textColor = .black
        tmp.font = .mediumFontOfSize(size: 14)
        return tmp
    }()
    
    lazy var codeicon: UIImageView = {
        let codeicon = UIImageView()
        codeicon.layer.borderWidth = 2
        codeicon.layer.borderColor = UIColor.white.cgColor
        codeicon.backgroundColor = .random()
        return codeicon
    }()
    
    lazy var bottomLabel: UILabel = {
        let bottomLabel = UILabel()
        bottomLabel.textAlignment = .center
        bottomLabel.text = "扫一扫上方二维码下载问道云APP"
        bottomLabel.textColor = .init(cssStr: "#999999")
        bottomLabel.font = .mediumFontOfSize(size: 12)
        return bottomLabel
    }()
    
    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton()
        closeBtn.adjustsImageWhenHighlighted = false
        closeBtn.setImage(UIImage(named: "my_qrCode_close"), for: .normal)
        return closeBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImgView)
        bgImgView.addSubview(icon)
        bgImgView.addSubview(telLabel)
        bgImgView.addSubview(descLabel)
        bgImgView.addSubview(bgView)
        bgImgView.addSubview(bottomLabel)
        bgView.addSubview(codeicon)
        addSubview(closeBtn)
        bgImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(110)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 300, height: 468))
        }
        
        telLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(72)
            make.height.equalTo(25)
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(telLabel.snp.bottom)
            make.left.right.equalTo(telLabel)
            make.height.equalTo(20)
        }
        icon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(65)
            make.left.equalToSuperview().offset(15)
            make.size.equalTo(CGSizeMake(55, 55))
        }
        bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descLabel.snp.bottom).offset(39)
            make.size.equalTo(CGSize(width: 217, height: 217))
        }
        codeicon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 193, height: 193))
        }
        bottomLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bgView.snp.bottom).offset(8)
        }
        closeBtn.snp.makeConstraints { make in
            make.top.equalTo(bgImgView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(57)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
