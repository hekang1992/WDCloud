//
//  CompanyLawDetailCell.swift
//  问道云
//
//  Created by 何康 on 2025/2/6.
//

import UIKit

class CompanyLawDetailCell: BaseViewCell {

    lazy var bgViwe: UIView = {
        let bgViwe = UIView()
        bgViwe.backgroundColor = .init(cssStr: "#F7F8FB")
        return bgViwe
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor.init(cssStr: "#333333")
        nameLabel.textAlignment = .left
        nameLabel.font = .regularFontOfSize(size: 13)
        return nameLabel
    }()
    
    lazy var highLabel: PaddedLabel = {
        let highLabel = PaddedLabel()
        highLabel.backgroundColor = UIColor.init(cssStr: "#FEF0EF")
        highLabel.textColor = UIColor.init(cssStr: "#F55B5B")
        highLabel.layer.cornerRadius = 2
        highLabel.layer.masksToBounds = true
        highLabel.font = .regularFontOfSize(size: 11)
        return highLabel
    }()
    
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "righticonimage")
        return rightImageView
    }()
    
    lazy var timelabel: UILabel = {
        let timelabel = UILabel()
        timelabel.textColor = UIColor.init(cssStr: "#999999")
        timelabel.textAlignment = .right
        timelabel.font = .regularFontOfSize(size: 11)
        return timelabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgViwe)
        contentView.addSubview(nameLabel)
        contentView.addSubview(highLabel)
        contentView.addSubview(rightImageView)
        contentView.addSubview(timelabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(26)
            make.height.equalTo(16.5)
            make.bottom.equalToSuperview().offset(-15)
        }
        highLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.left.equalTo(nameLabel.snp.right).offset(4.5)
            make.height.equalTo(15)
        }
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.right.equalToSuperview().offset(-17)
            make.size.equalTo(CGSize(width: 10, height: 10))
        }
        timelabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.right.equalTo(rightImageView.snp.left).offset(-4)
            make.height.equalTo(15)
        }
        bgViwe.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(-2)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
