//
//  SearchRiskViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/7.
//  风险搜索

import UIKit
import JXPagingView
import RxRelay
import MJRefresh
import RxSwift
import DropMenuBar

class SearchRiskViewController: WDBaseViewController {
    
    private var man = RequestManager()
    
    var completeBlock: (() -> Void)?
    
    //城市数据
    var regionModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    
    //行业数据
    var industryModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    
    //公司搜索参数
    var pageIndex: Int = 1
    var entityArea: String = ""//公司时候的地区
    var entityIndustry: String = ""//公司时候的行业
    var allArray: [pageDataModel] = []//公司时候加载更多
    
    //人员搜索参数
    var entityPeopleArea: String = ""//公司时候的地区
    var entityPeopleIndustry: String = ""//公司时候的行业
    var allPeopleArray: [itemsModel] = []//公司时候加载更多
    
    //被搜索的关键词
    var searchWordsRelay = BehaviorRelay<String>(value: "")
    
    var searchWords: String? {
        didSet {
            guard let searchWords = searchWords else { return }
            searchWordsRelay.accept(searchWords)
        }
    }
    
    //热搜
    var hotWordsArray = BehaviorRelay<[rowsModel]?>(value: nil)
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    //搜索文字回调
    var lastSearchTextBlock: ((String) -> Void)?
    
    lazy var riskView: OneCompanyView = {
        let riskView = OneCompanyView()
        return riskView
    }()
    
    //企业加人员
    lazy var twoRiskListView: TwoRiskListView = {
        let twoRiskListView = TwoRiskListView()
        twoRiskListView.backgroundColor = .white
        twoRiskListView.isHidden = true
        return twoRiskListView
    }()
    
    //只有人员
    lazy var listPeopleView: RiskListPeopleView = {
        let listPeopleView = RiskListPeopleView()
        listPeopleView.isHidden = true
        return listPeopleView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    
    lazy var companyBtn: UIButton = {
        let companyBtn = UIButton()
        companyBtn.titleLabel?.font = .mediumFontOfSize(size: 12)
        companyBtn.layer.cornerRadius = 3
        companyBtn.layer.borderWidth = 1
        companyBtn.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        companyBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.2)
        companyBtn.setTitleColor(.init(cssStr: "#547AFF"), for: .normal)
        companyBtn.setTitle("企业", for: .normal)
        companyBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        companyBtn.isHidden = true
        return companyBtn
    }()
    
    lazy var peopleBtn: UIButton = {
        let peopleBtn = UIButton()
        peopleBtn.titleLabel?.font = .mediumFontOfSize(size: 12)
        peopleBtn.layer.cornerRadius = 3
        peopleBtn.layer.borderWidth = 1
        peopleBtn.layer.borderColor = UIColor.init(cssStr: "#CCCCCC")?.cgColor
        peopleBtn.backgroundColor = .white
        peopleBtn.setTitleColor(.init(cssStr: "#999999"), for: .normal)
        peopleBtn.setTitle("人员", for: .normal)
        peopleBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        peopleBtn.isHidden = true
        return peopleBtn
    }()
    
