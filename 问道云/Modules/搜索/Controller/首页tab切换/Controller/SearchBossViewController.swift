//
//  SearchBossViewController.swift
//  问道云
//
//  Created by 何康 on 2025/3/31.
//  首页搜索人员

import UIKit
import MapKit
import RxRelay
import RxSwift
import MJRefresh
import DropMenuBar
import JXPagingView
import SkeletonView
import TYAlertController

class SearchBossViewController: WDBaseViewController {
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()
    
    lazy var oneView: CommonHotsView = {
        let oneView = CommonHotsView()
        return oneView
    }()
    
    //搜索list列表页面
    lazy var twoPeopleListView: TwoPeopleListView = {
        let twoPeopleListView = TwoPeopleListView()
        twoPeopleListView.isHidden = true
        return twoPeopleListView
    }()
    
    var completeBlock: (() -> Void)?
    
    //人员查看更多
    var moreBtnBlock: (() -> Void)?
    
    private var man = RequestManager()
    //浏览历史
    var historyArray: [rowsModel] = []
    //热门搜索
    var hotsArray: [rowsModel] = []
    //总数组
    var modelArray: [[rowsModel]] = []
    
    //城市数据
    var regionModelArray = BehaviorRelay<[rowsModel]>(value: [])
    
    //行业数据
    var industryModelArray = BehaviorRelay<[rowsModel]>(value: [])
    
    //参数
    var pageIndex: Int = 1
    var keyword: String = ""//搜索的文字
    var entityArea: String = ""//地区
    var entityIndustry: String = ""//行业
    var allArray: [itemsModel] = []//加载更多
    
    //搜索的文字
    var searchWords = BehaviorRelay<String?>(value: nil)
    
    //点击最近搜索回调
    var lastSearchTextBlock: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(oneView)
        oneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(twoPeopleListView)
        twoPeopleListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        twoPeopleListView.tableView.isSkeletonable = true
        twoPeopleListView.tableView.showAnimatedGradientSkeleton()
        
        self.searchWords
            .asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self, let text = text else { return }
                //取消请求
                man.cancelLastRequest()
                if !text.isEmpty, text.count >= 2 {
                    self.oneView.isHidden = true
                    self.twoPeopleListView.isHidden = false
                    self.keyword = text
                    self.searchListInfo()
                }else if !text.isEmpty, text.count < 2 {
                    self.oneView.isHidden = false
                    self.twoPeopleListView.isHidden = true
                    self.allArray.removeAll()
                    //获取热搜等数据
                    getHotsSearchInfo()
                }else if text.isEmpty {
                    self.oneView.isHidden = false
                    self.twoPeopleListView.isHidden = true
                    self.allArray.removeAll()
                }
            }).disposed(by: disposeBag)
        
        twoPeopleListView.peopleBlock = { [weak self] model in
            guard let self = self else { return }
            let peopleDetailVc = PeopleBothViewController()
            peopleDetailVc.personId.accept(model.personId ?? "")
            peopleDetailVc.peopleName.accept(model.personName ?? "")
            self.navigationController?.pushViewController(peopleDetailVc, animated: true)
        }
        
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getHotsSearchInfo()
    }
    
}

extension SearchBossViewController {
    
