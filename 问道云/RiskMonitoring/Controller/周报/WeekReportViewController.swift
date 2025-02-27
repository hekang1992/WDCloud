//
//  WeekReportViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/7.
//  日报

import UIKit
import JXPagingView

class WeekReportViewController: WDBaseViewController {
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension WeekReportViewController: JXPagingViewListViewDelegate {
    
    func listView() -> UIView {
        return self.view
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }
    
    func listScrollView() -> UIScrollView { tableView }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
    
}
