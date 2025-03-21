//
//  SearchCompanyViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/7.
//  企业搜索

import UIKit
import MapKit
import RxRelay
import RxSwift
import MJRefresh
import DropMenuBar
import JXPagingView
import SkeletonView
import TYAlertController

class SearchCompanyViewController: WDBaseViewController {
    
    private var man = RequestManager()
    
    var completeBlock: (() -> Void)?
    
    //人员查看更多
    var moreBtnBlock: (() -> Void)?
    
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
    
    lazy var oneView: OneCompanyView = {
        let oneView = OneCompanyView()
        oneView.isHidden = false
        return oneView
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
        view.addSubview(oneView)
        oneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(companyListView)
        companyListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        companyListView.tableView.isSkeletonable = true
        companyListView.tableView.showAnimatedGradientSkeleton() // 显示骨架屏
        
        companyListView.moreBtnBlock = { [weak self] in
            self?.moreBtnBlock?()
        }
        //删除最近搜索
        self.oneView.searchView.deleteBtn
            .rx
            .tap.subscribe(onNext: { [weak self] in
                self?.deleteSearchInfo()
            }).disposed(by: disposeBag)
        //删除浏览历史
        self.oneView.historyView.deleteBtn
            .rx
            .tap.subscribe(onNext: { [weak self] in
                self?.deleteHistoryInfo()
            }).disposed(by: disposeBag)
        
        //点击最近搜索
        self.oneView.lastSearchTextBlock = { [weak self] searchStr in
            self?.lastSearchTextBlock?(searchStr)
            self?.searchWords = searchStr
        }
        
        //添加下拉筛选
        let regionMenu = MenuAction(title: "地区", style: .typeList)!
        
        self.regionModelArray.asObservable().subscribe(onNext: { [weak self] modelArray in
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
            make.height.equalTo(34)
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
        
        companyListView.addressBlock = { [weak self] model in
            let latitude = Double(model.orgInfo?.regAddr?.lat ?? "0.0") ?? 0.0
            let longitude = Double(model.orgInfo?.regAddr?.lng ?? "0.0") ?? 0.0
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let locationVc = CompanyLocationViewController(location: location)
            locationVc.name = model.orgInfo?.orgName ?? ""
            self?.navigationController?.pushViewController(locationVc, animated: true)
        }
        
        companyListView.websiteBlock = { [weak self] model in
            let pageUrl = model.orgInfo?.website ?? ""
            self?.pushWebPage(from: pageUrl)
        }
        
        //这里不仅仅是可以点击人员了....还有可能是企业
        companyListView.peopleBlock = { [weak self] model in
            guard let self = self else { return }
            let leaderList = model.leaderVec?.leaderList ?? []
            if leaderList.count > 1 {
                let popMoreListView = PopMoreLegalListView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 220))
                popMoreListView.descLabel.text = "\(model.leaderVec?.leaderTypeName ?? "")\(leaderList.count)"
                popMoreListView.dataList = leaderList
                let alertVc = TYAlertController(alert: popMoreListView, preferredStyle: .alert)!
                popMoreListView.closeBlock = {
                    self.dismiss(animated: true)
                }
                popMoreListView.clickBlock = { [weak self] model in
                    self?.dismiss(animated: true, completion: {
                        self?.pushPageWithModel(from: model)
                    })
                }
                self.present(alertVc, animated: true)
            }else {
                self.dismiss(animated: true) {
                    if let peopleModel = model.leaderVec?.leaderList?.first {
                        self.pushPageWithModel(from: peopleModel)
                    }
                }
            }
        }
        
        //点击电话回调
        companyListView.phoneBlock = { [weak self] model in
            
            //            let popMoreListView = PopShareholdePhoneView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 220))
            //            let leaderList = model.phone ?? []
            //            popMoreListView.descLabel.text = "电话号码\(leaderList.count)"
            //            popMoreListView.dataList = leaderList
            //            let alertVc = TYAlertController(alert: popMoreListView, preferredStyle: .alert)!
            //            popMoreListView.closeBlock = {
            //                self?.dismiss(animated: true)
            //            }
            //            self?.present(alertVc, animated: true)
            
            self?.makePhoneCall(phoneNumber: model.orgInfo?.phone ?? "")
        }
        
        //企业ID回调
        companyListView.entityIdBlock = { [weak self] model in
            let companyDetailVc = CompanyBothViewController()
            let enityId = model.orgInfo?.orgId ?? ""
            let companyName = model.orgInfo?.orgName ?? ""
            companyDetailVc.enityId.accept(enityId)
            companyDetailVc.companyName.accept(companyName)
            companyDetailVc.refreshBlock = { [weak self] index in
                guard let self = self else { return }
                self.pageIndex = 1
                self.searchListInfo()
            }
            self?.navigationController?.pushViewController(companyDetailVc, animated: true)
        }
        
        //网络请求
        getDataInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("企业===============企业")
    }
}

