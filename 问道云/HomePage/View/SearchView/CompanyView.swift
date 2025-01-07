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
    
    lazy var nearbtn: UIButton = {
        let nearbtn = UIButton(type: .custom)
        nearbtn.setTitle("附近企业", for: .normal)
        nearbtn.backgroundColor = .white
        nearbtn.layer.cornerRadius = 1.5
        nearbtn.titleLabel?.font = .regularFontOfSize(size: 13)
        nearbtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        return nearbtn
    }()
    
    //最近搜索
    lazy var searchView: SearchLastSearchListView = {
        let searchView = SearchLastSearchListView()
        return searchView
    }()
    
    //浏览历史
    lazy var historyView: SearchHistoryListView = {
        let historyView = SearchHistoryListView()
        return historyView
    }()
    
    //热搜
    lazy var hotWordsView: SearchHotWordsListView = {
        let hotWordsView = SearchHotWordsListView()
        return hotWordsView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.addSubview(searchbtn)
        scrollView.addSubview(nearbtn)
        scrollView.addSubview(searchView)
        scrollView.addSubview(historyView)
        scrollView.addSubview(hotWordsView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
        searchbtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(11)
            make.top.equalToSuperview().offset(8.5)
            make.size.equalTo(CGSize(width: 72, height: 23.5))
        }
        nearbtn.snp.makeConstraints { make in
            make.left.equalTo(searchbtn.snp.right).offset(15)
            make.top.equalToSuperview().offset(8.5)
            make.size.equalTo(CGSize(width: 72, height: 23.5))
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
            make.height.equalTo(0)
            make.bottom.equalToSuperview().offset(-20)
        }
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
