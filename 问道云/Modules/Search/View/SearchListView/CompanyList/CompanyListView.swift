//
//  CompanyListView.swift
//  问道云
//
//  Created by Andrew on 2025/3/6.
//

import UIKit

class CompanyListView: BaseView {

    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textColor = .init(cssStr: "#333333")
        numLabel.font = .regularFontOfSize(size: 13)
        numLabel.textAlignment = .left
        return numLabel
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .regularFontOfSize(size: 13)
        nameLabel.textAlignment = .right
        return nameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(numLabel)
        addSubview(nameLabel)
        
        numLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(7)
            make.centerY.equalToSuperview()
            make.height.equalTo(18.5)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(18.5)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