    //选中的按钮标记
    var selectedButton: UIButton?
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(riskView)
        view.addSubview(twoRiskListView)
        view.addSubview(listPeopleView)
        riskView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        //企业加人员
        twoRiskListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        //只有人员
        listPeopleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(35.5)
            make.left.right.bottom.equalToSuperview()
        }
        //删除最近搜索
        self.riskView.searchView.deleteBtn
            .rx
            .tap.subscribe(onNext: { [weak self] in
                self?.deleteSearchInfo()
            }).disposed(by: disposeBag)
        //删除浏览历史
        self.riskView.historyView.deleteBtn
            .rx
            .tap.subscribe(onNext: { [weak self] in
                self?.deleteHistoryInfo()
            }).disposed(by: disposeBag)
        
        //点击最近搜索
        self.riskView.lastSearchTextBlock = { [weak self] searchStr in
            self?.lastSearchTextBlock?(searchStr)
        }
        
        //添加下拉刷新
        self.twoRiskListView.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.pageIndex = 1
            self.searchListInfo()
        })
        
        //添加上拉加载更多
        self.twoRiskListView.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.searchListInfo()
        })
        
        
        view.addSubview(companyBtn)
        view.addSubview(peopleBtn)
        
        companyBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3.5)
            make.left.equalToSuperview().offset(13)
            make.height.equalTo(28.5)
            make.width.equalTo((SCREEN_WIDTH - 40) * 0.5)
        }
        
        peopleBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3.5)
            make.right.equalToSuperview().offset(-13)
            make.height.equalTo(28.5)
            make.width.equalTo((SCREEN_WIDTH - 40) * 0.5)
        }
        
        twoRiskListView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(peopleBtn.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        //企业风险搜索添加下拉选择
        addMenuWithCompanyView()
        //人员风险搜索添加下拉选择
        addMenuWithPeopleView()
        //网络请求
        getDataInfo()
        
        //企业ID回调
        twoRiskListView.entityIdBlock = { [weak self] model in
            let riskDetailVc = CompanyRiskDetailViewController()
            riskDetailVc.enityId = model.orgInfo?.orgId ?? ""
            riskDetailVc.name = model.orgInfo?.orgName ?? ""
            riskDetailVc.logo = model.orgInfo?.logo ?? ""
            self?.navigationController?.pushViewController(riskDetailVc, animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("风险===============风险")
    }
    
}

//数据请求
extension SearchRiskViewController {
    
    private func getDataInfo() {
        //搜索
        self.searchWordsRelay
            .debounce(.milliseconds(800),
                      scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if !text.isEmpty {
                    self.pageIndex = 1
                    self.buttonTapped(companyBtn)
                }else {
                    self.pageIndex = 1
                    self.allArray.removeAll()
                    self.riskView.isHidden = false
                    self.twoRiskListView.isHidden = true
                    self.listPeopleView.isHidden = true
                    self.companyBtn.isHidden = true
                    self.peopleBtn.isHidden = true
                    self.tableView.reloadData()
                }
            }).disposed(by: disposeBag)
        
        self.searchWordsRelay
            .debounce(.milliseconds(50),
                      scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                let group = DispatchGroup()
                //最近搜索
                //                ViewHud.addLoadView()
                group.enter()
                getlastSearch {
                    group.leave()
                }
                //浏览历史
                group.enter()
                getBrowsingHistory {
                    group.leave()
                }
                //热搜
                group.enter()
                getHotWords {
                    group.leave()
                }
                
                // 所有任务完成后的通知
                group.notify(queue: .main) {
                    //                    ViewHud.hideLoadView()
                    self.completeBlock?()
                }
            }).disposed(by: disposeBag)
    }
    
    //最近搜索
    private func getlastSearch(complete: @escaping () -> Void) {
        let man = RequestManager()
        let dict = ["searchType": "",
                    "moduleId": "05"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/searchRecord/query",
                       method: .post) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let rows = success.data?.data {
                    reloadSearchUI(data: rows)
                }
                break
            case .failure(_):
                break
            }
            complete()
        }
    }
    
    //最近搜索UI刷新
    func reloadSearchUI(data: [rowsModel]) {
        var strArray: [String] = []
        if data.count > 0 {
            for model in data {
                strArray.append(model.searchContent ?? "")
            }
            self.riskView.searchView.tagListView.removeAllTags()
            self.riskView.searchView.tagListView.addTags(strArray)
            self.riskView.searchView.isHidden = false
            self.riskView.layoutIfNeeded()
            let height = self.riskView.searchView.tagListView.frame.height
            self.riskView.searchView.snp.updateConstraints { make in
                make.height.equalTo(30 + height + 20)
            }
        } else {
            self.riskView.searchView.isHidden = true
            self.riskView.searchView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        self.riskView.layoutIfNeeded()
    }
    
    //浏览历史
    private func getBrowsingHistory(complete: @escaping () -> Void) {
        let man = RequestManager()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber":customernumber,
                    "viewrecordtype": "",
                    "moduleId": "05",
                    "pageNum": "1",
                    "pageSize": "20"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/clientbrowsecb/selectBrowserecord",
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                guard let self = self else { return }
                if let rows = success.data?.rows {
                    readHistoryUI(data: rows)
                }
                break
            case .failure(_):
                
                break
            }
            complete()
        }
    }
    
    //UI刷新
    func readHistoryUI(data: [rowsModel]) {
        for (index, model) in data.enumerated() {
            let listView = CommonSearchListView()
            listView.block = { [weak self] in
                guard let self = self else { return }
                let riskDetailVc = CompanyRiskDetailViewController()
                let enityId = model.firmnumber ?? ""
                let logo = model.logo ?? ""
                let name = model.firmname ?? ""
                riskDetailVc.enityId = enityId
                riskDetailVc.logo = logo
                riskDetailVc.name = name
                self.navigationController?.pushViewController(riskDetailVc, animated: true)
            }
            let type = model.viewrecordtype ?? ""
            if type == "1" {
                listView.nameLabel.text = model.firmname ?? ""
            }else {
                listView.nameLabel.text = model.personname ?? ""
            }
            listView.timeLabel.text = model.createhourtime ?? ""
            listView.icon.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.firmname ?? "", size: (22, 22), bgColor: UIColor.init(cssStr: model.logoColor ?? "")!))
            self.riskView.historyView.addSubview(listView)
            listView.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(SCREEN_WIDTH)
                make.left.equalToSuperview()
                make.top.equalTo(self.riskView.historyView.lineView.snp.bottom).offset(40 * index)
            }
        }
        
        self.riskView.historyView.snp.updateConstraints { make in
            if data.count != 0 {
                self.riskView.historyView.isHidden = false
                make.height.equalTo((data.count) * 40 + 30)
            } else {
                self.riskView.historyView.isHidden = true
                make.height.equalTo(0)
            }
        }
        self.riskView.layoutIfNeeded()
    }
    
    //热搜
    private func getHotWords(complete: @escaping () -> Void) {
        let man = RequestManager()
        let dict = ["moduleId": "05"]
        man.requestAPI(params: dict,
                       pageUrl: browser_hotwords,
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    self.hotWordsArray.accept(model.data ?? [])
                    hotsWordsUI(data: model.data ?? [])
                }
                break
            case .failure(_):
                break
            }
            complete()
        }
    }
    
    //UI刷新
    func hotsWordsUI(data: [rowsModel]) {
        for (index, model) in data.enumerated() {
            let listView = CommonSearchListView()
            listView.block = { [weak self] in
                guard let self = self else { return }
                let riskDetailVc = CompanyRiskDetailViewController()
                let enityId = model.eid ?? ""
                let logo = model.logo ?? ""
                let name = model.name ?? ""
                riskDetailVc.enityId = enityId
                riskDetailVc.logo = logo
                riskDetailVc.name = name
                self.navigationController?.pushViewController(riskDetailVc, animated: true)
            }
            listView.nameLabel.text = model.name ?? ""
            listView.icon.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.name ?? "", size: (22, 22), bgColor: UIColor.init(cssStr: model.logoColor ?? "")!))
            self.riskView.hotWordsView.addSubview(listView)
            listView.snp.updateConstraints { make in
                make.height.equalTo(40)
                make.left.right.equalToSuperview()
                make.top.equalTo(self.riskView.hotWordsView.lineView.snp.bottom).offset(40 * index)
            }
        }
        
        self.riskView.hotWordsView.snp.updateConstraints { make in
            if data.count != 0 {
                self.riskView.hotWordsView.isHidden = false
                make.height.equalTo((data.count) * 40 + 30)
            } else {
                self.riskView.hotWordsView.isHidden = true
                make.height.equalTo(0)
            }
        }
        self.riskView.layoutIfNeeded()
    }
    
    //删除最近搜索
    private func deleteSearchInfo() {
        ShowAlertManager.showAlert(title: "删除", message: "是否需要删除最近搜索?", confirmAction: {
            let man = RequestManager()
            ViewHud.addLoadView()
            let dict = ["searchType": "",
                        "moduleId": "05"]
            man.requestAPI(params: dict,
                           pageUrl: "/operation/searchRecord/clear",
                           method: .post) { result in
                ViewHud.hideLoadView()
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        ToastViewConfig.showToast(message: "删除成功")
                        self.riskView.searchView.isHidden = true
                        self.riskView.searchView.snp.updateConstraints({ make in
                            make.height.equalTo(0)
                        })
                    }
                    break
                case .failure(_):
                    break
                }
            }
        })
    }
    
    //删除浏览历史
    private func deleteHistoryInfo() {
        ShowAlertManager.showAlert(title: "删除", message: "是否需要删除浏览历史?", confirmAction: {
            let man = RequestManager()
            ViewHud.addLoadView()
            let customerNumber = GetSaveLoginInfoConfig.getCustomerNumber()
            let dict = ["moduleId": "05",
                        "viewrecordtype": "",
                        "customerNumber": customerNumber]
            man.requestAPI(params: dict,
                           pageUrl: "/operation/clientbrowsecb/deleteBrowseRecord",
                           method: .get) { result in
                ViewHud.hideLoadView()
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        ToastViewConfig.showToast(message: "删除成功")
                        self.riskView.historyView.isHidden = true
                        self.riskView.historyView.snp.updateConstraints({ make in
                            make.height.equalTo(0)
                        })
                    }
                    break
                case .failure(_):
                    break
                }
            }
        })
    }
    
    //风险列表数据企业
    private func searchListInfo() {
        let dict = ["keywords": searchWords ?? "",
                    "industryType": entityIndustry,
                    "region": entityArea,
                    "pageNum": pageIndex,
                    "pageSize": 20,
                    "type": "1"] as [String : Any]
        let man = RequestManager()
        ViewHud.addLoadView()
        man.requestAPI(params: dict,
                       pageUrl: "/entity/risk/getRiskData",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            self?.twoRiskListView.tableView.mj_header?.endRefreshing()
            self?.twoRiskListView.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let self = self,
                   let model = success.data,
                   let code = success.code,
                   code == 200, let total = model.pageMeta?.totalNum {
                    self.riskView.isHidden = true
                    self.twoRiskListView.isHidden = false
                    if pageIndex == 1 {
                        pageIndex = 1
                        self.allArray.removeAll()
                    }
                    pageIndex += 1
                    let pageData = model.pageData ?? []
                    self.allArray.append(contentsOf: pageData)
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
                    }else {
                        self.addNodataView(from: self.twoRiskListView.whiteView)
                    }
                    if self.allArray.count != total {
                        self.twoRiskListView.tableView.mj_footer?.isHidden = false
                    }else {
                        self.twoRiskListView.tableView.mj_footer?.isHidden = true
                    }
                    self.twoRiskListView.dataModel.accept(model)
                    self.twoRiskListView.dataModelArray.accept(self.allArray)
                    self.twoRiskListView.searchWordsRelay.accept(self.searchWordsRelay.value)
                    self.twoRiskListView.tableView.reloadData()
                    //根据数据刷新按钮文字
                    let companyNum = String(model.pageMeta?.totalNum ?? 0)
                    let peopleNum = String(model.bossList?.totalNum ?? 0)
                    self.companyBtn.setTitle("企业 \(companyNum)", for: .normal)
                    self.peopleBtn.setTitle("人员 \(peopleNum)", for: .normal)
                    self.companyBtn.isHidden = false
                    self.peopleBtn.isHidden = false
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //只搜索人员
    func searchPeopleListinfo() {
        let dict = ["keywords": searchWords ?? "",
                    "industryType": entityIndustry,
                    "region": entityArea,
                    "pageNum": pageIndex,
                    "pageSize": 20,
                    "type": "2"] as [String : Any]
        //        let man = RequestManager()
        ViewHud.addLoadView()
        man.requestAPI(params: dict,
                       pageUrl: "/entity/risk/getRiskData",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            self?.listPeopleView.tableView.mj_header?.endRefreshing()
            self?.listPeopleView.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let self = self,
                   let model = success.data,
                   let code = success.code,
                   code == 200,
                   let total = model.total {
                    self.riskView.isHidden = true
                    self.listPeopleView.isHidden = false
                    if pageIndex == 1 {
                        pageIndex = 1
                        self.getlastSearch{}
                        self.allPeopleArray.removeAll()
                    }
                    pageIndex += 1
                    let pageData = model.items ?? []
                    self.allPeopleArray.append(contentsOf: pageData)
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
                    }else {
                        self.addNodataView(from: self.listPeopleView.whiteView)
                    }
                    if self.allPeopleArray.count != total {
                        self.listPeopleView.tableView.mj_footer?.isHidden = false
                    }else {
                        self.listPeopleView.tableView.mj_footer?.isHidden = true
                    }
                    self.listPeopleView.dataModel.accept(model)
                    //                    self.listPeopleView.dataModelArray.accept(self.allPeopleArray)
                    self.listPeopleView.searchWordsRelay.accept(self.searchWordsRelay.value)
                    self.listPeopleView.tableView.reloadData()
                    //根据数据刷新按钮文字
                    let peopleNum = String(model.personData?.total ?? 0)
                    self.peopleBtn.setTitle("人员 \(peopleNum)", for: .normal)
                    self.companyBtn.isHidden = false
                    self.peopleBtn.isHidden = false
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}

extension SearchRiskViewController {
    
    @objc func buttonTapped(_ sender: UIButton) {
        // 根据当前点击的按钮切换样式
        if sender == companyBtn {
            updateButtonStyles(selectedButton: companyBtn, unselectedButton: peopleBtn)
            self.pageIndex = 1
            self.searchListInfo()
            self.listPeopleView.isHidden = true
            self.twoRiskListView.isHidden = false
        } else if sender == peopleBtn {
            updateButtonStyles(selectedButton: peopleBtn, unselectedButton: companyBtn)
            self.pageIndex = 1
            self.searchPeopleListinfo()
            self.listPeopleView.isHidden = false
            self.twoRiskListView.isHidden = true
        }
    }
    
    func updateButtonStyles(selectedButton: UIButton, unselectedButton: UIButton) {
        // 更新选中按钮的样式
        selectedButton.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        selectedButton.backgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.2)
        selectedButton.setTitleColor(.init(cssStr: "#547AFF"), for: .normal)
        
        // 更新未选中按钮的样式
        unselectedButton.layer.borderColor = UIColor.init(cssStr: "#CCCCCC")?.cgColor
        unselectedButton.backgroundColor = .white
        unselectedButton.setTitleColor(.init(cssStr: "#999999"), for: .normal)
        
        // 更新选中的按钮标记
        self.selectedButton = selectedButton
    }
    
}

extension SearchRiskViewController {
    
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
            self.entityArea = model?.currentID ?? ""
            self.pageIndex = 1
            self.searchListInfo()
        }
        
        let industryMenu = MenuAction(title: "行业", style: .typeList)!
        
        self.industryModelArray.asObservable().asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            let industryArray = getThreeIndustryInfo(from: modelArray ?? [])
            industryMenu.listDataSource = industryArray
        }).disposed(by: disposeBag)
        
        industryMenu.didSelectedMenuResult = { [weak self] index, model, grand in
            guard let self = self else { return }
            self.entityIndustry = model?.currentID ?? ""
            self.pageIndex = 1
            self.searchListInfo()
        }
        
        let menuView = DropMenuBar(action: [regionMenu, industryMenu])!
        menuView.backgroundColor = .white
        self.twoRiskListView.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(32)
        }
    }
    
    
    private func addMenuWithPeopleView() {
        //添加下拉筛选
        let regionMenu = MenuAction(title: "地区", style: .typeList)!
        self.regionModelArray.asObservable().asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            let regionArray = getThreeRegionInfo(from: modelArray ?? [])
            regionMenu.listDataSource = regionArray
        }).disposed(by: disposeBag)
        
        regionMenu.didSelectedMenuResult = { [weak self] index, model, grand in
            guard let self = self else { return }
            self.entityPeopleArea = model?.currentID ?? ""
            self.pageIndex = 1
            self.searchPeopleListinfo()
        }
        
        let industryMenu = MenuAction(title: "行业", style: .typeList)!
        self.industryModelArray.asObservable().asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            let industryArray = getThreeIndustryInfo(from: modelArray ?? [])
            industryMenu.listDataSource = industryArray
        }).disposed(by: disposeBag)
        
        industryMenu.didSelectedMenuResult = { [weak self] index, model, grand in
            guard let self = self else { return }
            self.entityPeopleIndustry = model?.currentID ?? ""
            self.pageIndex = 1
            self.searchPeopleListinfo()
        }
        
        let menuView = DropMenuBar(action: [regionMenu, industryMenu])!
        menuView.backgroundColor = .white
        self.listPeopleView.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(32)
        }
    }
    
}

extension SearchRiskViewController: JXPagingViewListViewDelegate {
    
    func listView() -> UIView {
        return view
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }
    
    func listScrollView() -> UIScrollView { tableView }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
    
}
