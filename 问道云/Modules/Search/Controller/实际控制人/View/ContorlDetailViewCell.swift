//
//  ContorlDetailViewCell.swift
//  问道云
//
//  Created by 何康 on 2025/3/15.
//

import UIKit

class ContorlDetailViewCell: BaseViewCell {
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .mediumFontOfSize(size: 14)
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F3F3F3")
        return lineView
    }()
    
    lazy var tagLabel: PaddedLabel = {
        let tagLabel = PaddedLabel()
        tagLabel.font = .regularFontOfSize(size: 10)
        tagLabel.layer.cornerRadius = 2.5
        return tagLabel
    }()
    
    lazy var legalNameLabel: UILabel = {
        let legalNameLabel = UILabel()
        legalNameLabel.textColor = .init(cssStr: "#3F96FF")
        legalNameLabel.textAlignment = .left
        legalNameLabel.font = .regularFontOfSize(size: 12)
        return legalNameLabel
    }()
    
    lazy var lineView1: UIView = {
        let lineView1 = UIView()
        lineView1.backgroundColor = .init(cssStr: "#D5D5D5")
        return lineView1
    }()
    
    lazy var lineView2: UIView = {
        let lineView2 = UIView()
        lineView2.backgroundColor = .init(cssStr: "#D5D5D5")
        return lineView2
    }()
    
    lazy var lineView3: UIView = {
        let lineView3 = UIView()
        lineView3.backgroundColor = .init(cssStr: "#D5D5D5")
        return lineView3
    }()
    
    lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textColor = .init(cssStr: "#666666")
        moneyLabel.textAlignment = .left
        moneyLabel.font = .regularFontOfSize(size: 12)
        return moneyLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = .init(cssStr: "#666666")
        timeLabel.textAlignment = .left
        timeLabel.font = .regularFontOfSize(size: 12)
        return timeLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(logoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(tagLabel)
        contentView.addSubview(legalNameLabel)
        contentView.addSubview(lineView1)
        contentView.addSubview(moneyLabel)
        contentView.addSubview(lineView2)
        contentView.addSubview(timeLabel)
        contentView.addSubview(lineView3)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.5)
            make.left.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 27.pix(), height: 27.pix()))
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11.5)
            make.left.equalTo(logoImageView.snp.right).offset(8)
            make.height.equalTo(20)
        }
        tagLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15.5)
            make.top.equalToSuperview().offset(13)
            make.height.equalTo(18.pix())
        }
        legalNameLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.height.equalTo(16.5)
        }
        lineView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(4)
        }
        lineView1.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.centerY.equalTo(legalNameLabel.snp.centerY)
            make.left.equalTo(legalNameLabel.snp.right).offset(7)
            make.width.equalTo(1)
        }
        moneyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(legalNameLabel.snp.centerY)
            make.top.equalTo(legalNameLabel.snp.top)
            make.left.equalTo(lineView1.snp.right).offset(7)
            make.height.equalTo(16.5)
        }
        lineView2.snp.makeConstraints { make in
            make.height.equalTo(12)
            make.centerY.equalTo(legalNameLabel.snp.centerY)
            make.left.equalTo(moneyLabel.snp.right).offset(7)
            make.width.equalTo(1)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(legalNameLabel.snp.centerY)
            make.top.equalTo(legalNameLabel.snp.top)
            make.left.equalTo(lineView2.snp.right).offset(7)
            make.height.equalTo(16.5)
        }
        
        lineView3.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timeLabel.snp.bottom).offset(10.5)
            make.left.equalToSuperview().offset(17)
            make.bottom.equalToSuperview().offset(-32.5)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: rowsModel? {
        didSet {
            guard let model = model else { return }
            let companyName = model.orgName ?? ""
            let logoColor = model.logoColor ?? ""
            logoImageView.image = UIImage.imageOfText(companyName, size: (27.pix(), 27.pix()), bgColor: UIColor.init(cssStr: logoColor)!)
            nameLabel.text = companyName
            
            let regStatus = model.regStatus ?? ""
            tagLabel.text = regStatus
            TagsLabelColorConfig.nameLabelColor(from: tagLabel)
            
            let peopleName = model.leaderVec?.leaderList?.first?.name ?? ""
            legalNameLabel.text = peopleName
            
            let moneyStr = model.regCap ?? ""
            moneyLabel.text = moneyStr
            
            let timeStr = model.incDate ?? ""
            timeLabel.text = timeStr
        }
    }
}
