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
    
    var dataModelArray = BehaviorRelay<[pageDataModel]?>(value: nil)
    
    //被搜索的文字,根据这个文字,去给cell的namelabel加上颜色
    var searchWordsRelay = BehaviorRelay<String?>(value: nil)
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        return whiteView
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        //头部人员cell
        tableView.register(TwoCompanyHeadPeopleCell.self, forCellReuseIdentifier: "TwoCompanyHeadPeopleCell")
        //公司cell
        tableView.register(TwoCompanySpecListCell.self, forCellReuseIdentifier: "TwoCompanySpecListCell")
        tableView.register(TwoCompanyNormalListCell.self, forCellReuseIdentifier: "TwoCompanyNormalListCell")
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(whiteView)
        whiteView.addSubview(tableView)
        whiteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension TwoCompanyView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let model = dataModel.value
        let bossList = model?.bossList ?? []
        if !bossList.isEmpty {
            return 2
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = dataModel.value
        let bossList = model?.bossList ?? []
        if !bossList.isEmpty {
            if section == 0 {
                return bossList.count
            }else {
                return dataModelArray.value?.count ?? 0
            }
        }else {
            return dataModelArray.value?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataModel.value
        let bossList = model?.bossList ?? []
        
        let companyList = dataModelArray.value
        let pageDataModel = companyList?[indexPath.row]
        if let riskModel = pageDataModel?.riskInfo, let content = riskModel.content, !content.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TwoCompanySpecListCell") as? TwoCompanySpecListCell
            pageDataModel?.searchStr = self.searchWordsRelay.value ?? ""
            cell?.backgroundColor = .clear
            cell?.selectionStyle = .none
            cell?.model.accept(pageDataModel)
            return cell ?? UITableViewCell()
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TwoCompanyNormalListCell") as? TwoCompanyNormalListCell
            pageDataModel?.searchStr = self.searchWordsRelay.value ?? ""
            cell?.backgroundColor = .clear
            cell?.selectionStyle = .none
            cell?.model.accept(pageDataModel)
            return cell ?? UITableViewCell()
        }
    }
    
}
