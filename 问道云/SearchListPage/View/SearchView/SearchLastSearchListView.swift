//
//  SearchLastSearchListView.swift
//  问道云
//
//  Created by 何康 on 2025/1/7.
//  最近搜索

import UIKit
import TagListView

class SearchLastSearchListView: BaseView {
    
    //点击最近搜索返回
    var lastSearchTextBlock: ((String) -> Void)?

    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.text = "最近搜索"
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
    
    lazy var tagListView: TagListView = {
        let tagListView = TagListView()
        tagListView.cornerRadius = 2
        tagListView.paddingX = 5
        tagListView.paddingY = 5
        tagListView.marginX = 8
        tagListView.marginY = 8
        tagListView.textColor = .init(cssStr: "#666666")!
        tagListView.tagBackgroundColor = .init(cssStr: "#F3F3F3")!
        tagListView.textFont = .regularFontOfSize(size: 14)
        tagListView.delegate = self
        return tagListView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(descLabel)
        addSubview(lineView)
        addSubview(deleteBtn)
        addSubview(tagListView)
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
        tagListView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(8.5)
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension SearchLastSearchListView: TagListViewDelegate {
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        self.lastSearchTextBlock?(title)
    }
    
}
