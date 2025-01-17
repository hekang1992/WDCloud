//
//  SearchCompanyViewController.swift
//  问道云
//
//  Created by 何康 on 2025/1/7.
//  企业搜索

import UIKit
import JXPagingView
import RxRelay
import DropMenuBar
import MJRefresh
import RxSwift

class SearchCompanyViewController: WDBaseViewController {
    
    //城市数据
    var regionModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    
    //行业数据
    var industryModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    
    //搜索参数
    var pageIndex: Int = 1
    var entityArea: String = ""//地区
    var entityIndustry: String = ""//行业
    
    var allArray: [pageDataModel] = []//加载更多
    
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
    
    lazy var companyView: OneCompanyView = {
        let companyView = OneCompanyView()
        companyView.isHidden = false
        return companyView
    }()
    
    //搜索list列表页面
    lazy var companyListView: TwoCompanyView = {
        let companyListView = TwoCompanyView()
        companyListView.isHidden = true
        return companyListView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(companyView)
        companyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(companyListView)
        companyListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        //删除最近搜索
        self.companyView.searchView.deleteBtn
            .rx
            .tap.subscribe(onNext: { [weak self] in
                self?.deleteSearchInfo()
            }).disposed(by: disposeBag)
        //删除浏览历史
        self.companyView.historyView.deleteBtn
            .rx
            .tap.subscribe(onNext: { [weak self] in
                self?.deleteHistoryInfo()
            }).disposed(by: disposeBag)
        
        //点击最近搜索
        self.companyView.lastSearchTextBlock = { [weak self] searchStr in
            self?.lastSearchTextBlock?(searchStr)
            self?.searchWords = searchStr
        }
        
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
        self.companyListView.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0.5)
            make.left.right.equalToSuperview()
            make.height.equalTo(32)
        }
        
        //添加下拉刷新
        self.companyListView.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.pageIndex = 1
            self.searchListInfo()
        })
        
        //添加上拉加载更多
        self.companyListView.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.searchListInfo()
        })
        
        //更新搜索文字
        self.searchWordsRelay
            .debounce(.milliseconds(1000),
                      scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if !text.isEmpty {
                    self.pageIndex = 1
                    self.searchListInfo()
                }else {
                    self.pageIndex = 1
                    self.allArray.removeAll()
                    self.companyView.isHidden = false
                    self.companyListView.isHidden = true
                }
                
                //                let containsChinese = text.range(of: "[\\u4e00-\\u9fa5]", options: .regularExpression) != nil
                //                let containsEnglish = text.range(of: "[a-zA-Z]", options: .regularExpression) != nil
                //                if containsChinese && containsEnglish {
                //                    // 如果同时包含中文和英文字符
                //                    print("包含中文和英文")
                //                    // 在这里执行您的逻辑
                //                } else if containsChinese {
                //                    // 只包含中文
                //                    print("只包含中文")
                //                    // 在这里执行您的中文逻辑
                //                } else if containsEnglish {
                //                    // 只包含英文
                //                    print("只包含英文")
                //                    // 在这里执行您的英文逻辑
                //                }
            }).disposed(by: disposeBag)
        
        
        companyListView.addressBlock = { [weak self] model in
            let locationVc = CompanyLocationViewController()
            locationVc.headView.titlelabel.text = model.firmInfo?.entityName ?? ""
            self?.navigationController?.pushViewController(locationVc, animated: true)
        }
        
        companyListView.websiteBlock = { [weak self] model in
            let pageUrl = model.firmInfo?.website ?? ""
            if !pageUrl.isEmpty {
                self?.pushWebPage(from: pageUrl)
            }else {
                ToastViewConfig.showToast(message: "无法跳转,链接非法!")
            }
            
        }
        
        companyListView.peopleBlock = { [weak self] model in
            guard let self = self else { return }
            let legalName = model.legalPerson?.legalName ?? ""
            let personNumber = model.legalPerson?.personNumber ?? ""
            let peopleDetailVc = PeopleBothViewController()
            peopleDetailVc.enityId.accept(personNumber)
            peopleDetailVc.peopleName.accept(legalName)
            self.navigationController?.pushViewController(peopleDetailVc, animated: true)
        }
        
        //点击电话回调
        companyListView.phoneBlock = { [weak self] model in
            
        }
        
        //企业ID回调
        companyListView.entityIdBlock = { [weak self] entityId, entityName in
            let companyDetailVc = CompanyBothViewController()
            companyDetailVc.enityId.accept(entityId)
            companyDetailVc.companyName.accept(entityName)
            self?.navigationController?.pushViewController(companyDetailVc, animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("企业===============企业")
        let group = DispatchGroup()
        var lastSearchSuccess = false
        var browsingHistorySuccess = false
        var hotWordsSuccess = false
        //最近搜索
        group.enter()
        getlastSearch { success in
            lastSearchSuccess = success
            group.leave()
        }
        //浏览历史
        group.enter()
        getBrowsingHistory { success in
            browsingHistorySuccess = success
            group.leave()
        }
        //热搜
        group.enter()
        getHotWords { success in
            hotWordsSuccess = success
            group.leave()
        }
        
        // 所有任务完成后的通知
        group.notify(queue: .main) {
            print("所有数据加载完成，通知你！")
            if lastSearchSuccess && browsingHistorySuccess && hotWordsSuccess {
                print("所有接口请求成功！")
            } else {
                print("部分接口请求失败。")
            }
        }
    }
}

