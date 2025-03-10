//
//  RiskDetailViewCell.swift
//  问道云
//
//  Created by Andrew on 2025/1/17.
//

import UIKit

class RiskDetailViewCell: BaseViewCell {
    
    lazy var grayView: UIView = {
        let grayView = UIView()
        grayView.backgroundColor = .init(cssStr: "#F5F5F5")
        return grayView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
    }()

    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .mediumFontOfSize(size: 13)
        return namelabel
    }()
    
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "righticonimage")
        return rightImageView
    }()
    
    lazy var numlabel: UILabel = {
        let numlabel = UILabel()
        numlabel.textColor = UIColor.init(cssStr: "#999999")
        numlabel.textAlignment = .right
        numlabel.font = .regularFontOfSize(size: 11)
        return numlabel
    }()
    
    lazy var highLabel: PaddedLabel = {
        let highLabel = PaddedLabel()
        highLabel.backgroundColor = UIColor.init(cssStr: "#FEF0EF")
        highLabel.textColor = UIColor.init(cssStr: "#F55B5B")
        highLabel.layer.cornerRadius = 2
        highLabel.layer.masksToBounds = true
        highLabel.font = .regularFontOfSize(size: 9)
        return highLabel
    }()
    
    lazy var lowLabel: PaddedLabel = {
        let lowLabel = PaddedLabel()
        lowLabel.backgroundColor = UIColor.init(cssStr: "#FFEEDE")
        lowLabel.textColor = UIColor.init(cssStr: "#FF7D00")
        lowLabel.layer.cornerRadius = 2
        lowLabel.layer.masksToBounds = true
        lowLabel.font = .regularFontOfSize(size: 9)
        return lowLabel
    }()
    
    lazy var hitLabel: PaddedLabel = {
        let hitLabel = PaddedLabel()
        hitLabel.backgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.05)
        hitLabel.textColor = UIColor.init(cssStr: "#547AFF")
        hitLabel.layer.cornerRadius = 2
        hitLabel.layer.masksToBounds = true
        hitLabel.font = .regularFontOfSize(size: 9)
        return hitLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(grayView)
        grayView.addSubview(whiteView)
        whiteView.addSubview(namelabel)
        whiteView.addSubview(rightImageView)
        whiteView.addSubview(numlabel)
        whiteView.addSubview(highLabel)
        whiteView.addSubview(lowLabel)
        whiteView.addSubview(hitLabel)
        grayView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(42)
        }
        whiteView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(36)
        }
        namelabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(18.5)
        }
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-17)
            make.size.equalTo(CGSize(width: 10, height: 10))
        }
        numlabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(rightImageView.snp.left).offset(-4)
            make.height.equalTo(15)
        }
        highLabel.snp.makeConstraints { make in
            make.centerY.equalTo(namelabel.snp.centerY)
            make.left.equalTo(namelabel.snp.right).offset(4.5)
            make.height.equalTo(15)
        }
        lowLabel.snp.makeConstraints { make in
            make.centerY.equalTo(namelabel.snp.centerY)
            make.left.equalTo(highLabel.snp.right).offset(4.5)
            make.height.equalTo(15)
        }
        hitLabel.snp.makeConstraints { make in
            make.centerY.equalTo(namelabel.snp.centerY)
            make.left.equalTo(lowLabel.snp.right).offset(4.5)
            make.height.equalTo(15)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
