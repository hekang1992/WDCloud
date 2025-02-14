//
//  SearchCompanyLoanDefaultViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/10.
//

import UIKit
import RxRelay
import MJRefresh
import DropMenuBar

class SearchCompanyLoanDefaultViewController: WDBaseViewController {
    
    var entityArea: String = ""//公司时候的地区
    var entityIndustry: String = ""//公司时候的行业
    
    //城市数据
    var regionModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    
    //行业数据
    var industryModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    
    var keyWords = BehaviorRelay<String>(value: "")
    var pageNum: Int = 1
    var pageSize: Int = 20
    var type: String = "2"
    var model: DataModel?
    var allArray: [itemsModel] = []
    var block: ((DataModel) -> Void)?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .init(cssStr: "#F5F5F5")
        tableView.register(SanctionTableViewCell.self, forCellReuseIdentifier: "SanctionTableViewCell")
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.keyWords.asObservable().subscribe(onNext: { [weak self] keyWords in
            guard let self = self else { return }
            if !keyWords.isEmpty {
                pageNum = 1
                getSanctionInfo()
            }else {
                self.allArray.removeAll()
            }
        }).disposed(by: disposeBag)
        
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            pageNum = 1
            getSanctionInfo()
        })
        
        //添加上拉加载更多
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getSanctionInfo()
        })
        
        addMenuWithCompanyView()
    }
    
}

extension SearchCompanyLoanDefaultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let count = self.model?.total ?? 0
        let headView = UIView()
        let numLabel = UILabel()
        headView.backgroundColor = .init(cssStr: "#F8F9FB")
        numLabel.textColor = .init(cssStr: "#666666")
        numLabel.attributedText = GetRedStrConfig.getRedStr(from: "\(count)", fullText: "搜到到\(count)条结果", colorStr: "#FF0000")
        numLabel.textAlignment = .left
        numLabel.font = .regularFontOfSize(size: 12)
        headView.addSubview(numLabel)
        numLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12.5)
        }
        return headView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !self.allArray.isEmpty {
            let model = self.allArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "SanctionTableViewCell", for: indexPath) as! SanctionTableViewCell
            model.navHeadTitleStr = "贷款逾期"
            model.searchStr = self.keyWords.value
            cell.model.accept(model)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.allArray[indexPath.row]
        let pageUrl = "\(base_url)/business-risk/tax-violations"
        let dict = ["firmname": model.entityName ?? "",
                    "entityId": model.entityId ?? ""]
        let webUrl = URLQueryAppender.appendQueryParameters(to: pageUrl, parameters: dict) ?? ""
        self.pushWebPage(from: webUrl)
    }
    
}

extension SearchCompanyLoanDefaultViewController {
    
    private func addMenuWithCompanyView() {
        //添加下拉筛选
        let regionMenu = MenuAction(title: "地区", style: .typeList)!
        self.regionModelArray.asObservable().asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            let regionArray = getThreeRegionInfo(from: modelArray ?? [])
            regionMenu.listDataSource = regionArray
        }).disposed(by: disposeBag)
        regionMenu.didSelectedMenuResult = { [weak self] index, model, grand in
            guard let self = self else { return }
            self.pageNum = 1
            self.entityArea = model?.currentID ?? ""
            self.getSanctionInfo()
        }
        
        let industryMenu = MenuAction(title: "行业", style: .typeList)!
        self.industryModelArray.asObservable().asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            let industryArray = getThreeIndustryInfo(from: modelArray ?? [])
            industryMenu.listDataSource = industryArray
        }).disposed(by: disposeBag)
        industryMenu.didSelectedMenuResult = { [weak self] index, model, grand in
            guard let self = self else { return }
            self.pageNum = 1
            self.entityIndustry = model?.currentID ?? ""
            self.getSanctionInfo()
        }
        
        let menuView = DropMenuBar(action: [regionMenu, industryMenu])!
        menuView.backgroundColor = .white
        view.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(32)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(menuView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
    }
    
    //获取行政处罚信息列表
    private func getSanctionInfo() {
        if keyWords.value.isEmpty {
            return
        }
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["type": type,
                    "entityIndustry": entityIndustry,
                    "entityArea": entityArea,
                    "keywords": keyWords.value,
                    "pageNum": pageNum,
                    "pageSize": 20] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/riskmonitor/illegalPunish/getLoanOverdue",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let self = self, let model = success.data, let total = model.total {
                    self.block?(model)
                    self.model = model
                    if pageNum == 1 {
                        pageNum = 1
                        self.allArray.removeAll()
                    }
                    pageNum += 1
                    let pageData = model.items ?? []
                    self.allArray.append(contentsOf: pageData)
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
                    }else {
                        self.addNodataView(from: self.tableView)
                    }
                    if self.allArray.count != total {
                        self.tableView.mj_footer?.isHidden = false
                    }else {
                        self.tableView.mj_footer?.isHidden = true
                    }
                    self.tableView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
