//
//  HighSearchViewCell.swift
//  问道云
//
//  Created by 何康 on 2025/3/5.
//

import UIKit

class HighSearchViewCell: UITableViewCell {

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
    
    lazy var focusBtn: UIButton = {
        let focusBtn = UIButton(type: .custom)
        focusBtn.adjustsImageWhenHighlighted = false
        focusBtn.setImage(UIImage(named: "addfocunimage"), for: .normal)
        return focusBtn
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
    
    lazy var tagListView: UIScrollView = {
        let tagListView = UIScrollView()
        tagListView.backgroundColor = .random()
        return tagListView
    }()
    
    lazy var phoneImageView: UIImageView = {
        let phoneImageView = UIImageView()
        phoneImageView.image = UIImage(named: "phoneimagef")
        return phoneImageView
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.textColor = .init(cssStr: "#547AFF")
        phoneLabel.textAlignment = .left
        phoneLabel.font = .regularFontOfSize(size: 12)
        return phoneLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(logoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(focusBtn)
        contentView.addSubview(legalNameLabel)
        contentView.addSubview(lineView1)
        contentView.addSubview(moneyLabel)
        contentView.addSubview(lineView2)
        contentView.addSubview(timeLabel)
        contentView.addSubview(tagListView)
        contentView.addSubview(lineView3)
        contentView.addSubview(phoneImageView)
        contentView.addSubview(phoneLabel)
        
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
        focusBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15.5)
            make.top.equalToSuperview().offset(13)
            make.height.equalTo(14)
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
        tagListView.snp.makeConstraints { make in
            make.left.equalTo(legalNameLabel.snp.left)
            make.top.equalTo(legalNameLabel.snp.bottom).offset(6.5)
            make.right.equalToSuperview().offset(-40)
            make.height.equalTo(18)
        }
        lineView3.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tagListView.snp.bottom).offset(10.5)
            make.left.equalToSuperview().offset(17)
            make.bottom.equalToSuperview().offset(-32.5)
        }
        phoneImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 15, height: 15))
            make.top.equalTo(lineView3.snp.bottom).offset(7)
            make.left.equalToSuperview().offset(15)
        }
        phoneLabel.snp.makeConstraints { make in
            make.centerY.equalTo(phoneImageView.snp.centerY)
            make.left.equalTo(phoneImageView.snp.right).offset(7)
            make.height.equalTo(16.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: pageDataModel? {
        didSet {
            guard let model = model else { return }
            let companyName = model.orgInfo?.orgName ?? ""
            let logoColor = model.orgInfo?.logoColor ?? ""
            logoImageView.image = UIImage.imageOfText(companyName, size: (27.pix(), 27.pix()), bgColor: UIColor.init(cssStr: logoColor)!)
            nameLabel.text = companyName
            
            //关注
            let followStatus = model.followStatus ?? ""
            if followStatus == "1" {
                focusBtn.setImage(UIImage(named: "addfocunimage"), for: .normal)
            }else {
                focusBtn.setImage(UIImage(named: "havefocusimage"), for: .normal)
            }
            
            //法人
            legalNameLabel.text = model.leaderVec?.leaderList?.first?.name ?? ""
            //资本
            moneyLabel.text = model.orgInfo?.regCap ?? ""
            //时间
            timeLabel.text = model.orgInfo?.incDate ?? ""
            //电话
//            phoneLabel.text = model.
        }
    }
    
}
