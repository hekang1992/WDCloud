//
//  CommonHotsViewCell.swift
//  问道云
//
//  Created by 何康 on 2025/3/31.
//

import UIKit

class CommonHotsViewCell: BaseViewCell {

    var model: rowsModel? {
        didSet {
            guard let model = model else { return }
            let logo = model.logo ?? ""
            let logoColor = model.logoColor ?? ""
            let entityName = model.entityName ?? ""
            ctImageView.kf.setImage(with: URL(string: logo), placeholder: UIImage.imageOfText(entityName, size: (22, 22), bgColor: UIColor.init(cssStr: logoColor) ?? .random()))
            nameLabel.text = entityName
            timeLabel.text = model.updateHourTime ?? ""
        }
    }
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.contentMode = .scaleAspectFit
        return ctImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor.init(cssStr: "#666666")
        nameLabel.textAlignment = .left
        nameLabel.font = .regularFontOfSize(size: 13)
        return nameLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = UIColor.init(cssStr: "#999999")
        timeLabel.textAlignment = .right
        timeLabel.font = .regularFontOfSize(size: 13)
        return timeLabel
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
        contentView.addSubview(timeLabel)
        contentView.addSubview(lineView)
        
        ctImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 22, height: 22))
            make.top.equalToSuperview().offset(9)
            make.bottom.equalToSuperview().offset(-9)
            make.left.equalToSuperview().offset(10.5)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-12)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.height.equalTo(20)
            make.left.equalTo(ctImageView.snp.right).offset(4)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
