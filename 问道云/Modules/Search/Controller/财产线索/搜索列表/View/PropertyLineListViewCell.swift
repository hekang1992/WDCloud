//
//  PropertyLineListViewCell.swift
//  问道云
//
//  Created by 何康 on 2025/3/15.
//

import UIKit

class PropertyLineListViewCell: UICollectionViewCell {
    
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 2
        bgView.backgroundColor = .init(cssStr: "#F8F8F8")
        return bgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var model: cluesDataListModel? {
        didSet {
            guard let model = model else { return  }
        }
    }
    
}