    private func setupUI() {
        //添加下拉筛选
        let regionMenu = MenuAction(title: "地区", style: .typeList)!
        
        self.regionModelArray.asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            let regionArray = getThreeRegionInfo(from: modelArray)
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
            let industryArray = getThreeIndustryInfo(from: modelArray)
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
            make.top.equalToSuperview().offset(1)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
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
        
        //删除最近搜索
        oneView.deleteBlock = {
            ShowAlertManager.showAlert(title: "删除", message: "是否确定删除最近搜索?", confirmAction: {
                ViewHud.addLoadView()
                let man = RequestManager()
                let dict = ["moduleId": "02"]
                man.requestAPI(params: dict,
                               pageUrl: "/operation/searchRecord/clear",
                               method: .post) { [weak self] result in
                    ViewHud.hideLoadView()
                    switch result {
                    case .success(let success):
                        if success.code == 200 {
                            ToastViewConfig.showToast(message: "删除成功")
                            self?.oneView.bgView.isHidden = true
                            self?.oneView.bgView.snp.remakeConstraints({ make in
                                make.top.equalToSuperview().offset(1)
                                make.left.equalToSuperview()
                                make.width.equalTo(SCREEN_WIDTH)
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
        oneView.deleteHistoryBlock = {
            ShowAlertManager.showAlert(title: "删除", message: "是否确定删除浏览历史?", confirmAction: {
                ViewHud.addLoadView()
                let man = RequestManager()
                let dict = ["moduleId": "02"]
                man.requestAPI(params: dict,
                               pageUrl: "/operation/view-record/del",
                               method: .post) { [weak self] result in
                    ViewHud.hideLoadView()
                    switch result {
                    case .success(let success):
                        if success.code == 200 {
                            ToastViewConfig.showToast(message: "删除成功")
                            self?.historyArray.removeAll()
                            self?.oneView.modelArray = [self?.historyArray ?? [], self?.hotsArray ?? []]
                        }
                        break
                    case .failure(_):
                        break
                    }
                }
            })
        }
        
        //浏览历史和热门搜索点击
        oneView.cellBlock = { [weak self] index, model in
            let peopleDetailVc = PeopleBothViewController()
            peopleDetailVc.personId.accept(model.entityId ?? "")
            peopleDetailVc.peopleName.accept(model.entityName ?? "")
            self?.navigationController?.pushViewController(peopleDetailVc, animated: true)
        }
    }
    
}

/** 网络数据请求*/
extension SearchBossViewController {
    
    //获取人员列表数据
    private func searchListInfo() {
        ViewHud.addLoadView()
        let dict = ["keywords": keyword,
                    "orgIndustry": entityIndustry,
                    "orgArea": entityArea,
                    "pageNum": pageIndex,
                    "pageSize": 20] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/v2/person/boss-search",
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
                    if pageIndex == 1 {
                        pageIndex = 1
                        self.allArray.removeAll()
                    }
                    pageIndex += 1
                    let pageData = model.items ?? []
                    self.allArray.append(contentsOf: pageData)
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
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
                    self.twoPeopleListView.searchWordsRelay.accept(keyword)
                    DispatchQueue.main.asyncAfter(delay: 0.5) {
                        self.twoPeopleListView.tableView.hideSkeleton()
                        self.twoPeopleListView.tableView.reloadData()
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取最近搜索,浏览历史,热搜
    private func getHotsSearchInfo() {
        let group = DispatchGroup()
        ViewHud.addLoadView()
        group.enter()
        getLastSearchInfo(from: "02") { [weak self] modelArray in
            if !modelArray.isEmpty {
                self?.oneView.bgView.isHidden = false
                self?.oneView.bgView.snp.remakeConstraints({ make in
                    make.top.equalToSuperview().offset(1)
                    make.left.equalToSuperview()
                    make.width.equalTo(SCREEN_WIDTH)
                })
                self?.oneView.tagArray = modelArray.map { $0.searchContent ?? "" }
                self?.oneView.setupScrollView()
            }else {
                self?.oneView.bgView.isHidden = true
                self?.oneView.bgView.snp.remakeConstraints({ make in
                    make.top.equalToSuperview().offset(1)
                    make.left.equalToSuperview()
                    make.width.equalTo(SCREEN_WIDTH)
                    make.height.equalTo(0)
                })
            }
            group.leave()
        }
        
        group.enter()
        getLastHistroyInfo(from: "02") { [weak self] modelArray in
            self?.historyArray = modelArray
            group.leave()
        }
        
        group.enter()
        getLastHotsInfo(from: "02") { [weak self] modelArray in
            self?.hotsArray = modelArray
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.modelArray = [self.historyArray, self.hotsArray]
            self.oneView.modelArray = self.modelArray
            self.completeBlock?()
            ViewHud.hideLoadView()
        }
        
        oneView.tagClickBlock = { [weak self] label in
            self?.lastSearchTextBlock?(label.text ?? "")
        }
        
    }
    
}

extension SearchBossViewController: JXPagingViewListViewDelegate {
    
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
