//
//  SearchCompanyViewController.swift
//  问道云
//
//  Created by 何康 on 2025/1/7.
//  企业搜索

import UIKit
import JXPagingView

class SearchCompanyViewController: WDBaseViewController {
    
    var searchWords: String? {
        didSet {
            print("searchWords======\(searchWords ?? "")")
        }
    }
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    lazy var companyView: CompanyView = {
        let companyView = CompanyView()
        companyView.backgroundColor = .purple
        return companyView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .random()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(companyView)
        view.addSubview(tableView)
        tableView.isHidden = true
        companyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: {
            
        })
        
        //最近搜索
        getlastSearch()
        
        //浏览历史
        getBrowsingHistory()
        
        //热搜
        getHotWords()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("公司")
    }
}

extension SearchCompanyViewController {
    
    //最近搜索
    private func getlastSearch() {
        
    }
    
    //浏览历史
    private func getBrowsingHistory() {
        
    }
    
    //热搜
    private func getHotWords() {
        
    }
    
}

extension SearchCompanyViewController: JXPagingViewListViewDelegate {
    
    func listView() -> UIView {
        return view
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }
    
    func listScrollView() -> UIScrollView { tableView }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
    
}
