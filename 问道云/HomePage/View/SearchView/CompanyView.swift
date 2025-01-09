//
//  CompanyView.swift
//  问道云
//
//  Created by 何康 on 2025/1/7.
//

import UIKit

class CompanyView: BaseView {

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    lazy var searchbtn: UIButton = {
        let searchbtn = UIButton(type: .custom)
        searchbtn.setTitle("高级搜索", for: .normal)
        searchbtn.backgroundColor = .white
        searchbtn.layer.cornerRadius = 1.5
        searchbtn.titleLabel?.font = .regularFontOfSize(size: 13)
        searchbtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        return searchbtn
    }()
    
    //最近搜索
    lazy var searchView: SearchLastSearchListView = {
        let searchView = SearchLastSearchListView()
        searchView.backgroundColor = .white
        return searchView
    }()
    
    //浏览历史
    lazy var historyView: SearchHistoryListView = {
        let historyView = SearchHistoryListView()
        historyView.backgroundColor = .white
        return historyView
    }()
    
    //热搜
    lazy var hotWordsView: SearchHotWordsListView = {
        let hotWordsView = SearchHotWordsListView()
        hotWordsView.backgroundColor = .white
        return hotWordsView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.addSubview(searchbtn)
        scrollView.addSubview(searchView)
        scrollView.addSubview(historyView)
        scrollView.addSubview(hotWordsView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
        searchbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(11)
            make.top.equalToSuperview().offset(8)
            make.size.equalTo(CGSize(width: 72, height: 23.5))
        }
        searchView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(searchbtn.snp.bottom).offset(8)
            make.height.equalTo(0)
        }
        historyView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(searchView.snp.bottom).offset(5)
            make.height.equalTo(0)
        }
        hotWordsView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(historyView.snp.bottom).offset(5)
            make.height.equalTo(30)
            make.bottom.equalToSuperview().offset(-20)
        }
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
