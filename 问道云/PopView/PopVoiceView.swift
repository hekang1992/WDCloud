//
//  PopVoiceView.swift
//  问道云
//
//  Created by 何康 on 2025/4/11.
//

import UIKit

class PopVoiceView: BaseView {
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "倾听中"
        mlabel.textColor = UIColor.white
        mlabel.textAlignment = .center
        mlabel.font = .mediumFontOfSize(size: 16)
        return mlabel
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        bgView.layer.cornerRadius = 20
        return bgView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "yuimage")
        return ctImageView
    }()
    
    lazy var ct1ImageView: UIImageView = {
        let ct1ImageView = UIImageView()
        ct1ImageView.contentMode = .scaleAspectFit
        ct1ImageView.clipsToBounds = true
        return ct1ImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(mlabel)
        bgView.addSubview(ctImageView)
        bgView.addSubview(ct1ImageView)
        bgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 273.pix(), height: 200.pix()))
        }
        mlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(22.5)
        }
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(74.pix())
            make.size.equalTo(CGSize(width: 61.pix(), height: 61.pix()))
            make.centerX.equalToSuperview()
        }
        ct1ImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(46.pix())
            make.size.equalTo(CGSize(width: 119.pix(), height: 119.pix()))
            make.centerX.equalToSuperview()
        }
        
        var images = [UIImage]()
        for i in 1...4 {
            if let image = UIImage(named: "one_iamge_\(i)") {
                images.append(image)
            }
        }
        ct1ImageView.animationImages = images
        ct1ImageView.animationDuration = 1.0
        ct1ImageView.animationRepeatCount = 0
        ct1ImageView.startAnimating()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
