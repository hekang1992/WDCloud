//
//  SearchCompanyLawSuitViewController.swift
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

class SearchCompanyLawSuitViewController: WDBaseViewController {
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    //搜索list列表页面
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .init(cssStr: "#F5F5F5")
        tableView.register(SearchCompanyDeadbeatCell.self, forCellReuseIdentifier: "SearchCompanyDeadbeatCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    private var man = RequestManager()
    
    //总数组
    var modelArray: [[rowsModel]] = []
    
    //城市数据
    var regionModelArray = BehaviorRelay<[rowsModel]>(value: [])
    
    //行业数据
    var industryModelArray = BehaviorRelay<[rowsModel]>(value: [])
    
    //参数
    var model: DataModel?
    var pageIndex: Int = 1
    var keyword: String = ""//搜索的文字
    var entityArea: String = ""//地区
    var entityIndustry: String = ""//行业
    var allArray: [pageDataModel] = []//加载更多
    
    //搜索的文字
    var searchWords = BehaviorRelay<String?>(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.searchWords
            .asObservable()
            .distinctUntilChanged()
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let self = self, let text = text else { return }
                self.pageIndex = 1
                if text.count < 2 {
                    self.tableView.isHidden = true
                    self.allArray.removeAll()
                    //取消请求
                    man.cancelLastRequest()
                }else {
                    self.tableView.isHidden = false
                    self.keyword = text
                    self.getCompanyListInfo {}
                }
            }).disposed(by: disposeBag)
        
        setupUI()
    }
    
}

extension SearchCompanyLawSuitViewController {
    
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
        view.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(1)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(menuView.snp.bottom).offset(1)
        }
        
        //添加下拉刷新
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.pageIndex = 1
            self.getCompanyListInfo {}
        })
        
        //添加上拉加载更多
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.getCompanyListInfo {}
        })
    }
}

/** 网络数据请求*/
extension SearchCompanyLawSuitViewController {
    
    //获取企业列表数据
    private func getCompanyListInfo(complete: @escaping (() -> Void)) {
        ViewHud.addLoadView()
        let dict = ["keyword": keyword,
                    "matchType": 1,
                    "moduleId": "06",
                    "riskType": "LAWSUIT_COUNT",
                    "queryBoss": false,
                    "industryType": entityIndustry,
                    "region": entityArea,
                    "pageIndex": pageIndex,
                    "pageSize": 20] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/v2/org-list",
                       method: .get) { [weak self] result in
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let self = self,
                   let model = success.data,
                   let code = success.code,
                   code == 200,
                   let total = model.pageMeta?.totalNum {
                    self.tableView.isHidden = false
                    self.model = model
                    if self.pageIndex == 1 {
                        self.pageIndex = 1
                        self.allArray.removeAll()
                    }
                    self.pageIndex += 1
                    let pageData = model.pageData ?? []
                    for model in pageData {
                        model.moduleId = "06"
                    }
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

extension SearchCompanyLawSuitViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let count = self.model?.pageMeta?.totalNum ?? 0
        let headView = UIView()
        let numLabel = UILabel()
        headView.backgroundColor = .init(cssStr: "#F8F9FB")
        numLabel.textColor = .init(cssStr: "#666666")
        numLabel.attributedText = GetRedStrConfig.getRedStr(from: "\(count)", fullText: "为你模糊匹配到\(count)条结果,请结合实际情况进行甄别", colorStr: "#FF0000")
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
        let model = self.allArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCompanyDeadbeatCell", for: indexPath) as! SearchCompanyDeadbeatCell
        model.searchStr = self.searchWords.value
        cell.model.accept(model)
        cell.nameBlock = { [weak self] model in
            guard let self = self else { return }
            popMoreListViewInfo(from: model)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.allArray[indexPath.row]
        let detailVc = JudgmentDebtorDetailViewController()
        detailVc.orgId = model.orgInfo?.orgId ?? ""
        detailVc.nameTitle = "诉讼记录列表"
        detailVc.pageUrl = "/firminfo/v2/home-page/risk-correlation/org"
        detailVc.riskType = "LAWSUIT_COUNT"
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
    
    //多个法定代表人弹窗
    private func popMoreListViewInfo(from model: leaderVecModel) {
        let leaderList = model.leaderList ?? []
        if leaderList.count > 1 {
            let popMoreListView = PopMoreLegalListView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 220))
            popMoreListView.descLabel.text = "\(model.leaderTypeName ?? "")\(leaderList.count)"
            popMoreListView.dataList = leaderList
            let alertVc = TYAlertController(alert: popMoreListView, preferredStyle: .alert)!
            popMoreListView.closeBlock = {
                self.dismiss(animated: true)
            }
            self.present(alertVc, animated: true)
        }else {
            let personId = model.leaderList?.first?.leaderId ?? ""
            let peopleName = model.leaderList?.first?.name ?? ""
            let peopleDetailVc = PeopleBothViewController()
            peopleDetailVc.personId.accept(personId)
            peopleDetailVc.peopleName.accept(peopleName)
            self.navigationController?.pushViewController(peopleDetailVc, animated: true)
        }
        
    }
    
}

extension SearchCompanyLawSuitViewController: JXPagingViewListViewDelegate {
    
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
