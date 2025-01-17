//
//  RiskNumView.swift
//  问道云
//
//  Created by 何康 on 2025/1/17.
//

import UIKit

class RiskNumView: BaseView {

    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.font = .regularFontOfSize(size: 12)
        nameLabel.textColor = .init(cssStr: "#333333")
        return nameLabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textAlignment = .center
        numLabel.font = .mediumFontOfSize(size: 14)
        numLabel.textColor = .init(cssStr: "#FF0000")
        return numLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(numLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(16.5)
        }
        numLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(5.5)
            make.height.equalTo(20)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
