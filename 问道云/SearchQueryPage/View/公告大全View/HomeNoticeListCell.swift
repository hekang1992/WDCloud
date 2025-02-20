//
//  HomeNoticeListCell.swift
//  问道云
//
//  Created by 何康 on 2025/2/10.
//

import UIKit

class HomeNoticeListCell: BaseViewCell {

    var model: itemsModel? {
        didSet {
            guard let model = model else { return }
            nameLabel.text = model.shareShortCode ?? ""
            numLabel.text = "(\(model.shareCode ?? ""))"
            contentLabel.text = model.title ?? ""
            timeLabel.text = model.publishTime ?? ""
        }
    }
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.font = .mediumFontOfSize(size: 15)
        nameLabel.textColor = .init(cssStr: "#547AFF")
        return nameLabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textAlignment = .center
        numLabel.font = .regularFontOfSize(size: 11)
        numLabel.textColor = .init(cssStr: "#999999")
        return numLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textAlignment = .right
        timeLabel.font = .regularFontOfSize(size: 11)
        timeLabel.textColor = .init(cssStr: "#999999")
        return timeLabel
    }()
    
    lazy var contentLabel: UILabel = {
        let contentLabel = UILabel()
        contentLabel.textAlignment = .left
        contentLabel.font = .regularFontOfSize(size: 13)
        contentLabel.textColor = .init(cssStr: "#333333")
        contentLabel.numberOfLines = 0
        return contentLabel
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "rightlrayimge")
        return ctImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(lineView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(numLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(ctImageView)
        lineView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(1)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3.5)
            make.left.equalToSuperview().offset(13)
            make.height.equalTo(21)
        }
        numLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.left.equalTo(nameLabel.snp.right).offset(1)
            make.height.equalTo(15)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.right.equalToSuperview().offset(-14)
            make.height.equalTo(15)
        }
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.right.equalToSuperview().offset(-27)
            make.bottom.equalToSuperview().offset(-8.5)
        }
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentLabel.snp.centerY)
            make.right.equalToSuperview().offset(-17)
            make.size.equalTo(CGSize(width: 10, height: 10))
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
