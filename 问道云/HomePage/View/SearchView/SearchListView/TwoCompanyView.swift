//
//  TwoCompanyView.swift
//  问道云
//
//  Created by 何康 on 2025/1/9.
//

import UIKit
import RxRelay

class TwoCompanyView: BaseView {
    
    var dataModel = BehaviorRelay<DataModel?>(value: nil)

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TwoCompanyListCell.self, forCellReuseIdentifier: "TwoCompanyListCell")
        tableView.register(TwoCompanyHeadPeopleCell.self, forCellReuseIdentifier: "TwoCompanyHeadPeopleCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().offset(32)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension TwoCompanyView: UITableViewDelegate {
    
    
}
