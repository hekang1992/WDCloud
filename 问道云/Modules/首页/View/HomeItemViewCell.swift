//
//  HomeItemViewCell.swift
//  问道云
//
//  Created by Andrew on 2025/1/6.
//

import UIKit

class HomeItemViewCell: UICollectionViewCell {
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        return iconImageView
    }()
    
    lazy var titlelabel: UILabel = {
        let titlelabel = UILabel()
        titlelabel.textColor = UIColor.init(cssStr: "#27344B")
        titlelabel.textAlignment = .center
        titlelabel.font = .regularFontOfSize(size: 13)
        return titlelabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconImageView)
        addSubview(titlelabel)
        
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 25.pix(), height: 25.pix()))
            make.top.equalToSuperview().offset(16)
        }
        titlelabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(6)
            make.height.equalTo(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
