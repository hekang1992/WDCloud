//
//  SearchPeopleSanctionViewController.swift
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

class SearchPeopleSanctionViewController: WDBaseViewController {
    
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
            self.pageIndex = 1
            if text.count < 2 {
                self.oneView.isHidden = false
                self.twoPeopleListView.isHidden = true
                self.allArray.removeAll()
            }else {
                self.oneView.isHidden = true
                self.twoPeopleListView.isHidden = false
                self.keyword = text
                self.searchListInfo()
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
   
}

extension SearchPeopleSanctionViewController {
    
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
        
        twoPeopleListView.pageBlock = { [weak self] model in
            let pageUrl = model.detailUrl ?? ""
            let webUrl = base_url + pageUrl
            self?.pushWebPage(from: webUrl)
        }
        
    }
    
}

/** 网络数据请求*/
extension SearchPeopleSanctionViewController {
    
    //获取人员列表数据
    private func searchListInfo() {
        let dict = ["keywords": keyword,
                    "moduleId": "19",
                    "riskType": "ADMIN_PENALTY_COUNT",
                    "orgIndustry": entityIndustry,
                    "orgArea": entityArea,
                    "pageNum": pageIndex,
                    "pageSize": 20] as [String : Any]
        ViewHud.addLoadView()
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/v2/person/boss-search",
                       method: .get) { [weak self] result in
            self?.twoPeopleListView.tableView.mj_header?.endRefreshing()
            self?.twoPeopleListView.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let self = self,
                   let model = success.data,
                   let code = success.code,
                   code == 200, let total = model.total {
                    self.oneView.isHidden = true
                    self.twoPeopleListView.isHidden = false
                    if pageIndex == 1 {
                        pageIndex = 1
                        self.allArray.removeAll()
                    }
                    pageIndex += 1
                    let pageData = model.items ?? []
                    for model in pageData {
                        model.moduleId = "19"
                    }
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
                    DispatchQueue.main.asyncAfter(delay: 0.25) {
                        self.twoPeopleListView.tableView.hideSkeleton()
                        self.twoPeopleListView.tableView.reloadData()
                    }
                }
                ViewHud.hideLoadView()
                break
            case .failure(_):
                ViewHud.hideLoadView()
                break
            }
        }
    }
    
}

extension SearchPeopleSanctionViewController: JXPagingViewListViewDelegate {
    
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
