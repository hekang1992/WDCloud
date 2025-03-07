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
    
    var dataModelArray = BehaviorRelay<[pageDataModel]?>(value: nil)
    
    //企业ID回调
    var entityIdBlock: ((pageDataModel) -> Void)?
    
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
        let bossList = dataModel.value?.bossList?.items ?? []
        if !bossList.isEmpty {
            return 2
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let bossList = dataModel.value?.bossList?.items ?? []
        if !bossList.isEmpty {
            if section == 0 {
                return 1
            }else {
                return dataModelArray.value?.count ?? 0
            }
        }else {
            return dataModelArray.value?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bossList = dataModel.value?.bossList?.items ?? []
        if !bossList.isEmpty {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TwoRiskListPeopleCell") as? TwoRiskListPeopleCell
                cell?.backgroundColor = .clear
                cell?.selectionStyle = .none
                let modelArray = dataModel.value?.bossList?.items ?? []
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
        let headView = UIView()
        let bossList = dataModel.value?.bossList?.items ?? []
        if !bossList.isEmpty {
            if section == 0 {
                let peopleView = self.peopleHeadView()
                headView.addSubview(peopleView)
                peopleView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                return headView
            }else {
                let companyView = self.companyHeadView()
                headView.addSubview(companyView)
                companyView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                return headView
            }
        }else {
            let companyView = self.companyHeadView()
            headView.addSubview(companyView)
            companyView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            return headView
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.dataModelArray.value?[indexPath.row] {
            self.entityIdBlock?(model)
        }
    }
    
}

extension TwoRiskListView {
    
    func peopleHeadView() -> UIView {
        let numLabel = UILabel()
        numLabel.font = .mediumFontOfSize(size: 12)
        numLabel.textColor = .init(cssStr: "#666666")
        numLabel.textAlignment = .left
        
        let num = String(dataModel.value?.bossList?.totalNum ?? 0)
        
        let headView = UIView()
        headView.backgroundColor = .init(cssStr: "#F3F3F3")
        headView.addSubview(numLabel)
        //搜索的总结果
        numLabel.attributedText = GetRedStrConfig.getRedStr(from: num, fullText: "搜索到\(num)位相关人员", font: .mediumFontOfSize(size: 12))
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
            make.left.equalToSuperview().offset(10)
        }
        
        return headView
    }
    
    func companyHeadView() -> UIView {
        let countModel = dataModel.value?.pageMeta
        let numStr = countModel?.totalNum ?? 0
        let num = String(countModel?.totalNum ?? 0)
        let headView = UIView()
        
        let numLabel = UILabel()
        numLabel.font = .mediumFontOfSize(size: 12)
        numLabel.textColor = .init(cssStr: "#666666")
        numLabel.textAlignment = .left
        
        let pageLabel = UILabel()
        pageLabel.font = .mediumFontOfSize(size: 12)
        pageLabel.textColor = .init(cssStr: "#666666")
        pageLabel.textAlignment = .right
        
        headView.backgroundColor = .init(cssStr: "#F3F3F3")
        headView.addSubview(numLabel)
        
        //搜索的总结果
        numLabel.attributedText = GetRedStrConfig.getRedStr(from: num, fullText: "搜索到\(num)条结果", font: .mediumFontOfSize(size: 12))
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
            make.left.equalToSuperview().offset(10)
        }
        //搜到共多少页
        let result = Int(ceil(Double(numStr) / Double(20)))
        headView.addSubview(pageLabel)
        pageLabel.text = "第\(countModel?.index ?? 0)/\(result)页"
        pageLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
            make.right.equalToSuperview().offset(-10)
        }
        return headView
    }
    
}
