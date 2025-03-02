//
//  SearchHotWordsListView.swift
//  问道云
//
//  Created by Andrew on 2025/1/7.
//  热搜

import UIKit

class SearchHotWordsListView: BaseView {
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.text = "热门搜索"
        descLabel.font = .regularFontOfSize(size: 12)
        descLabel.textColor = UIColor.init(cssStr: "#999999")
        descLabel.textAlignment = .left
        return descLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#F3F3F3")
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(descLabel)
        addSubview(lineView)
        descLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(7)
            make.height.equalTo(16.5)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalToSuperview().offset(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
