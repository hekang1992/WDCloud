//
//  TwoRiskListOnlyPeopleCell.swift
//  问道云
//
//  Created by Andrew on 2025/1/11.
//

import UIKit
import RxRelay

class TwoRiskListOnlyPeopleCell: BaseViewCell {
    
    var model = BehaviorRelay<itemsModel?>(value: nil)
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        return ctImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .mediumFontOfSize(size: 14)
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
        return nameLabel
    }()
    
    lazy var numlabel: UILabel = {
        let numlabel = UILabel()
        numlabel.textColor = UIColor.init(cssStr: "#999999")
        numlabel.textAlignment = .left
        numlabel.font = .mediumFontOfSize(size: 11)
        return numlabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    //自身风险
    lazy var oneNumLabel: UILabel = {
        let oneNumLabel = UILabel()
        oneNumLabel.font = .regularFontOfSize(size: 12)
        oneNumLabel.textAlignment = .left
        oneNumLabel.textColor = .init(cssStr: "#333333")
        return oneNumLabel
    }()
    
    //关联风险
    lazy var twoNumLabel: UILabel = {
        let twoNumLabel = UILabel()
        twoNumLabel.font = .regularFontOfSize(size: 12)
        twoNumLabel.textAlignment = .left
        twoNumLabel.textColor = .init(cssStr: "#333333")
        return twoNumLabel
    }()
    
    lazy var moreLabel: UILabel = {
        let moreLabel = UILabel()
        moreLabel.text = "点击查看更多"
        moreLabel.textAlignment = .right
        moreLabel.textColor = .init(cssStr: "#3F96FF")
        moreLabel.font = .mediumFontOfSize(size: 12)
        return moreLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        contentView.addSubview(ctImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(numlabel)
        contentView.addSubview(oneNumLabel)
        contentView.addSubview(twoNumLabel)
        contentView.addSubview(moreLabel)
        ctImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(9)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.right.equalToSuperview().offset(-160)
            make.left.equalTo(ctImageView.snp.right).offset(6)
        }
        
        numlabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.height.equalTo(18.5)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(ctImageView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-42)
        }
        
        oneNumLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(12.5)
            make.height.equalTo(16.5)
        }
        
        twoNumLabel.snp.makeConstraints { make in
            make.centerY.equalTo(oneNumLabel.snp.centerY)
            make.left.equalTo(oneNumLabel.snp.right).offset(5)
            make.height.equalTo(16.5)
        }
        
        moreLabel.snp.makeConstraints { make in
            make.centerY.equalTo(oneNumLabel.snp.centerY)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(16.5)
        }
        
        bgView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
        
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            
            ctImageView.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.name ?? "", size: (40, 40)))
            
            //匹配文字
            self.nameLabel.attributedText = TextStyler.styledText(for: model.name ?? "", target: model.searchStr ?? "", color: UIColor.init(cssStr: "#F55B5B")!)
            
            let count = String(model.relevanceCount ?? 0)
            numlabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "共关联\(count)家企业", font: .mediumFontOfSize(size: 11))
            
            let riskOne = String(model.riskNum1 ?? 0)
            let riskTwo = String(model.riskNum2 ?? 0)
            self.oneNumLabel.attributedText = GetRedStrConfig.getRedStr(from: riskOne, fullText: "共\(riskOne)条自身风险", font: .regularFontOfSize(size: 12))
            self.twoNumLabel.attributedText = GetRedStrConfig.getRedStr(from: riskTwo, fullText: "\(riskTwo)条关联风险", font: .regularFontOfSize(size: 12))
            
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
