//
//  SearchCompanySanctionViewController.swift
//  问道云
//
//  Created by 何康 on 2025/3/31.
//

import UIKit
import MapKit
import RxRelay
import RxSwift
import MJRefresh
import DropMenuBar
import JXPagingView
import SkeletonView
import TYAlertController

class SearchCompanySanctionViewController: WDBaseViewController {
    
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
    lazy var companyListView: TwoRiskListView = {
        let companyListView = TwoRiskListView()
        companyListView.isHidden = true
        companyListView.tableView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.right.bottom.equalToSuperview()
        }
        return companyListView
    }()
    
    private var man = RequestManager()
    
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
    var allArray: [pageDataModel] = []//加载更多
    
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
        
        view.addSubview(companyListView)
        companyListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.searchWords
            .asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
            guard let self = self, let text = text else { return }
            self.pageIndex = 1
            if text.count < 2 {
                self.oneView.isHidden = false
                self.companyListView.isHidden = true
                self.allArray.removeAll()
            }else {
                self.oneView.isHidden = true
                self.companyListView.isHidden = false
                self.keyword = text
                self.getCompanyListInfo {}
            }
        }).disposed(by: disposeBag)
        
        //企业ID回调
        companyListView.entityIdBlock = { [weak self] model in
            let riskDetailVc = CompanyRiskDetailViewController()
            riskDetailVc.enityId = model.orgInfo?.orgId ?? ""
            riskDetailVc.name = model.orgInfo?.orgName ?? ""
            riskDetailVc.logo = model.orgInfo?.logo ?? ""
            self?.navigationController?.pushViewController(riskDetailVc, animated: true)
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
        
        companyListView.moreBlock = { [weak self] pageUrl in
            let webUrl = base_url + pageUrl
            self?.pushWebPage(from: webUrl)
        }
        
        setupUI()
    }
    
}

extension SearchCompanySanctionViewController {
    
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
            self.getCompanyListInfo {}
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
            self.getCompanyListInfo {}
        }
        
        let menuView = DropMenuBar(action: [regionMenu, industryMenu])!
        menuView.backgroundColor = .white
        self.companyListView.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(1)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        //添加下拉刷新
        self.companyListView.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.pageIndex = 1
            self.getCompanyListInfo {}
        })
        
        //添加上拉加载更多
        self.companyListView.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.getCompanyListInfo {}
        })
        
    }
}

/** 网络数据请求*/
extension SearchCompanySanctionViewController {
    
    //获取企业列表数据
    private func getCompanyListInfo(complete: @escaping (() -> Void)) {
        ViewHud.addLoadView()
        let dict = ["keyword": keyword,
                    "matchType": 1,
                    "moduleId": "19",
                    "riskType": "ADMIN_PENALTY_COUNT",
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
                    for model in pageData {
                        model.moduleId = "19"
                    }
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
                    self.companyListView.dataModel.accept(model)
                    self.companyListView.dataModelArray.accept(self.allArray)
                    self.companyListView.searchWordsRelay.accept(keyword)
                    DispatchQueue.main.asyncAfter(delay: 0.25) {
                        self.companyListView.tableView.hideSkeleton()
                        self.companyListView.tableView.reloadData()
                    }
                }
                ViewHud.hideLoadView()
                complete()
                break
            case .failure(_):
                ViewHud.hideLoadView()
                complete()
                break
            }
        }
    }
    
}

extension SearchCompanySanctionViewController: JXPagingViewListViewDelegate {
    
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
