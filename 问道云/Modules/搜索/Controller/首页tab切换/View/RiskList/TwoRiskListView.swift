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
    
    var peopleBlock: ((pageDataModel) -> Void)?
    
    //点击查看更多
    var moreBlock: ((String) -> Void)?
    
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
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(TwoRiskListCompanyCell.self, forCellReuseIdentifier: "TwoRiskListCompanyCell")
        tableView.register(TwoRiskListPeopleCell.self, forCellReuseIdentifier: "TwoRiskListPeopleCell")
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
                cell?.focusBlock = { [weak self] in
                    if let self = self, let model = model, let cell = cell {
                        let followStatus = model.followStatus ?? 0
                        if followStatus == 1 {
                            addFocusInfo(from: model, cell: cell)
                        }else {
                            deleteFocusInfo(from: model, cell: cell)
                        }
                    }
                }
                cell?.peopleBlock = { [weak self] model in
                    self?.peopleBlock?(model)
                }
                cell?.moreBlock = { [weak self] in
                    guard let self = self else { return }
                    let pageUrl = model?.detailUrl ?? ""
                    self.moreBlock?(pageUrl)
                }
                cell?.heightDidUpdate = { [weak self] in
                    UIView.setAnimationsEnabled(false)
                    self?.tableView.beginUpdates()
                    self?.tableView.endUpdates()
                }
                return cell ?? UITableViewCell()
            }
        }else {
            let model = dataModelArray.value?[indexPath.row]
            model?.searchStr = self.searchWordsRelay.value ?? ""
            let cell = tableView.dequeueReusableCell(withIdentifier: "TwoRiskListCompanyCell") as? TwoRiskListCompanyCell
            cell?.backgroundColor = .clear
            cell?.selectionStyle = .none
            cell?.model.accept(model)
            cell?.moreBlock = { [weak self] in
                guard let self = self else { return }
                let pageUrl = model?.detailUrl ?? ""
                self.moreBlock?(pageUrl)
            }
            cell?.focusBlock = { [weak self] in
                if let self = self, let model = model, let cell = cell {
                    let followStatus = model.followStatus ?? 0
                    if followStatus == 1 {
                        addFocusInfo(from: model, cell: cell)
                    }else {
                        deleteFocusInfo(from: model, cell: cell)
                    }
                }
            }
            cell?.heightDidUpdate = { [weak self] in
                UIView.setAnimationsEnabled(false)
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            }
            cell?.peopleBlock = { [weak self] model in
                self?.peopleBlock?(model)
            }
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

extension TwoRiskListView {
    
    //添加关注
    private func addFocusInfo<T: BaseViewCell>(from model: pageDataModel, cell: T) {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["entityId": model.orgInfo?.orgId ?? "",
                    "followTargetType": "1"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/follow/add-or-cancel",
                       method: .post) { result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    model.followStatus = 2
                    if let specificCell = cell as? TwoRiskListCompanyCell {
                        specificCell.focusBtn.setImage(UIImage(named: "havefocusimage"), for: .normal)
                    }else if let otherCell = cell as? TwoCompanyNormalListCell {
                        otherCell.focusBtn.setImage(UIImage(named: "havefocusimage"), for: .normal)
                    }
                    ToastViewConfig.showToast(message: "关注成功")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //取消关注
    private func deleteFocusInfo<T: BaseViewCell>(from model: pageDataModel, cell: T) {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["entityId": model.orgInfo?.orgId ?? "",
                    "followTargetType": "1"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/follow/add-or-cancel",
                       method: .post) { result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    model.followStatus = 1
                    if let specificCell = cell as? TwoRiskListCompanyCell {
                        specificCell.focusBtn.setImage(UIImage(named: "addfocunimage"), for: .normal)
                    }else if let otherCell = cell as? TwoCompanyNormalListCell {
                        otherCell.focusBtn.setImage(UIImage(named: "addfocunimage"), for: .normal)
                    }
                    ToastViewConfig.showToast(message: "取消关注成功")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
