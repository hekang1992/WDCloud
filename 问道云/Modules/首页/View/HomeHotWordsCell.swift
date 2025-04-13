//
//  HomeHotWordsCell.swift
//  问道云
//
//  Created by Andrew on 2025/1/7.
//

import UIKit

class HomeHotWordsCell: UICollectionViewCell {
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#FFFFFF")
        namelabel.textAlignment = .left
        namelabel.font = .regularFontOfSize(size: 11)
        return namelabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(namelabel)
        namelabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
