//
//  OneCompanyView.swift
//  问道云
//
//  Created by 何康 on 2025/1/7.
//

import UIKit

class OneCompanyView: BaseView {
    
    //点击最近搜索返回
    var lastSearchTextBlock: ((String) -> Void)?

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
        searchView.isHidden = true
        searchView.backgroundColor = .white
        return searchView
    }()
    
    //浏览历史
    lazy var historyView: SearchHistoryListView = {
        let historyView = SearchHistoryListView()
        historyView.backgroundColor = .white
        historyView.isHidden = true
        return historyView
    }()
    
    //热搜
    lazy var hotWordsView: SearchHotWordsListView = {
        let hotWordsView = SearchHotWordsListView()
        hotWordsView.backgroundColor = .white
        hotWordsView.isHidden = true
        return hotWordsView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
//        addSubview(searchbtn)
        addSubview(scrollView)
        scrollView.addSubview(searchView)
        scrollView.addSubview(historyView)
        scrollView.addSubview(hotWordsView)
//        searchbtn.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(11)
//            make.top.equalToSuperview().offset(8)
//            make.size.equalTo(CGSize(width: 72, height: 23.5))
//        }
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(1)
            make.left.right.bottom.equalToSuperview()
        }
        searchView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalToSuperview()
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
        searchView.lastSearchTextBlock = { [weak self] searchStr in
            self?.lastSearchTextBlock?(searchStr)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
