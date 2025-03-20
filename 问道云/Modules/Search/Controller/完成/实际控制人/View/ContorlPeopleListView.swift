//
//  ContorlPeopleListView.swift
//  问道云
//
//  Created by Andrew on 2025/3/15.
//

import UIKit

class ContorlPeopleListView: BaseView {

    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .regularFontOfSize(size: 13)
        nameLabel.textAlignment = .left
        return nameLabel
    }()

    lazy var typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.textColor = .init(cssStr: "#9FA4AD")
        typeLabel.font = .regularFontOfSize(size: 11)
        typeLabel.textAlignment = .left
        return typeLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(typeLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(18.5)
        }
        typeLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.height.equalTo(15)
            make.bottom.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
