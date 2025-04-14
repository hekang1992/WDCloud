//
//  MessagePushListViewCell.swift
//  问道云
//
//  Created by 何康 on 2025/4/14.
//

import UIKit
import SevenSwitch

class MessagePushListViewCell: BaseViewCell {
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()

    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.textAlignment = .left
        nameLabel.font = .regularFontOfSize(size: 14)
        return nameLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = .init(cssStr: "#999999")
        descLabel.textAlignment = .left
        descLabel.font = .regularFontOfSize(size: 11)
        return descLabel
    }()
    
    lazy var oneSwitch: SevenSwitch = {
        let oneSwitch = SevenSwitch()
        oneSwitch.on = true
        oneSwitch.onTintColor = .init(cssStr: "#547AFF")!
        return oneSwitch
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(descLabel)
        bgView.addSubview(oneSwitch)
        bgView.addSubview(lineView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.5)
            make.left.equalToSuperview().offset(18)
            make.height.equalTo(20)
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.left.equalToSuperview().offset(18)
            make.height.equalTo(15)
            make.bottom.equalToSuperview().offset(-10)
        }
        oneSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 36, height: 18))
        }
        lineView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
