//
//  BrandListView.swift
//  问道云
//
//  Created by 何康 on 2025/4/14.
//

import UIKit

class BrandListView: BaseView {

    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.isUserInteractionEnabled = true
        ctImageView.image = UIImage(named: "brandImages")
        return ctImageView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .mediumFontOfSize(size: 18)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var tagLabel: UILabel = {
        let tagLabel = UILabel()
        tagLabel.textColor = .init(cssStr: "#666666")
        tagLabel.font = .mediumFontOfSize(size: 12)
        tagLabel.textAlignment = .left
        return tagLabel
    }()
    
    lazy var brandLabel: UILabel = {
        let brandLabel = UILabel()
        brandLabel.text = "品牌"
        brandLabel.textColor = .white
        brandLabel.backgroundColor = .init(cssStr: "#547AFF")
        brandLabel.layer.cornerRadius = 2.5
        brandLabel.layer.masksToBounds = true
        brandLabel.textAlignment = .center
        brandLabel.font = .regularFontOfSize(size: 11)
        return brandLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = .init(cssStr: "#666666")
        descLabel.font = .mediumFontOfSize(size: 12)
        descLabel.textAlignment = .left
        descLabel.numberOfLines = 3
        return tagLabel
    }()
    
    lazy var webSiteLabel: UILabel = {
        let webSiteLabel = UILabel()
        webSiteLabel.textColor = .init(cssStr: "#3F96FF")
        webSiteLabel.font = .mediumFontOfSize(size: 12)
        webSiteLabel.textAlignment = .left
        return webSiteLabel
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .random()
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ctImageView)
        ctImageView.addSubview(logoImageView)
        ctImageView.addSubview(nameLabel)
        ctImageView.addSubview(tagLabel)
        ctImageView.addSubview(brandLabel)
        ctImageView.addSubview(descLabel)
        ctImageView.addSubview(webSiteLabel)
        ctImageView.addSubview(scrollView)
        ctImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(179.pix())
        }
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView.snp.centerY)
            make.left.equalTo(logoImageView.snp.right).offset(6)
            make.height.equalTo(25)
            make.width.lessThanOrEqualTo(200)
        }
        tagLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView.snp.centerY)
            make.left.equalTo(nameLabel.snp.right).offset(6)
            make.height.equalTo(17)
            make.width.lessThanOrEqualTo(200)
        }
        brandLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView.snp.centerY)
            make.right.equalToSuperview().offset(-9.5)
            make.size.equalTo(CGSize(width: 30.pix(), height: 16.pix()))
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(10)
        }
        webSiteLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(descLabel.snp.bottom).offset(10)
            make.height.equalTo(17)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(webSiteLabel.snp.bottom).offset(2)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
