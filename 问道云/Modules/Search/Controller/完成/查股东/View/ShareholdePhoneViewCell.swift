//
//  ShareholdePhoneViewCell.swift
//  问道云
//
//  Created by Andrew on 2025/3/17.
//

import UIKit

class ShareholdePhoneViewCell: BaseViewCell {

    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.textColor = .init(cssStr: "#547AFF")
        phoneLabel.textAlignment = .left
        phoneLabel.font = .mediumFontOfSize(size: 15)
        return phoneLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = .init(cssStr: "#999999")
        descLabel.textAlignment = .left
        descLabel.font = .regularFontOfSize(size: 12)
        return descLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(phoneLabel)
        contentView.addSubview(descLabel)
        phoneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(16)
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(phoneLabel.snp.left)
            make.top.equalTo(phoneLabel.snp.bottom).offset(2)
            make.height.equalTo(14)
            make.bottom.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: websitesListModel? {
        didSet {
            guard let model = model else { return }
            phoneLabel.text = model.value ?? ""
            descLabel.text = "\(model.year ?? "")\(model.source ?? "")"
        }
    }
    
}
