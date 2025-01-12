//
//  SearchHistoryListView.swift
//  问道云
//
//  Created by 何康 on 2025/1/7.
//  浏览历史

import UIKit

class SearchHistoryListView: BaseView {

    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.text = "浏览历史"
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
    
    lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton(type: .custom)
        deleteBtn.setImage(UIImage(named: "delete_icon"), for: .normal)
        return deleteBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(descLabel)
        addSubview(lineView)
        addSubview(deleteBtn)
        descLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(7)
            make.size.equalTo(CGSize(width: 50, height: 16.5))
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalToSuperview().offset(30)
        }
        deleteBtn.snp.makeConstraints { make in
            make.centerY.equalTo(descLabel.snp.centerY)
            make.right.equalToSuperview().offset(-5)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
