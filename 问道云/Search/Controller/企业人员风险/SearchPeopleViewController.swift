//
//  SearchPeopleViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/7.
//  人员搜索

import UIKit
import JXPagingView
import RxRelay
import RxSwift
import MJRefresh
import DropMenuBar

class SearchPeopleViewController: WDBaseViewController {
    
    var completeBlock: (() -> Void)?
    
    //城市数据
    var regionModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    
    //行业数据
    var industryModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    
    //搜索参数
    var pageIndex: Int = 1
    var entityArea: String = ""//地区
    var entityIndustry: String = ""//行业
    
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
    
    lazy var peopleView: OneCompanyView = {
        let peopleView = OneCompanyView()
        return peopleView
    }()
    
    lazy var twoPeopleListView: TwoPeopleListView = {
        let twoPeopleListView = TwoPeopleListView()
        twoPeopleListView.isHidden = true
        return twoPeopleListView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(peopleView)
        view.addSubview(twoPeopleListView)
        peopleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        twoPeopleListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        //删除最近搜索
        self.peopleView.searchView.deleteBtn
            .rx
            .tap.subscribe(onNext: { [weak self] in
                self?.deleteSearchInfo()
        }).disposed(by: disposeBag)
        
        //删除浏览历史
        self.peopleView.historyView.deleteBtn
            .rx
            .tap.subscribe(onNext: { [weak self] in
                self?.deleteHistoryInfo()
        }).disposed(by: disposeBag)
        
        //点击最近搜索
        self.peopleView.lastSearchTextBlock = { [weak self] searchStr in
            self?.lastSearchTextBlock?(searchStr)
        }
        
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
                    self.peopleView.isHidden = false
                    self.twoPeopleListView.isHidden = true
                }
            }).disposed(by: disposeBag)
        
        
        //添加下拉刷新
        self.twoPeopleListView.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.pageIndex = 1
            self.searchListInfo()
        })
        
        //添加上拉加载更多
        self.twoPeopleListView.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.searchListInfo()
        })
        
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
        self.twoPeopleListView.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0.5)
            make.left.right.equalToSuperview()
            make.height.equalTo(33.5)
        }
        
        twoPeopleListView.peopleBlock = { model in
            let peopleDetailVc = PeopleBothViewController()
            peopleDetailVc.enityId.accept(model.personId ?? "")
            peopleDetailVc.peopleName.accept(model.personName ?? "")
            self.navigationController?.pushViewController(peopleDetailVc, animated: true)
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("人员===============人员")
        let group = DispatchGroup()
        //最近搜索
        ViewHud.addLoadView()
        group.enter()
        getlastSearch { success in
            group.leave()
        }
        //浏览历史
        group.enter()
        getBrowsingHistory { success in
            group.leave()
        }
        //热搜
        group.enter()
        getHotWords { success in
            group.leave()
        }
        
        // 所有任务完成后的通知
        group.notify(queue: .main) {
            ViewHud.hideLoadView()
            self.completeBlock?()
        }
    }
}

extension SearchPeopleViewController {
    
