//
//  TwoRiskListView.swift
//  问道云
//
//  Created by Andrew on 2025/1/11.
//  企业和人员

import UIKit
import RxRelay

class TwoRiskListView: BaseView {
    
    var dataModel = BehaviorRelay<DataModel?>(value: nil)
    
    var dataModelArray = BehaviorRelay<[itemsModel]?>(value: nil)
    
    //被搜索的文字,根据这个文字,去给cell的namelabel加上颜色
    var searchWordsRelay = BehaviorRelay<String?>(value: nil)
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .clear
        return whiteView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .init(cssStr: "#F8F8F8")
        tableView.estimatedRowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TwoRiskListPeopleCell.self, forCellReuseIdentifier: "TwoRiskListPeopleCell")
        tableView.register(TwoRiskListCompanyCell.self, forCellReuseIdentifier: "TwoRiskListCompanyCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
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
            make.top.equalToSuperview().offset(34 + 35)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TwoRiskListView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let dataModel = self.dataModel.value
        if let entityData = dataModel?.entityData, let personData = dataModel?.personData, let enItems = entityData.items, let perItems = personData.items, !enItems.isEmpty, !perItems.isEmpty  {
            return 2
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataModel = self.dataModel.value
        if let entityData = dataModel?.entityData, let personData = dataModel?.personData, let enItems = entityData.items, let perItems = personData.items, !enItems.isEmpty, !perItems.isEmpty  {
            if section == 0 {
                return 1
            }else {
                return self.dataModelArray.value?.count ?? 0
            }
        }else {
            return self.dataModelArray.value?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataModel = self.dataModel.value
        if let entityData = dataModel?.entityData, let personData = dataModel?.personData, let enItems = entityData.items, let perItems = personData.items, !enItems.isEmpty, !perItems.isEmpty  {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TwoRiskListPeopleCell") as? TwoRiskListPeopleCell
                cell?.backgroundColor = .clear
                cell?.selectionStyle = .none
                let modelArray = dataModel?.personData?.items ?? []
                cell?.modelArray.accept(modelArray)
                return cell ?? UITableViewCell()
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TwoRiskListCompanyCell") as? TwoRiskListCompanyCell
                cell?.backgroundColor = .clear
                cell?.selectionStyle = .none
                let model = dataModelArray.value?[indexPath.row]
                model?.searchStr = self.searchWordsRelay.value ?? ""
                cell?.model.accept(model)
                return cell ?? UITableViewCell()
            }
        }else {
            let model = dataModelArray.value?[indexPath.row]
            model?.searchStr = self.searchWordsRelay.value ?? ""
            let cell = tableView.dequeueReusableCell(withIdentifier: "TwoRiskListCompanyCell") as? TwoRiskListCompanyCell
            cell?.backgroundColor = .clear
            cell?.selectionStyle = .none
            cell?.model.accept(model)
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dataModel = self.dataModel.value
        if let entityData = dataModel?.entityData, let personData = dataModel?.personData, let enItems = entityData.items, let perItems = personData.items, !enItems.isEmpty, !perItems.isEmpty  {
            let numStr: String
            if section == 0 {
                numStr = String(dataModel?.personData?.total ?? 0)
            } else {
                numStr = String(dataModel?.entityData?.total ?? 0)
            }
            let headView = UIView()
            let numLabel = UILabel()
            numLabel.font = .mediumFontOfSize(size: 12)
            numLabel.textColor = .init(cssStr: "#666666")
            numLabel.textAlignment = .left
            headView.backgroundColor = .init(cssStr: "#F3F3F3")
            headView.addSubview(numLabel)
            // 设置搜索的总结果
            numLabel.attributedText = GetRedStrConfig.getRedStr(from: numStr, fullText: "搜索到\(numStr)条结果", font: .mediumFontOfSize(size: 12))
            numLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.equalTo(25)
                make.left.equalToSuperview().offset(10)
            }
            return headView
        }else {
            let numStr = String(dataModel?.entityData?.total ?? 0)
            let headView = UIView()
            let numLabel = UILabel()
            numLabel.font = .mediumFontOfSize(size: 12)
            numLabel.textColor = .init(cssStr: "#666666")
            numLabel.textAlignment = .left
            headView.backgroundColor = .init(cssStr: "#F3F3F3")
            headView.addSubview(numLabel)
            // 设置搜索的总结果
            numLabel.attributedText = GetRedStrConfig.getRedStr(from: numStr, fullText: "搜索到\(numStr)条结果", font: .mediumFontOfSize(size: 12))
            numLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.equalTo(25)
                make.left.equalToSuperview().offset(10)
            }
            return headView
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ViewControllerUtils.findViewController(from: self)
        let dataModel = self.dataModel.value
        if let entityData = dataModel?.entityData, let personData = dataModel?.personData, let enItems = entityData.items, let perItems = personData.items, !enItems.isEmpty, !perItems.isEmpty  {
            if indexPath.section == 0 {
                return
            }else {
                let model = dataModelArray.value?[indexPath.row]
                let riskDetailVc = CompanyRiskDetailViewController()
                riskDetailVc.name = model?.entityName ?? ""
                riskDetailVc.enityId = model?.entityId ?? ""
                riskDetailVc.logo = model?.logo ?? ""
                vc?.navigationController?.pushViewController(riskDetailVc, animated: true)
            }
        }else {
            let model = dataModelArray.value?[indexPath.row]
            let riskDetailVc = CompanyRiskDetailViewController()
            riskDetailVc.name = model?.entityName ?? ""
            riskDetailVc.enityId = model?.entityId ?? ""
            riskDetailVc.logo = model?.logo ?? ""
            vc?.navigationController?.pushViewController(riskDetailVc, animated: true)
        }
    }
    
}
