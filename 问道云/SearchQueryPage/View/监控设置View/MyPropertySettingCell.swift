//
//  MyPropertySettingCell.swift
//  问道云
//
//  Created by 何康 on 2025/2/20.
//

import UIKit

class MyPropertySettingCell: BaseViewCell {
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.textColor = UIColor.init(cssStr: "#666666")
        mlabel.textAlignment = .left
        mlabel.font = .regularFontOfSize(size: 12)
        mlabel.numberOfLines = 0
        return mlabel
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "agreeselimage")
        return ctImageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(mlabel)
        contentView.addSubview(ctImageView)
        mlabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.right.equalTo(ctImageView.snp.left).offset(-8)
            make.bottom.equalToSuperview().offset(-12)
        }
        ctImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12.5)
            make.centerY.equalTo(mlabel.snp.centerY)
            make.size.equalTo(CGSize(width: 13, height: 13))
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