/** 网络数据请求 */
extension SearchCompanyViewController {
    
    private func getDataInfo() {
        //更新搜索文字
        self.searchWordsRelay
            .debounce(.milliseconds(600),
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
                    self.oneView.isHidden = false
                    self.companyListView.isHidden = true
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
                    //
                    self.completeBlock?()
                }
            }).disposed(by: disposeBag)
    }
    
    //最近搜索
    private func getlastSearch(completion: @escaping () -> Void) {
        let man = RequestManager()
        let dict = ["searchType": "1",
                    "moduleId": "01"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/searchRecord/query",
                       method: .post) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let rows = success.data?.data, let code = success.code, code == 200  {
                    reloadSearchUI(data: rows)
                }
                break
            case .failure(_):
                
                break
            }
            completion()
        }
    }
    
    //最近搜索UI刷新
    func reloadSearchUI(data: [rowsModel]) {
        var strArray: [String] = []
        if data.count > 0 {
            for model in data {
                strArray.append(model.searchContent ?? "")
            }
            self.oneView.searchView.tagListView.removeAllTags()
            self.oneView.searchView.tagListView.addTags(strArray)
            self.oneView.searchView.isHidden = false
            self.oneView.layoutIfNeeded()
            let height = self.oneView.searchView.tagListView.frame.height
            self.oneView.searchView.snp.updateConstraints { make in
                make.height.equalTo(30 + height + 20)
            }
        } else {
            self.oneView.searchView.isHidden = true
            self.oneView.searchView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        self.oneView.layoutIfNeeded()
    }
    
    //浏览历史
    private func getBrowsingHistory(completion: @escaping () -> Void) {
        let man = RequestManager()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber,
                    "viewrecordtype": "1",
                    "moduleId": "01",
                    "pageNum": "1",
                    "pageSize": "20"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/clientbrowsecb/selectBrowserecord",
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                guard let self = self else { return }
                if let rows = success.data?.rows, let code = success.code, code == 200 {
                    readHistoryUI(data: rows)
                }
                break
            case .failure(_):
                
                break
            }
            completion()
        }
    }
    
    //UI刷新
    func readHistoryUI(data: [rowsModel]) {
        for (index, model) in data.enumerated() {
            let listView = CommonSearchListView()
            listView.block = { [weak self] in
                guard let self = self else { return }
                let companyDetailVc = CompanyBothViewController()
                let enityId = model.firmnumber ?? ""
                let companyName = model.firmname ?? ""
                companyDetailVc.enityId.accept(enityId)
                companyDetailVc.companyName.accept(companyName)
                self.navigationController?.pushViewController(companyDetailVc, animated: true)
            }
            listView.nameLabel.text = model.firmname ?? ""
            listView.timeLabel.text = model.createhourtime ?? ""
            listView.icon.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.firmname ?? "", size: (22, 22), bgColor: UIColor.init(cssStr: model.logoColor ?? "")!))
            self.oneView.historyView.addSubview(listView)
            listView.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(SCREEN_WIDTH)
                make.left.equalToSuperview()
                make.top.equalTo(self.oneView.historyView.lineView.snp.bottom).offset(40 * index)
            }
        }
        
        self.oneView.historyView.snp.updateConstraints { make in
            if data.count != 0 {
                self.oneView.historyView.isHidden = false
                make.height.equalTo((data.count) * 40 + 30)
            } else {
                self.oneView.historyView.isHidden = true
                make.height.equalTo(0)
            }
        }
        self.oneView.layoutIfNeeded()
    }
    
    //热搜
    private func getHotWords(completion: @escaping () -> Void) {
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
                }
                break
            case .failure(_):
                
                break
            }
            completion()
        }
    }
    
    //UI刷新
    func hotsWordsUI(data: [rowsModel]) {
        self.oneView.hotWordsView.isHidden = false
        for (index, model) in data.enumerated() {
            let listView = CommonSearchListView()
            listView.block = { [weak self] in
                guard let self = self else { return }
                let companyDetailVc = CompanyBothViewController()
                let enityId = model.eid ?? ""
                let companyName = model.name ?? ""
                companyDetailVc.enityId.accept(enityId)
                companyDetailVc.companyName.accept(companyName)
                self.navigationController?.pushViewController(companyDetailVc, animated: true)
            }
            listView.nameLabel.text = model.name ?? ""
            listView.icon.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.name ?? "", size: (22, 22), bgColor: UIColor.init(cssStr: model.logoColor ?? "")!))
            self.oneView.hotWordsView.addSubview(listView)
            listView.snp.updateConstraints { make in
                make.height.equalTo(40)
                make.left.right.equalToSuperview()
                make.top.equalTo(self.oneView.hotWordsView.lineView.snp.bottom).offset(40 * index)
            }
        }
        
        self.oneView.hotWordsView.snp.updateConstraints { make in
            if data.count != 0 {
                self.oneView.hotWordsView.isHidden = false
                make.height.equalTo((data.count) * 40 + 30)
            } else {
                self.oneView.hotWordsView.isHidden = true
                make.height.equalTo(0)
            }
        }
        self.oneView.layoutIfNeeded()
    }
    
    //删除最近搜索
    private func deleteSearchInfo() {
        ShowAlertManager.showAlert(title: "删除", message: "是否需要删除最近搜索?", confirmAction: {
            let man = RequestManager()
            
            let dict = ["searchType": "2", "moduleId": "01"]
            man.requestAPI(params: dict,
                           pageUrl: "/operation/searchRecord/clear",
                           method: .post) { result in
                
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        ToastViewConfig.showToast(message: "删除成功")
                        self.oneView.searchView.isHidden = true
                        self.oneView.searchView.snp.updateConstraints({ make in
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
            let dict = ["customernumber": customernumber,
                        "moduleId": "01",
                        "viewrecordtype": "1"]
            man.requestAPI(params: dict,
                           pageUrl: "/operation/clientbrowsecb/deleteBrowseRecord",
                           method: .get) { result in
                
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        ToastViewConfig.showToast(message: "删除成功")
                        self.oneView.historyView.isHidden = true
                        self.oneView.historyView.snp.updateConstraints({ make in
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
        let dict = ["keyword": searchWords ?? "",
                    "matchType": 1,
                    "industryType": entityIndustry,
                    "region": entityArea,
                    "pageIndex": pageIndex,
                    "pageSize": 20] as [String : Any]
        
        man.requestAPI(params: dict,
                       pageUrl: "/entity/v2/org-list",
                       method: .get) { [weak self] result in
            
            self?.companyListView.tableView.mj_header?.endRefreshing()
            self?.companyListView.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let self = self,
                   let model = success.data,
                   let code = success.code,
                   code == 200,
                   let total = model.pageMeta?.totalNum {
                    self.oneView.isHidden = true
                    self.companyListView.isHidden = false
                    if self.pageIndex == 1 {
                        self.pageIndex = 1
                        self.allArray.removeAll()
                    }
                    self.pageIndex += 1
                    let pageData = model.pageData ?? []
                    self.allArray.append(contentsOf: pageData)
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
                    }else {
                        self.addNodataView(from: self.companyListView.whiteView)
                    }
                    if self.allArray.count != total {
                        self.companyListView.tableView.mj_footer?.isHidden = false
                    }else {
                        self.companyListView.tableView.mj_footer?.isHidden = true
                    }
                    self.companyListView.dataModel = model
                    self.companyListView.dataModelArray = self.allArray
                    self.companyListView.searchWordsRelay.accept(self.searchWordsRelay.value)
                    DispatchQueue.main.asyncAfter(delay: 0.15) {
                        self.companyListView.tableView.hideSkeleton()
                        self.companyListView.tableView.reloadData()
                    }
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
