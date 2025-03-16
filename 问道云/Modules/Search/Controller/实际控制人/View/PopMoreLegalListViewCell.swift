//
//  PopMoreLegalListViewCell.swift
//  问道云
//
//  Created by 何康 on 2025/3/16.
//

import UIKit

class PopMoreLegalListViewCell: BaseViewCell {

    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        return ctImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .regularFontOfSize(size: 14)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(ctImageView)
        contentView.addSubview(nameLabel)
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(ctImageView.snp.right).offset(10)
            make.height.equalTo(25)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: leaderListModel? {
        didSet {
            guard let model = model else { return }
            let companyName = model.name ?? ""
            ctImageView.image = UIImage.imageOfText(companyName, size: (25, 25))
            nameLabel.text = companyName
        }
    }
    
}
