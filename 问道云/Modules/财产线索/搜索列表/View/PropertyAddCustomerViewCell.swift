//
//  PropertyAddCustomerViewCell.swift
//  问道云
//
//  Created by 何康 on 2025/3/29.
//

import UIKit

class PropertyAddCustomerViewCell: UITableViewCell {
    
    var model: itemsModel? {
        didSet {
            guard let model = model else { return }
            let name = model.relationName ?? ""
            ctImageView.image = UIImage.imageOfText(name, size: (25, 25))
            nameLabel.text = name
            descLabel.text = model.connectName ?? ""
        }
    }

    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        return ctImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .mediumFontOfSize(size: 14)
        nameLabel.textAlignment = .left
        return nameLabel
    }()

    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = .init(cssStr: "#999999")
        descLabel.font = .mediumFontOfSize(size: 12)
        descLabel.textAlignment = .right
        return descLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(ctImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(lineView)
        
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 25, height: 25))
            make.left.equalToSuperview().offset(10)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(ctImageView.snp.right).offset(6)
            make.right.equalToSuperview().offset(-40)
            make.bottom.equalToSuperview().offset(-14)
        }
        descLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(16.5)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
