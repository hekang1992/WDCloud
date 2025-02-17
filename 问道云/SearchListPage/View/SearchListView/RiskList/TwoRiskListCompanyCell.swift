//
//  TwoRiskListCompanyCell.swift
//  问道云
//
//  Created by 何康 on 2025/1/11.
//

import UIKit
import RxRelay
import TagListView

class TwoRiskListCompanyCell: BaseViewCell {
    
    var model = BehaviorRelay<itemsModel?>(value: nil)
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.layer.cornerRadius = 3
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

    lazy var tagListView: TagListView = {
        let tagListView = TagListView()
        tagListView.cornerRadius = 2
        tagListView.paddingX = 5
        tagListView.paddingY = 5
        tagListView.marginX = 8
        tagListView.marginY = 8
        tagListView.textColor = UIColor.init(cssStr: "#F55B5B")!
        tagListView.tagBackgroundColor = UIColor.init(cssStr: "#F55B5B")!.withAlphaComponent(0.1)
        tagListView.textFont = .regularFontOfSize(size: 10)
        return tagListView
    }()
    
    
    lazy var nameView: BiaoQianView = {
        let nameView = BiaoQianView(frame: .zero, enmu: .hide)
        nameView.label1.text = "法定代表人"
        nameView.label2.textColor = .init(cssStr: "#F55B5B")
        nameView.lineView.isHidden = false
        return nameView
    }()
    
    lazy var moneyView: BiaoQianView = {
        let moneyView = BiaoQianView(frame: .zero, enmu: .hide)
        moneyView.label1.text = "注册资本"
        moneyView.label2.textColor = .init(cssStr: "#333333")
        moneyView.lineView.isHidden = false
        return moneyView
    }()
    
    lazy var timeView: BiaoQianView = {
        let timeView = BiaoQianView(frame: .zero, enmu: .hide)
        timeView.label1.text = "成立时间"
        timeView.label2.textColor = .init(cssStr: "#333333")
        return timeView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#EBEBEB")
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
    
    lazy var moreImageView: UIImageView = {
        let moreImageView = UIImageView()
        moreImageView.image = UIImage(named: "moreidanjiimage")
        return moreImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        contentView.addSubview(ctImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(tagListView)
        contentView.addSubview(nameView)
        contentView.addSubview(moneyView)
        contentView.addSubview(timeView)
        contentView.addSubview(lineView)
        contentView.addSubview(oneNumLabel)
        contentView.addSubview(twoNumLabel)
        contentView.addSubview(moreImageView)
        
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(ctImageView.snp.top)
            make.right.equalToSuperview().offset(-55)
            make.left.equalTo(ctImageView.snp.right).offset(8)
        }
        
        tagListView.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.width.equalTo(SCREEN_WIDTH - 60)
            make.right.equalToSuperview().offset(-40)
        }
        
        moneyView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(120)
            make.top.equalTo(tagListView.snp.bottom).offset(6.5)
            make.size.equalTo(CGSize(width: 150, height: 36))
        }
        
        nameView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(moneyView.snp.left)
            make.top.equalTo(moneyView.snp.top)
            make.height.equalTo(36)
        }
        
        timeView.snp.makeConstraints { make in
            make.left.equalTo(moneyView.snp.right)
            make.top.equalTo(moneyView.snp.top)
            make.height.equalTo(36)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-45)
        }
        
        bgView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
        
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalTo(moneyView.snp.bottom).offset(7)
            make.height.equalTo(0.5)
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
        
        moreImageView.snp.makeConstraints { make in
            make.centerY.equalTo(oneNumLabel.snp.centerY)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(16.5)
            make.width.equalTo(85.5)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            
            self.ctImageView.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.entityName ?? "", size: (32, 32), bgColor: .random(), textColor: .white))
            
            //匹配文字
            self.nameLabel.attributedText = TextStyler.styledText(for: model.entityName ?? "", target: model.searchStr ?? "", color: UIColor.init(cssStr: "#F55B5B")!)
            
            self.nameView.label2.text = model.legalName ?? ""
            self.moneyView.label2.text = model.registerCapital ?? ""
            self.timeView.label2.text = model.incorporationTime ?? ""
            
            let riskOne = String(model.riskNum1 ?? 0)
            let riskTwo = String(model.riskNum2 ?? 0)
            self.oneNumLabel.attributedText = GetRedStrConfig.getRedStr(from: riskOne, fullText: "共\(riskOne)条自身风险", font: .regularFontOfSize(size: 12))
            self.twoNumLabel.attributedText = GetRedStrConfig.getRedStr(from: riskTwo, fullText: "\(riskTwo)条关联风险", font: .regularFontOfSize(size: 12))
            
            self.tagListView.removeAllTags()
            self.tagListView.addTag(model.entityStatus ?? "")
            
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
