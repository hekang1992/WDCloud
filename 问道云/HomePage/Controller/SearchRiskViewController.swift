//
//  SearchRiskViewController.swift
//  问道云
//
//  Created by 何康 on 2025/1/7.
//  风险搜索

import UIKit
import JXPagingView
import RxRelay
import MJRefresh
import RxSwift

class SearchRiskViewController: WDBaseViewController {
    
    //城市数据
    var regionModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    
    //行业数据
    var industryModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    
    //搜索参数
    var pageIndex: Int = 1
    var entityArea: String = ""//地区
    var entityIndustry: String = ""//行业
    var type: String = ""
    
    var allArray: [itemsModel] = []//加载更多
    
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
    
    lazy var twoRiskListView: TwoRiskListView = {
        let twoRiskListView = TwoRiskListView()
        twoRiskListView.isHidden = true
        return twoRiskListView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(riskView)
        view.addSubview(twoRiskListView)
        riskView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        twoRiskListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        
        //搜索
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
                    self.riskView.isHidden = false
                    self.twoRiskListView.isHidden = true
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //最近搜索
        getlastSearch()

        //浏览历史
        getBrowsingHistory()
        
        //热搜
        getHotWords()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("风险===============风险")
    }
}

extension SearchRiskViewController {
    
    //最近搜索
    private func getlastSearch() {
        let man = RequestManager()
        let dict = ["searchType": "", "moduleId": "05"]
        man.requestAPI(params: dict, pageUrl: "/operation/searchRecord/query", method: .post) { [weak self] result in
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
    private func getBrowsingHistory() {
        let man = RequestManager()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber":customernumber ,"viewrecordtype": "", "moduleId": "05", "pageNum": "1", "pageSize": "20"]
        man.requestAPI(params: dict, pageUrl: "/operation/clientbrowsecb/selectBrowserecord", method: .get) { [weak self] result in
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
    private func getHotWords() {
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
        }
    }
    
    //UI刷新
    func hotsWordsUI(data: [rowsModel]) {
        for (index, model) in data.enumerated() {
            let listView = CommonSearchListView()
            listView.block = {
                
            }
            listView.nameLabel.text = model.name ?? ""
            listView.icon.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.name ?? "", size: (22, 22), bgColor: .random(), textColor: .white))
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
            let dict = ["searchType": "", "moduleId": "05"]
            man.requestAPI(params: dict, pageUrl: "/operation/searchRecord/clear", method: .post) { result in
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        ToastViewConfig.showToast(message: "删除成功!")
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
            let customerNumber = GetSaveLoginInfoConfig.getCustomerNumber()
            let dict = ["moduleId": "05", "viewrecordtype": "", "customerNumber": customerNumber]
            man.requestAPI(params: dict, pageUrl: "/operation/clientbrowsecb/deleteBrowseRecord", method: .get) { result in
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        ToastViewConfig.showToast(message: "删除成功!")
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
    
    //风险列表数据
    //搜索人员列表
    private func searchListInfo() {
        let dict = ["keywords": searchWords ?? "",
                    "entityIndustry": entityIndustry,
                    "entityArea": entityArea,
                    "pageNum": pageIndex,
                    "pageSize": "20",
                    "type": type] as [String : Any]
        let man = RequestManager()
        man.requestAPI(params: dict, pageUrl: "/riskmonitor/cooperation/getRiskData", method: .get) { [weak self] result in
            self?.twoRiskListView.tableView.mj_header?.endRefreshing()
            self?.twoRiskListView.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let self = self,
                   let model = success.data,
                   let code = success.code,
                   code == 200, let total = model.entityData?.total {
                    self.riskView.isHidden = true
                    self.twoRiskListView.isHidden = false
                    if pageIndex == 1 {
                        pageIndex = 1
                        self.getlastSearch()
                        self.allArray.removeAll()
                    }
                    pageIndex += 1
                    let pageData = model.entityData?.items ?? []
                    self.allArray.append(contentsOf: pageData)
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
                        self.noNetView.removeFromSuperview()
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
                }
                break
            case .failure(_):
                break
            }
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
