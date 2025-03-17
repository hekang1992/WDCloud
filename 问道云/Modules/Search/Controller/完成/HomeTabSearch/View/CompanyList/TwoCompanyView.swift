//
//  TwoCompanyView.swift
//  问道云
//
//  Created by Andrew on 2025/1/9.
//  企业搜索列表

import UIKit
import RxRelay
import SkeletonView

class TwoCompanyView: BaseView {
    
    //地址回调
    var addressBlock: ((pageDataModel) -> Void)?
    //官网回调
    var websiteBlock: ((pageDataModel) -> Void)?
    //电话回调
    var phoneBlock: ((pageDataModel) -> Void)?
    //人物回调
    var peopleBlock: ((pageDataModel) -> Void)?
    //企业ID回调
    var entityIdBlock: ((pageDataModel) -> Void)?
    //人员查看更多
    var moreBtnBlock: (() -> Void)?
    
    var dataModel: DataModel?
    
    var dataModelArray: [pageDataModel]?
    
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
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        //头部人员cell
        tableView.register(TwoCompanyHeadPeopleCell.self, forCellReuseIdentifier: "TwoCompanyHeadPeopleCell")
        //公司cell
//        tableView.register(TwoCompanySpecListCell.self, forCellReuseIdentifier: "TwoCompanySpecListCell")
        tableView.register(TwoCompanyNormalListCell.self, forCellReuseIdentifier: "TwoCompanyNormalListCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isSkeletonable = true
        addSubview(whiteView)
        whiteView.addSubview(tableView)
        whiteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.left.right.bottom.equalToSuperview()
        }
        
        print("检查骨架屏是否激活========\(tableView.sk.isSkeletonActive)")
        print("检查是否支持骨架屏=========\(tableView.isSkeletonable)")
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension TwoCompanyView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let bossList = dataModel?.bossList?.items ?? []
        if !bossList.isEmpty {
            return 2
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let bossList = dataModel?.bossList?.items ?? []
        if !bossList.isEmpty {
            if section == 0 {
                return 1
            }else {
                return dataModelArray?.count ?? 0
            }
        }else {
            return dataModelArray?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bossList = dataModel?.bossList?.items ?? []
        if !bossList.isEmpty {
            if indexPath.section == 0 {
                let pageDataModel = dataModel?.bossList?.items
                let cell = tableView.dequeueReusableCell(withIdentifier: "TwoCompanyHeadPeopleCell") as? TwoCompanyHeadPeopleCell
                cell?.selectionStyle = .none
                cell?.modelArray = pageDataModel
                cell?.isSkeletonable = true
                return cell ?? UITableViewCell()
            }else {
                let pageDataModel = self.dataModelArray?[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "TwoCompanyNormalListCell") as? TwoCompanyNormalListCell
                pageDataModel?.searchStr = self.searchWordsRelay.value ?? ""
                cell?.selectionStyle = .none
                cell?.isSkeletonable = true
                cell?.model.accept(pageDataModel)
                cell?.addressBlock = { [weak self] model in
                    self?.addressBlock?(model)
                }
                cell?.websiteBlock = { [weak self] model in
                    self?.websiteBlock?(model)
                }
                cell?.phoneBlock = { [weak self] model in
                    self?.phoneBlock?(model)
                }
                cell?.peopleBlock = { [weak self] model in
                    self?.peopleBlock?(model)
                }
                cell?.focusBlock = { [weak self] model in
                    if let cell = cell {
                        self?.focusInfo(from: model, cell: cell)
                    }
                }
                return cell ?? UITableViewCell()
            }
        }else {
            let pageDataModel = self.dataModelArray?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "TwoCompanyNormalListCell") as? TwoCompanyNormalListCell
            pageDataModel?.searchStr = self.searchWordsRelay.value ?? ""
            cell?.backgroundColor = .clear
            cell?.isSkeletonable = true
            cell?.selectionStyle = .none
            cell?.model.accept(pageDataModel)
            cell?.addressBlock = { [weak self] model in
                self?.addressBlock?(model)
            }
            cell?.websiteBlock = { [weak self] model in
                self?.websiteBlock?(model)
            }
            cell?.phoneBlock = { [weak self] model in
                self?.phoneBlock?(model)
            }
            cell?.peopleBlock = { [weak self] model in
                self?.peopleBlock?(model)
            }
            cell?.focusBlock = { [weak self] model in
                if let cell = cell {
                    self?.focusInfo(from: model, cell: cell)
                }
            }
            //跳转风险扫描
            cell?.riskBlock = { [weak self] model in
                guard let self = self else { return }
                let vc = ViewControllerUtils.findViewController(from: self)
                let riskDetailVc = CompanyRiskDetailViewController()
                riskDetailVc.name = model.orgInfo?.orgName ?? ""
                riskDetailVc.enityId = model.orgInfo?.orgId ?? ""
                riskDetailVc.logo = model.orgInfo?.logo ?? ""
                vc?.navigationController?.pushViewController(riskDetailVc, animated: true)
            }
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        let bossList = dataModel?.bossList?.items ?? []
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
        if let model = self.dataModelArray?[indexPath.row] {
            self.entityIdBlock?(model)
        }
    }
    
    func peopleHeadView() -> UIView {
        let moreBtn = UIButton(type: .custom)
        moreBtn.setImage(UIImage(named: "chakanmoreimge"), for: .normal)
        moreBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        moreBtn.setTitleColor(.init(cssStr: "#3F96FF"), for: .normal)
        moreBtn.layoutButtonEdgeInsets(style: .right, space: 2)
        
        let numLabel = UILabel()
        numLabel.font = .mediumFontOfSize(size: 12)
        numLabel.textColor = .init(cssStr: "#666666")
        numLabel.textAlignment = .left
        let num = String(dataModel?.bossList?.totalNum ?? 0)
        
        let headView = UIView()
        headView.backgroundColor = .init(cssStr: "#F3F3F3")
        headView.addSubview(numLabel)
        headView.addSubview(moreBtn)
        //搜索的总结果
        numLabel.attributedText = GetRedStrConfig.getRedStr(from: num, fullText: "搜索到\(num)位相关人员", font: .mediumFontOfSize(size: 12))
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
            make.left.equalToSuperview().offset(10)
        }
        moreBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
            make.right.equalToSuperview().offset(-10)
        }
        
        moreBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.moreBtnBlock?()
        }).disposed(by: disposeBag)
        return headView
    }
    
    func companyHeadView() -> UIView {
        let countModel = dataModel?.pageMeta
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

extension TwoCompanyView {
    
    private func focusInfo<T: BaseViewCell>(from model: pageDataModel, cell: T) {
        if cell is TwoCompanyNormalListCell {
            let followStatus = model.followStatus ?? ""
            if followStatus == "1" {
                addFocusInfo(from: model, cell: cell)
            }else {
                deleteFocusInfo(from: model, cell: cell)
            }
        } else if cell is TwoCompanyNormalListCell {
            let followStatus = model.followStatus ?? ""
            if followStatus == "1" {
                addFocusInfo(from: model, cell: cell)
            }else {
                deleteFocusInfo(from: model, cell: cell)
            }
        }
    }
    
    //添加关注
    private func addFocusInfo<T: BaseViewCell>(from model: pageDataModel, cell: T) {
        let man = RequestManager()
        
        let dict = ["entityId": model.orgInfo?.orgId ?? "",
                    "followTargetType": "1"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/follow/add-or-cancel",
                       method: .post) { result in
            
            switch result {
            case .success(let success):
                if success.code == 200 {
                    model.followStatus = "2"
                    if let specificCell = cell as? TwoCompanyNormalListCell {
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
        let man = RequestManager()
        
        let dict = ["entityId": model.orgInfo?.orgId ?? "",
                    "followTargetType": "1"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/follow/add-or-cancel",
                       method: .post) { result in
            
            switch result {
            case .success(let success):
                if success.code == 200 {
                    model.followStatus = "1"
                    if let specificCell = cell as? TwoCompanyNormalListCell {
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

// MARK: - SkeletonTableViewDataSource
extension TwoCompanyView: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "TwoCompanyNormalListCell"
    }

    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
}
