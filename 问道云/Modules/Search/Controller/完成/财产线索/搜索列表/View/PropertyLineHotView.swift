//
//  PropertyLineHotView.swift
//  问道云
//
//  Created by 何康 on 2025/3/21.
//

import UIKit

class PropertyLineHotView: BaseView {
    
    var modelArray: [DataModel]?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(PropertyListViewCell.self, forCellReuseIdentifier: "PropertyListViewCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()

}

extension PropertyLineHotView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = .init(cssStr: "#F5F5F5")
        let label = UILabel()
        label.text = "热门搜索"
        label.textColor = .init(cssStr: "#333333")
        label.font = .regularFontOfSize(size: 13)
        label.textAlignment = .left
        headView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(25)
        }
        return headView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = modelArray?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyListViewCell", for: indexPath) as! PropertyListViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        cell.model = model
        return cell
    }

}
