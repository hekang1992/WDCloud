//
//  HighSearchViewCell.swift
//  问道云
//
//  Created by 何康 on 2025/3/5.
//

import UIKit

class HighSearchViewCell: UITableViewCell {
    
    var model: pageDataModel? {
        didSet {
            guard let model = model else { return }
            let companyName = model.orgInfo?.orgName ?? ""
            logoImageView.image = UIImage.imageOfText(companyName, size: (27, 27))
            nameLabel.text = companyName
        }
    }

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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(logoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(lineView)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.5)
            make.left.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 27, height: 27))
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11.5)
            make.left.equalTo(logoImageView.snp.right).offset(8)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-87)
        }
        lineView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