    //最近搜索
    private func getlastSearch(completion: @escaping (Bool) -> Void) {
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["searchType": "2",
                    "moduleId": "02"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/searchRecord/query",
                       method: .post) { [weak self] result in
            ViewHud.hideLoadView()
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let rows = success.data?.data {
                    reloadSearchUI(data: rows)
                }
                completion(true)
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
            self.peopleView.searchView.tagListView.removeAllTags()
            self.peopleView.searchView.tagListView.addTags(strArray)
            self.peopleView.searchView.isHidden = false
            self.peopleView.layoutIfNeeded()
            let height = self.peopleView.searchView.tagListView.frame.height
            self.peopleView.searchView.snp.updateConstraints { make in
                make.height.equalTo(30 + height + 20)
            }
        } else {
            self.peopleView.searchView.isHidden = true
            self.peopleView.searchView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        self.peopleView.layoutIfNeeded()
    }
    
    //浏览历史
    private func getBrowsingHistory(completion: @escaping (Bool) -> Void) {
        let man = RequestManager()
        ViewHud.addLoadView()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber,
                    "viewrecordtype": "2",
                    "moduleId": "02",
                    "pageNum": "1",
                    "pageSize": "20"]
        man.requestAPI(params: dict, pageUrl: "/operation/clientbrowsecb/selectBrowserecord", method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                guard let self = self else { return }
                if let rows = success.data?.rows {
                    readHistoryUI(data: rows)
                }
                completion(true)
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
            listView.block = { [weak self] in
                guard let self = self else { return }
                let peopleDetailVc = PeopleBothViewController()
                let peopleID = model.personnumber ?? ""
                let peopleName = model.personname ?? ""
                peopleDetailVc.enityId.accept(peopleID)
                peopleDetailVc.peopleName.accept(peopleName)
                self.navigationController?.pushViewController(peopleDetailVc, animated: true)
            }
            listView.nameLabel.text = model.personname ?? ""
            listView.timeLabel.text = model.createhourtime ?? ""
            listView.icon.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.firmname ?? "", size: (22, 22)))
            self.peopleView.historyView.addSubview(listView)
            listView.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(SCREEN_WIDTH)
                make.left.equalToSuperview()
                make.top.equalTo(self.peopleView.historyView.lineView.snp.bottom).offset(40 * index)
            }
        }
        
        self.peopleView.historyView.snp.updateConstraints { make in
            if data.count != 0 {
                self.peopleView.historyView.isHidden = false
                make.height.equalTo((data.count) * 40 + 30)
            } else {
                self.peopleView.historyView.isHidden = true
                make.height.equalTo(0)
            }
        }
        self.peopleView.layoutIfNeeded()
    }
    
    //热搜
    private func getHotWords(completion: @escaping (Bool) -> Void) {
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["moduleId": "02"]
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
                completion(true)
                break
            case .failure(_):
                completion(false)
                break
            }
        }
    }
    
    //UI刷新
    func hotsWordsUI(data: [rowsModel]) {
        for (index, model) in data.enumerated() {
            let listView = CommonSearchListView()
            listView.block = { [weak self] in
                guard let self = self else { return }
                let peopleDetailVc = PeopleBothViewController()
                let peopleID = model.eid ?? ""
                let peopleName = model.name ?? ""
                peopleDetailVc.enityId.accept(peopleID)
                peopleDetailVc.peopleName.accept(peopleName)
                self.navigationController?.pushViewController(peopleDetailVc, animated: true)
            }
            listView.nameLabel.text = model.name ?? ""
            listView.icon.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.name ?? "", size: (22, 22)))
            self.peopleView.hotWordsView.addSubview(listView)
            listView.snp.updateConstraints { make in
                make.height.equalTo(40)
                make.left.right.equalToSuperview()
                make.top.equalTo(self.peopleView.hotWordsView.lineView.snp.bottom).offset(40 * index)
            }
        }
        
        self.peopleView.hotWordsView.snp.updateConstraints { make in
            if data.count != 0 {
                self.peopleView.hotWordsView.isHidden = false
                make.height.equalTo((data.count) * 40 + 30)
            } else {
                self.peopleView.hotWordsView.isHidden = true
                make.height.equalTo(0)
            }
        }
        self.peopleView.layoutIfNeeded()
    }
    
    //删除最近搜索
    private func deleteSearchInfo() {
        ShowAlertManager.showAlert(title: "删除", message: "是否需要删除最近搜索?", confirmAction: {
            let man = RequestManager()
        ViewHud.addLoadView()
            let dict = ["searchType": "1",
                        "moduleId": "02"]
            man.requestAPI(params: dict,
                           pageUrl: "/operation/searchRecord/clear",
                           method: .post) { result in
                ViewHud.hideLoadView()
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        ToastViewConfig.showToast(message: "删除成功!")
                        self.peopleView.searchView.isHidden = true
                        self.peopleView.searchView.snp.updateConstraints({ make in
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
            let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
            let dict = ["customernumber": customernumber,
                        "moduleId": "02",
                        "viewrecordtype": "2"]
            man.requestAPI(params: dict,
                           pageUrl: "/operation/clientbrowsecb/deleteBrowseRecord",
                           method: .get) { result in
                ViewHud.hideLoadView()
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        ToastViewConfig.showToast(message: "删除成功!")
                        self.peopleView.historyView.isHidden = true
                        self.peopleView.historyView.snp.updateConstraints({ make in
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
    
    //搜索人员列表
    private func searchListInfo() {
        let dict = ["keywords": searchWords ?? "",
                    "entityIndustry": entityIndustry,
                    "entityArea": entityArea,
                    "pageNum": pageIndex,
                    "pageSize": 20] as [String : Any]
        let man = RequestManager()
        ViewHud.addLoadView()
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/person/search",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            self?.twoPeopleListView.tableView.mj_header?.endRefreshing()
            self?.twoPeopleListView.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let self = self,
                   let model = success.data,
                   let code = success.code,
                   code == 200, let total = model.total {
                    self.peopleView.isHidden = true
                    self.twoPeopleListView.isHidden = false
                    if pageIndex == 1 {
                        pageIndex = 1
                        self.getlastSearch { success in
                            
                        }
                        self.allArray.removeAll()
                    }
                    pageIndex += 1
                    let pageData = model.items ?? []
                    self.allArray.append(contentsOf: pageData)
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
                        self.noNetView.removeFromSuperview()
                    }else {
                        self.addNodataView(from: self.twoPeopleListView.whiteView)
                    }
                    if self.allArray.count != total {
                        self.twoPeopleListView.tableView.mj_footer?.isHidden = false
                    }else {
                        self.twoPeopleListView.tableView.mj_footer?.isHidden = true
                    }
                    self.twoPeopleListView.dataModel.accept(model)
                    self.twoPeopleListView.dataModelArray.accept(self.allArray)
                    self.twoPeopleListView.searchWordsRelay.accept(self.searchWordsRelay.value)
                    self.twoPeopleListView.tableView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}

extension SearchPeopleViewController: JXPagingViewListViewDelegate {
    
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
