//
//  SearchEnterpriseViewController.swift
//  问道云
//
//  Created by 何康 on 2025/3/31.
//  首页搜索企业

import UIKit
import MapKit
import RxRelay
import RxSwift
import MJRefresh
import DropMenuBar
import JXPagingView
import SkeletonView
import TYAlertController

class SearchEnterpriseViewController: WDBaseViewController {
    
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
    lazy var companyListView: TwoCompanyView = {
        let companyListView = TwoCompanyView()
        companyListView.isHidden = true
        return companyListView
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
        
        companyListView.tableView.isSkeletonable = true
        companyListView.tableView.showAnimatedGradientSkeleton()
        
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
                //获取热搜等数据
                getHotsSearchInfo()
            }else {
                self.oneView.isHidden = true
                self.companyListView.isHidden = false
                self.keyword = text
                self.getCompanyListInfo()
            }
        }).disposed(by: disposeBag)
        
        setupUI()
        
    }
    
    
}

extension SearchEnterpriseViewController {
    
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
            self.getCompanyListInfo()
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
            self.getCompanyListInfo()
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
            self.getCompanyListInfo()
        })
        
        //添加上拉加载更多
        self.companyListView.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.getCompanyListInfo()
        })
        
        //跳转地址
        companyListView.addressBlock = { [weak self] model in
            let latitude = Double(model.orgInfo?.regAddr?.lat ?? "0.0") ?? 0.0
            let longitude = Double(model.orgInfo?.regAddr?.lng ?? "0.0") ?? 0.0
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let locationVc = CompanyLocationViewController(location: location)
            locationVc.name = model.orgInfo?.orgName ?? ""
            self?.navigationController?.pushViewController(locationVc, animated: true)
        }
        
        //跳转网址
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
                self.getCompanyListInfo()
            }
            self?.navigationController?.pushViewController(companyDetailVc, animated: true)
        }
        
        //查看更多
        companyListView.moreBtnBlock = { [weak self] in
            self?.moreBtnBlock?()
        }
        
        //删除最近搜索
        oneView.deleteBlock = {
            ShowAlertManager.showAlert(title: "删除", message: "是否确定删除最近搜索?", confirmAction: {
                ViewHud.addLoadView()
                let man = RequestManager()
                let dict = ["moduleId": "01"]
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
        
        //浏览历史和热门搜索点击
        oneView.cellBlock = { [weak self] index, model in
            let companyDetailVc = CompanyBothViewController()
            let enityId = model.entityId ?? ""
            let companyName = model.entityName ?? ""
            companyDetailVc.enityId.accept(enityId)
            companyDetailVc.companyName.accept(companyName)
            self?.navigationController?.pushViewController(companyDetailVc, animated: true)
        }
    }
    
}

/** 网络数据请求*/
extension SearchEnterpriseViewController {
    
    //获取企业列表数据
    private func getCompanyListInfo() {
        ViewHud.addLoadView()
        let dict = ["keyword": keyword,
                    "matchType": 1,
                    "industryType": entityIndustry,
                    "region": entityArea,
                    "pageIndex": pageIndex,
                    "pageSize": 20] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/v2/org-list",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
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
                    self.companyListView.searchWordsRelay.accept(keyword)
                    DispatchQueue.main.asyncAfter(delay: 0.25) {
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
    
    //获取最近搜索,浏览历史,热搜
    private func getHotsSearchInfo() {
        let group = DispatchGroup()
        ViewHud.addLoadView()
        group.enter()
        getLastSearchInfo(from: "01") { [weak self] modelArray in
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
        getLastHistroyInfo(from: "01") { [weak self] modelArray in
            self?.historyArray = modelArray
            group.leave()
        }
        
        group.enter()
        getLastHotsInfo(from: "01") { [weak self] modelArray in
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

extension SearchEnterpriseViewController: JXPagingViewListViewDelegate {
    
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
