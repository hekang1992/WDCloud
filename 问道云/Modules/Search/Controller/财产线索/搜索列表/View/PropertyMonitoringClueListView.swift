//
//  PropertyMonitoringClueListView.swift
//  问道云
//
//  Created by 何康 on 2025/3/27.
//

import UIKit
import DropMenuBar

class PropertyMonitoringClueListView: BaseView {
    
    var oneListModel: ItemModel?
    var twoListModel: ItemModel?
    var threeListModel: ItemModel?
    
    var listModelArray: [ItemModel]? {
        didSet {
            guard let listModelArray = listModelArray else { return }
            oneListModel = listModelArray[1]
            twoListModel = listModelArray[2]
            threeListModel = listModelArray[3]
        }
    }
    
    // 当前选中的索引
    var selectedIndex1: Int = 0
    var selectedIndex2: Int = 0
    var selectedIndex3: Int = 0
    
    
    lazy var listView: UIView = {
        let listView = UIView()
        listView.backgroundColor = .random()
        return listView
    }()
    
    lazy var tableView1: UITableView = {
        let tableView1 = UITableView(frame: .zero, style: .plain)
        tableView1.separatorStyle = .none
        tableView1.backgroundColor = .clear
        tableView1.register(UITableViewCell.self,
                            forCellReuseIdentifier: "UITableViewCell")
        tableView1.estimatedRowHeight = 80
        tableView1.showsVerticalScrollIndicator = false
        tableView1.contentInsetAdjustmentBehavior = .never
        tableView1.rowHeight = UITableView.automaticDimension
        tableView1.delegate = self
        tableView1.dataSource = self
        if #available(iOS 15.0, *) {
            tableView1.sectionHeaderTopPadding = 0
        }
        return tableView1
    }()
    
    lazy var tableView2: UITableView = {
        let tableView2 = UITableView(frame: .zero, style: .plain)
        tableView2.separatorStyle = .none
        tableView2.backgroundColor = .clear
        tableView2.register(UITableViewCell.self,
                            forCellReuseIdentifier: "UITableViewCell")
        tableView2.estimatedRowHeight = 80
        tableView2.showsVerticalScrollIndicator = false
        tableView2.contentInsetAdjustmentBehavior = .never
        tableView2.rowHeight = UITableView.automaticDimension
        tableView2.delegate = self
        tableView2.dataSource = self
        if #available(iOS 15.0, *) {
            tableView2.sectionHeaderTopPadding = 0
        }
        return tableView2
    }()
    
    lazy var tableView3: UITableView = {
        let tableView3 = UITableView(frame: .zero, style: .plain)
        tableView3.separatorStyle = .none
        tableView3.backgroundColor = .clear
        tableView3.register(UITableViewCell.self,
                            forCellReuseIdentifier: "UITableViewCell")
        tableView3.estimatedRowHeight = 80
        tableView3.showsVerticalScrollIndicator = false
        tableView3.contentInsetAdjustmentBehavior = .never
        tableView3.rowHeight = UITableView.automaticDimension
        tableView3.delegate = self
        tableView3.dataSource = self
        if #available(iOS 15.0, *) {
            tableView3.sectionHeaderTopPadding = 0
        }
        return tableView3
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "addimgesusf")
        return ctImageView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = .init(cssStr: "#3F96FF")
        descLabel.textAlignment = .left
        descLabel.font = .regularFontOfSize(size: 15)
        descLabel.attributedText = GetRedStrConfig.getRedStr(from: "(仅自己可以见)", fullText: "自定义财产关联方(仅自己可以见)", colorStr: "#9FA4AD")
        return descLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(listView)
        listView.addSubview(tableView1)
        listView.addSubview(tableView2)
        listView.addSubview(tableView3)
        listView.addSubview(ctImageView)
        listView.addSubview(descLabel)
        listView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView1.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
            make.width.equalToSuperview().dividedBy(3)
        }
        tableView2.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(tableView1.snp.trailing)
            make.bottom.equalToSuperview().offset(-40)
            make.width.equalToSuperview().dividedBy(3)
        }
        tableView3.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(tableView2.snp.trailing)
            make.bottom.equalToSuperview().offset(-40)
            make.width.equalToSuperview().dividedBy(3)
        }
        ctImageView.snp.makeConstraints { make in
            make.left.equalTo(tableView1.snp.left).offset(40)
            make.bottom.equalToSuperview().offset(-12)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(ctImageView.snp.right).offset(4)
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.height.equalTo(20)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PropertyMonitoringClueListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = .random()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableView1 {
            // 更新第一个表格的选中索引
            selectedIndex1 = indexPath.row
            // 重置第二个表格的选中索引
            selectedIndex2 = 0
            // 刷新第二个表格
            tableView2.reloadData()
            // 刷新第三个表格
            tableView3.reloadData()
            // 选中第二个表格的第一行
            tableView2.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
        } else if tableView == tableView2 {
            // 更新第二个表格的选中索引
            selectedIndex2 = indexPath.row
            // 刷新第三个表格
            tableView3.reloadData()
        }
    }
    
}
