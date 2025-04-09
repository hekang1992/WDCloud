//
//  SearchPeopleDeadbeatCell.swift
//  问道云
//
//  Created by Andrew on 2025/2/12.
//

import UIKit
import RxRelay

class SearchPeopleDeadbeatCell: BaseViewCell {
    
    var model = BehaviorRelay<itemsModel?>(value: nil)
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        return ctImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor.init(cssStr: "#333333")
        nameLabel.textAlignment = .left
        nameLabel.font = .mediumFontOfSize(size: 15)
        return nameLabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textColor = .init(cssStr: "#999999")
        numLabel.font = .regularFontOfSize(size: 13)
        numLabel.textAlignment = .left
        return numLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F8F8F8")
        return lineView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = .init(cssStr: "#9FA4AD")
        descLabel.font = .regularFontOfSize(size: 13)
        descLabel.textAlignment = .left
        return descLabel
    }()
    
    lazy var cImageView: UIImageView = {
        let cImageView = UIImageView()
        cImageView.image = UIImage(named: "lailaiimage")
        return cImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(ctImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(numLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(descLabel)
        contentView.addSubview(cImageView)
        
        ctImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(9)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.left.equalTo(ctImageView.snp.right).offset(6)
            make.height.equalTo(21)
        }
        numLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(18.5)
        }
        lineView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(5)
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(ctImageView.snp.left)
            make.top.equalTo(ctImageView.snp.bottom).offset(11)
            make.right.equalToSuperview().offset(-6)
            make.height.equalTo(19)
            make.bottom.equalToSuperview().offset(-10)
        }
        cImageView.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.left.equalTo(nameLabel.snp.right).offset(9)
            make.size.equalTo(CGSize(width: 26, height: 15))
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            let name = model.personName ?? ""
            ctImageView.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(name, size: (40, 40)))
            
            let serchStr = model.searchStr ?? ""
            nameLabel.attributedText = GetRedStrConfig.getRedStr(from: serchStr, fullText: name)
            
            let count = String(model.riskCount ?? 0)
            let moduleId = model.moduleId ?? ""
            if moduleId == "38" {
                cImageView.isHidden = true
                numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "共\(count)条被执行记录", font: .regularFontOfSize(size: 13))
            }else if moduleId == "06" {
                cImageView.isHidden = true
                numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "共\(count)条被诉讼记录", font: .regularFontOfSize(size: 13))
            }else {
                cImageView.isHidden = false
                numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "共\(count)条失信记录", font: .regularFontOfSize(size: 13))
            }

            let desctext = (model.resume ?? "").isEmpty ? "--" : model.resume ?? ""
            descLabel.attributedText = GetRedStrConfig.getRedStr(from: desctext, fullText: "简介: \(desctext)", colorStr: "#333333", font: .regularFontOfSize(size: 13))
            
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
