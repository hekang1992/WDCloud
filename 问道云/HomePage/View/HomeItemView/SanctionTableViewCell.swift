//
//  SanctionTableViewCell.swift
//  问道云
//
//  Created by 何康 on 2025/2/11.
//

import UIKit
import RxRelay

class SanctionTableViewCell: BaseViewCell {
    
    var model = BehaviorRelay<itemsModel?>(value: nil)
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .init(cssStr: "#F5F5F5")
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
        return nameLabel
    }()
    
    lazy var tagListView: UIScrollView = {
        let tagListView = UIScrollView()
        return tagListView
    }()
    
    lazy var nameView: BiaoQianView = {
        let nameView = BiaoQianView(frame: .zero, enmu: .hide)
        nameView.lineView.isHidden = false
        nameView.label1.text = "法定代表人"
        nameView.isUserInteractionEnabled = true
        return nameView
    }()
    
    lazy var moneyView: BiaoQianView = {
        let moneyView = BiaoQianView(frame: .zero, enmu: .hide)
        moneyView.lineView.isHidden = false
        moneyView.label1.text = "注册资本"
        return moneyView
    }()
    
    lazy var timeView: BiaoQianView = {
        let timeView = BiaoQianView(frame: .zero, enmu: .hide)
        timeView.label1.text = "成立时间"
        return timeView
    }()
    
    lazy var riskView: UIView = {
        let riskView = UIView()
        riskView.layer.cornerRadius = 2
        riskView.backgroundColor = UIColor.init(cssStr: "#F55B5B")?.withAlphaComponent(0.05)
        return riskView
    }()
    
    lazy var riskImageView: UIImageView = {
        let riskImageView = UIImageView()
        riskImageView.image = UIImage(named: "riskiamgeicon")
        return riskImageView
    }()
    
    lazy var risklabel: UILabel = {
        let risklabel = UILabel()
        risklabel.textColor = UIColor.init(cssStr: "#666666")
        risklabel.textAlignment = .left
        risklabel.font = .regularFontOfSize(size: 12)
        return risklabel
    }()
    
    lazy var riImageView: UIImageView = {
        let riImageView = UIImageView()
        riImageView.image = UIImage(named: "righticonimage")
        return riImageView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#EBEBEB")
        return lineView
    }()
    
    lazy var moreImageView: UIImageView = {
        let moreImageView = UIImageView()
        moreImageView.image = UIImage(named: "moreidanjiimage")
        return moreImageView
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        contentView.addSubview(ctImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(tagListView)
        contentView.addSubview(nameView)
        contentView.addSubview(moneyView)
        contentView.addSubview(timeView)
        contentView.addSubview(riskView)
        riskView.addSubview(riskImageView)
        riskView.addSubview(risklabel)
        riskView.addSubview(riImageView)
        contentView.addSubview(lineView)
        contentView.addSubview(moreImageView)
        contentView.addSubview(oneNumLabel)
        contentView.addSubview(twoNumLabel)
        
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(ctImageView.snp.top).offset(-1)
            make.height.equalTo(20)
            make.left.equalTo(ctImageView.snp.right).offset(8)
        }
        
        tagListView.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.width.equalTo(SCREEN_WIDTH - 80)
            make.height.equalTo(15)
        }
        
        moneyView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(120)
            make.top.equalTo(tagListView.snp.bottom).offset(6.5)
            make.size.equalTo(CGSize(width: 150, height: 36))
        }
        
        nameView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(moneyView.snp.left)
            make.top.equalTo(tagListView.snp.bottom).offset(6.5)
            make.height.equalTo(36)
        }
        
        timeView.snp.makeConstraints { make in
            make.left.equalTo(moneyView.snp.right)
            make.top.equalTo(tagListView.snp.bottom).offset(6.5)
            make.height.equalTo(36)
            make.right.equalToSuperview()
        }
        
        riskView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(30)
            make.top.equalTo(moneyView.snp.bottom).offset(7)
        }
        riskImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(6)
            make.size.equalTo(CGSize(width: 57, height: 13))
        }
        risklabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(riskImageView.snp.right).offset(10.5)
            make.height.equalTo(16.5)
        }
        riImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-7)
            make.size.equalTo(CGSize(width: 12, height: 12))
        }
        
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalTo(tagListView.snp.bottom).offset(91)
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-42)
        }
        
        bgView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(5)
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
            make.size.equalTo(CGSize(width: 85.5, height: 16.5))
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            ctImageView.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.entityName ?? "", size: (32, 32)))
            
            self.nameLabel.attributedText = TextStyler.styledText(for: model.entityName ?? "", target: model.searchStr ?? "", color: UIColor.init(cssStr: "#F55B5B")!)
            
            nameView.label2.textColor = .init(cssStr: "#333333")
            nameView.label2.text = model.legalName ?? ""
            
            moneyView.label2.textColor = .init(cssStr: "#333333")
            moneyView.label2.text = model.registerCapital ?? ""
            
            timeView.label2.textColor = .init(cssStr: "#333333")
            timeView.label2.text = model.incorporationTime ?? ""
            
            let riskOne = String(model.riskNum1 ?? 0)
            let riskTwo = String(model.riskNum2 ?? 0)
            self.oneNumLabel.attributedText = GetRedStrConfig.getRedStr(from: riskOne, fullText: "共\(riskOne)条自身风险")
            self.twoNumLabel.attributedText = GetRedStrConfig.getRedStr(from: riskTwo, fullText: "\(riskTwo)条关联风险")
            
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
