//
//  CompanyDetailCommonServiceCell.swift
//  问道云
//
//  Created by 何康 on 2025/1/14.
//

import UIKit

class CompanyDetailCommonServiceCell: UICollectionViewCell {
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        return bgImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
