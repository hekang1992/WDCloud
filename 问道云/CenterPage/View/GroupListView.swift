//
//  GroupListView.swift
//  问道云
//
//  Created by 何康 on 2025/1/2.
//

import UIKit

class GroupListView: BaseView {
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .init(cssStr: "#F5F7F9")
        bgView.layer.cornerRadius = 3
        return bgView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .random()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(tableView)
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(12.5)
            make.height.equalTo(137)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom).offset(5)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
