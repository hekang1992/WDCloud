//
//  PropertyPeopleCollectionViewCell.swift
//  问道云
//
//  Created by 何康 on 2025/3/29.
//

import UIKit

class PropertyPeopleCollectionViewCell: UICollectionViewCell {
    
    var model: relatedEntityListModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.logoUrl ?? ""
            let entityName = model.entityName ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl), placeholder: UIImage.imageOfText(entityName, size: (20, 20)))
            mlabel.text = entityName
            desclabel.text = model.identity ?? ""
            let num = String(model.clueNum ?? 0)
            let money = model.clueValuation ?? ""
            numlabel.attributedText = GetRedStrConfig.getRedStr(from: num, fullText: "线索\(num)条", colorStr: "#F55B5B", font: UIFont.regularFontOfSize(size: 10))
            moneylabel.attributedText = GetRedStrConfig.getRedStr(from: money, fullText: "金额\(money)", colorStr: "#F55B5B", font: UIFont.regularFontOfSize(size: 10))
        }
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .init(cssStr: "#F8F8F8")
        bgView.layer.cornerRadius = 2
        bgView.layer.masksToBounds = true
        return bgView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.contentMode = .scaleAspectFit
        return logoImageView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .left
        mlabel.font = .mediumFontOfSize(size: 12)
        return mlabel
    }()
    
    lazy var desclabel: UILabel = {
        let desclabel = UILabel()
        desclabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        desclabel.textAlignment = .left
        desclabel.font = .mediumFontOfSize(size: 10)
        return desclabel
    }()
    
    lazy var numlabel: UILabel = {
        let numlabel = UILabel()
        numlabel.textColor = UIColor.init(cssStr: "#666666")
        numlabel.textAlignment = .left
        numlabel.font = .regularFontOfSize(size: 10)
        return numlabel
    }()
    
    lazy var moneylabel: UILabel = {
        let moneylabel = UILabel()
        moneylabel.textColor = UIColor.init(cssStr: "#666666")
        moneylabel.textAlignment = .left
        moneylabel.font = .regularFontOfSize(size: 10)
        return moneylabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(logoImageView)
        bgView.addSubview(mlabel)
        bgView.addSubview(desclabel)
        bgView.addSubview(numlabel)
        bgView.addSubview(moneylabel)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        logoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(6)
            make.top.equalToSuperview().offset(7.5)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        mlabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView.snp.centerY)
            make.left.equalTo(logoImageView.snp.right).offset(3)
            make.right.equalToSuperview().offset(-1)
        }
        desclabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(6)
            make.top.equalTo(logoImageView.snp.bottom).offset(1.5)
            make.right.equalToSuperview().offset(-1)
        }
        numlabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(6)
            make.top.equalTo(desclabel.snp.bottom).offset(1.5)
            make.right.equalToSuperview().offset(-1)
        }
        moneylabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(6)
            make.top.equalTo(numlabel.snp.bottom).offset(1.5)
            make.right.equalToSuperview().offset(-1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
