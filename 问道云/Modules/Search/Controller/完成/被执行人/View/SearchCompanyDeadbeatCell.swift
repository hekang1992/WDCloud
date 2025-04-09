//
//  SearchCompanyDeadbeatCell.swift
//  问道云
//
//  Created by Andrew on 2025/2/12.
//

import UIKit
import RxRelay

class SearchCompanyDeadbeatCell: BaseViewCell {
    
    var model = BehaviorRelay<pageDataModel?>(value: nil)
    
    var nameBlock: ((leaderVecModel) -> Void)?
    
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
    
    lazy var cImageView: UIImageView = {
        let cImageView = UIImageView()
        cImageView.image = UIImage(named: "lailaiimage")
        return cImageView
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textColor = .init(cssStr: "#9FA4AD")
        oneLabel.font = .regularFontOfSize(size: 13)
        oneLabel.textAlignment = .left
        oneLabel.isUserInteractionEnabled = true
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textColor = .init(cssStr: "#9FA4AD")
        twoLabel.font = .regularFontOfSize(size: 13)
        twoLabel.textAlignment = .left
        return twoLabel
    }()
    
    lazy var threeLabel: UILabel = {
        let threeLabel = UILabel()
        threeLabel.textColor = .init(cssStr: "#9FA4AD")
        threeLabel.font = .regularFontOfSize(size: 13)
        threeLabel.textAlignment = .left
        return threeLabel
    }()
    
    lazy var fourLabel: UILabel = {
        let fourLabel = UILabel()
        fourLabel.textColor = .init(cssStr: "#9FA4AD")
        fourLabel.font = .regularFontOfSize(size: 13)
        fourLabel.textAlignment = .left
        return fourLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(ctImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(numLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(cImageView)
        contentView.addSubview(oneLabel)
        contentView.addSubview(twoLabel)
        contentView.addSubview(threeLabel)
        contentView.addSubview(fourLabel)
        
        ctImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(9)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(9)
            make.left.equalTo(ctImageView.snp.right).offset(6)
            make.height.equalTo(21)
        }
        numLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.left.equalTo(nameLabel.snp.left)
            make.height.equalTo(18.5)
            make.bottom.equalToSuperview().offset(-110)
        }
        lineView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(5)
        }
        
        cImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.size.equalTo(CGSize(width: 26, height: 15))
        }
        
        oneLabel.snp.makeConstraints { make in
            make.left.equalTo(ctImageView.snp.left)
            make.top.equalTo(ctImageView.snp.bottom).offset(11)
            make.height.equalTo(18.5)
        }
        twoLabel.snp.makeConstraints { make in
            make.left.equalTo(ctImageView.snp.left)
            make.top.equalTo(oneLabel.snp.bottom).offset(4)
            make.height.equalTo(18.5)
        }
        threeLabel.snp.makeConstraints { make in
            make.left.equalTo(ctImageView.snp.left)
            make.top.equalTo(twoLabel.snp.bottom).offset(4)
            make.height.equalTo(18.5)
        }
        fourLabel.snp.makeConstraints { make in
            make.left.equalTo(ctImageView.snp.left)
            make.top.equalTo(threeLabel.snp.bottom).offset(4)
            make.height.equalTo(18.5)
        }
        
        //名字点击
        oneLabel
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, let model = model.value?.leaderVec  else { return }
                self.nameBlock?(model)
        }).disposed(by: disposeBag)
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            let name = model.orgInfo?.orgName ?? ""
            ctImageView.kf.setImage(with: URL(string: model.orgInfo?.logo ?? ""), placeholder: UIImage.imageOfText(name, size: (40, 40)))
            
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
            
            let legalName = model.leaderVec?.leaderList?.first?.name ?? ""
            oneLabel.attributedText = GetRedStrConfig.getRedStr(from: legalName, fullText: "\(model.leaderVec?.leaderTypeName ?? ""): \(legalName)", colorStr: "#3F96FF", font: .regularFontOfSize(size: 13))
            
            let registerCapital = model.orgInfo?.regCap ?? ""
            twoLabel.attributedText = GetRedStrConfig.getRedStr(from: registerCapital, fullText: "注册资本: \(registerCapital)", colorStr: "#333333", font: .regularFontOfSize(size: 13))
            
            let incorporationTime = model.orgInfo?.incDate ?? ""
            threeLabel.attributedText = GetRedStrConfig.getRedStr(from: incorporationTime, fullText: "成立日期: \(incorporationTime)", colorStr: "#333333", font: .regularFontOfSize(size: 13))
            
            let organizationNumber = model.orgInfo?.org_no ?? ""
            fourLabel.attributedText = GetRedStrConfig.getRedStr(from: organizationNumber, fullText: "组织机构代码: \(organizationNumber)", colorStr: "#333333", font: .regularFontOfSize(size: 13))
            
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