extension SearchCompanyViewController {
    
    //最近搜索
    private func getlastSearch(completion: @escaping (Bool) -> Void) {
        let man = RequestManager()
        let dict = ["searchType": "1", "moduleId": "01"]
        man.requestAPI(params: dict, pageUrl: "/operation/searchRecord/query", method: .post) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let rows = success.data?.data, let code = success.code, code == 200  {
                    reloadSearchUI(data: rows)
                    completion(true)
                }else {
                    completion(false)
                }
                break
            case .failure(_):
                completion(false)
                break
            }
        }
    }
    
    //最近搜索UI刷新
    func reloadSearchUI(data: [rowsModel]) {
        var strArray: [String] = []
        if data.count > 0 {
            for model in data {
                strArray.append(model.searchContent ?? "")
            }
            self.companyView.searchView.tagListView.removeAllTags()
            self.companyView.searchView.tagListView.addTags(strArray)
            self.companyView.searchView.isHidden = false
            self.companyView.layoutIfNeeded()
            let height = self.companyView.searchView.tagListView.frame.height
            self.companyView.searchView.snp.updateConstraints { make in
                make.height.equalTo(30 + height + 20)
            }
        } else {
            self.companyView.searchView.isHidden = true
            self.companyView.searchView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        self.companyView.layoutIfNeeded()
    }
    
    //浏览历史
    private func getBrowsingHistory(completion: @escaping (Bool) -> Void) {
        let man = RequestManager()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber, "viewrecordtype": "1", "moduleId": "01", "pageNum": "1", "pageSize": "20"]
        man.requestAPI(params: dict, pageUrl: "/operation/clientbrowsecb/selectBrowserecord", method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                guard let self = self else { return }
                if let rows = success.data?.rows, let code = success.code, code == 200 {
                    readHistoryUI(data: rows)
                    completion(true)
                }else {
                    completion(false)
                }
                break
            case .failure(_):
                completion(false)
                break
            }
        }
    }
    
    //UI刷新
    func readHistoryUI(data: [rowsModel]) {
        for (index, model) in data.enumerated() {
            let listView = CommonSearchListView()
            listView.block = {
                
            }
            listView.nameLabel.text = model.firmname ?? ""
            listView.timeLabel.text = model.createhourtime ?? ""
            listView.icon.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.firmname ?? "", size: (22, 22), bgColor: .random(), textColor: .white))
            self.companyView.historyView.addSubview(listView)
            listView.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(SCREEN_WIDTH)
                make.left.equalToSuperview()
                make.top.equalTo(self.companyView.historyView.lineView.snp.bottom).offset(40 * index)
            }
        }
        
        self.companyView.historyView.snp.updateConstraints { make in
            if data.count != 0 {
                self.companyView.historyView.isHidden = false
                make.height.equalTo((data.count) * 40 + 30)
            } else {
                self.companyView.historyView.isHidden = true
                make.height.equalTo(0)
            }
        }
        self.companyView.layoutIfNeeded()
    }
    
    //热搜
    private func getHotWords(completion: @escaping (Bool) -> Void) {
        let man = RequestManager()
        let dict = ["moduleId": "01"]
        man.requestAPI(params: dict,
                       pageUrl: browser_hotwords,
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data, let code = success.code, code == 200 {
                    self.hotWordsArray.accept(model.data ?? [])
                    hotsWordsUI(data: model.data ?? [])
                    completion(true)
                }else {
                    completion(false)
                }
                break
            case .failure(_):
                completion(false)
                break
            }
        }
    }
    
    //UI刷新
    func hotsWordsUI(data: [rowsModel]) {
        self.companyView.hotWordsView.isHidden = false
        for (index, model) in data.enumerated() {
            let listView = CommonSearchListView()
            listView.block = {
                
            }
            listView.nameLabel.text = model.name ?? ""
            listView.icon.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.name ?? "", size: (22, 22), bgColor: .random(), textColor: .white))
            self.companyView.hotWordsView.addSubview(listView)
            listView.snp.updateConstraints { make in
                make.height.equalTo(40)
                make.left.right.equalToSuperview()
                make.top.equalTo(self.companyView.hotWordsView.lineView.snp.bottom).offset(40 * index)
            }
        }
        
        self.companyView.hotWordsView.snp.updateConstraints { make in
            if data.count != 0 {
                self.companyView.hotWordsView.isHidden = false
                make.height.equalTo((data.count) * 40 + 30)
            } else {
                self.companyView.hotWordsView.isHidden = true
                make.height.equalTo(0)
            }
        }
        self.companyView.layoutIfNeeded()
    }
    
    //删除最近搜索
    private func deleteSearchInfo() {
        ShowAlertManager.showAlert(title: "删除", message: "是否需要删除最近搜索?", confirmAction: {
            let man = RequestManager()
            let dict = ["searchType": "2", "moduleId": "01"]
            man.requestAPI(params: dict, pageUrl: "/operation/searchRecord/clear", method: .post) { result in
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        ToastViewConfig.showToast(message: "删除成功!")
                        self.companyView.searchView.isHidden = true
                        self.companyView.searchView.snp.updateConstraints({ make in
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
            let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
            let dict = ["customernumber": customernumber, "moduleId": "01", "viewrecordtype": "1"]
            man.requestAPI(params: dict, pageUrl: "/operation/clientbrowsecb/deleteBrowseRecord", method: .get) { result in
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        ToastViewConfig.showToast(message: "删除成功!")
                        self.companyView.historyView.isHidden = true
                        self.companyView.historyView.snp.updateConstraints({ make in
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
    
    //搜索企业列表
    private func searchListInfo() {
        let dict = ["keywords": searchWords ?? "",
                    "matchType": 1,
                    "entityIndustry": entityIndustry,
                    "entityArea": entityArea,
                    "pageIndex": pageIndex,
                    "pageSize": 20] as [String : Any]
        let man = RequestManager()
        man.requestAPI(params: dict, pageUrl: "/firminfo/company/search", method: .get) { [weak self] result in
            self?.companyListView.tableView.mj_header?.endRefreshing()
            self?.companyListView.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let self = self,
                   let model = success.data,
                   let code = success.code,
                   code == 200, let total = model.pageMeta?.totalNum {
                    self.companyView.isHidden = true
                    self.companyListView.isHidden = false
                    if pageIndex == 1 {
                        pageIndex = 1
                        self.getlastSearch { success in
                            
                        }
                        self.allArray.removeAll()
                    }
                    pageIndex += 1
                    let pageData = model.pageData ?? []
                    self.allArray.append(contentsOf: pageData)
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
                        self.noNetView.removeFromSuperview()
                    }else {
                        self.addNodataView(from: self.companyListView.whiteView)
                    }
                    if self.allArray.count != total {
                        self.companyListView.tableView.mj_footer?.isHidden = false
                    }else {
                        self.companyListView.tableView.mj_footer?.isHidden = true
                    }
                    self.companyListView.dataModel.accept(model)
                    self.companyListView.dataModelArray.accept(self.allArray)
                    self.companyListView.searchWordsRelay.accept(self.searchWordsRelay.value)
                    self.companyListView.tableView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}

extension SearchCompanyViewController: JXPagingViewListViewDelegate {
    
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
