//
//  PropertyCompanyViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/20.
//

import UIKit
import RxRelay
import JXPagingView

class PropertyCompanyViewController: WDBaseViewController {
    
    //城市数据
    var regionModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    var industryModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    //被搜索的关键词
    var searchWordsRelay = BehaviorRelay<String>(value: "")
    
    var searchWords: String? {
        didSet {
            guard let searchWords = searchWords else { return }
            searchWordsRelay.accept(searchWords)
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}

extension PropertyCompanyViewController: JXPagingViewListViewDelegate {
    
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
