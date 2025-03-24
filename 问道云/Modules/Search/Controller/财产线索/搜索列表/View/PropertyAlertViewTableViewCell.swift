//
//  PropertyAlertViewTableViewCell.swift
//  问道云
//
//  Created by 何康 on 2025/3/24.
//

import UIKit

class PropertyAlertViewTableViewCell: BaseViewCell {
    
    var model: monitorRelationVOListModel? {
        didSet {
            guard let model = model else { return }
            let name = model.entityName ?? ""
            let relationName = model.relationName ?? ""
            ctImageView.image = UIImage.imageOfText(name, size: (30, 30))
            nameLabel.text = name
            descLabel.text = relationName
            
            let select = model.select ?? false
            sureBtn.isSelected = select
            
            let num = model.shareholdingRatio ?? ""
            numLabel.text = "持股比例 \(num)"
        }
    }

    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "")
        ctImageView.contentMode = .scaleAspectFit
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
        descLabel.textColor = .init(cssStr: "#666666")
        descLabel.font = .regularFontOfSize(size: 12)
        descLabel.textAlignment = .left
        return descLabel
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        sureBtn.setImage(UIImage(named: "Control_nor"), for: .normal)
        sureBtn.setImage(UIImage(named: "control_sel"), for: .selected)
        return sureBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var lView: UIView = {
        let lView = UIView()
        lView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lView
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textColor = .init(cssStr: "#666666")
        numLabel.font = .regularFontOfSize(size: 12)
        numLabel.textAlignment = .left
        return numLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(ctImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(sureBtn)
        contentView.addSubview(lineView)
        contentView.addSubview(lView)
        contentView.addSubview(numLabel)
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 29, height: 29))
            make.bottom.equalToSuperview().offset(-20)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.left.equalTo(ctImageView.snp.right).offset(6)
            make.height.equalTo(20)
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(ctImageView.snp.right).offset(6)
            make.top.equalTo(nameLabel.snp.bottom).offset(1.5)
            make.height.equalTo(16.5)
        }
        sureBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-14)
            make.size.equalTo(CGSize(width: 20.pix(), height: 20.pix()))
        }
        lineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        lView.snp.makeConstraints { make in
            make.left.equalTo(descLabel.snp.right).offset(5)
            make.centerY.equalTo(descLabel.snp.centerY)
            make.height.equalTo(16.5)
            make.width.equalTo(1)
        }
        numLabel.snp.makeConstraints { make in
            make.left.equalTo(lView.snp.right).offset(5)
            make.centerY.equalTo(descLabel.snp.centerY)
            make.height.equalTo(16.5)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
