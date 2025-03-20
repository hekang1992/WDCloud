//
//  MyDownloadView.swift
//  问道云
//
//  Created by Andrew on 2024/12/12.
//

import UIKit
import RxRelay

class MyDownloadView: BaseView {
    
    lazy var searchView: MyDownloadSearchView = {
        let searchView = MyDownloadSearchView()
        return searchView
    }()
    
    lazy var filterView: UIView = {
        let filterView = UIView()
        filterView.backgroundColor = .white
        return filterView
    }()
    
    var modelArray = BehaviorRelay<[rowsModel]>(value: [])
    
    let isDeleteMode = BehaviorRelay<Bool>(value: false) // 控制是否是删除模式
    
    var selectBlock: ((rowsModel) -> Void)?//选择
    
    var moreBtnBlock: ((rowsModel) -> Void)?//点击...
    
    var selectedIndexPaths = [IndexPath]() // 存储选中的IndexPath
    
    var totalBlock: ((Int) -> Void)?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(MyDownloadViewNormalCell.self, forCellReuseIdentifier: "MyDownloadViewNormalCell")
        tableView.register(MyDownloadViewEditCell.self, forCellReuseIdentifier: "MyDownloadViewEditCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        return whiteView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(searchView)
        addSubview(filterView)
        addSubview(whiteView)
        whiteView.addSubview(tableView)
        searchView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(46)
        }
        filterView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
            make.height.equalTo(26)
        }
        whiteView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(filterView.snp.bottom)
        }
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MyDownloadView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isdeleteGrand = self.isDeleteMode.value
        let model = self.modelArray.value[indexPath.row]
        if isdeleteGrand {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyDownloadViewEditCell", for: indexPath) as! MyDownloadViewEditCell
            cell.model = model
            let isChecked = self.selectedIndexPaths.contains(indexPath)
            cell.configureDeleteCell(isChecked: isChecked)
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyDownloadViewNormalCell", for: indexPath) as! MyDownloadViewNormalCell
            cell.model.accept(model)
            cell.block = { [weak self] model in
                self?.moreBtnBlock?(model)
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isdeleteGrand = self.isDeleteMode.value
        let model = self.modelArray.value[indexPath.row]
        if !isdeleteGrand {
            self.selectBlock?(model)
        }else {
            let cell = tableView.cellForRow(at: indexPath) as! MyDownloadViewEditCell
            if let index = self.selectedIndexPaths.firstIndex(of: indexPath) {
                self.selectedIndexPaths.remove(at: index)
            } else {
                self.selectedIndexPaths.append(indexPath)
            }
            let isChecked = self.selectedIndexPaths.contains(indexPath)
            cell.configureDeleteCell(isChecked: isChecked)
            self.totalBlock?(self.selectedIndexPaths.count)
        }
    }
}
