//
//  SearchJobListViewController.swift
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

class SearchJobListViewController: WDBaseViewController {
    
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
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "求职检测"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setImage(UIImage(named: "rightHeadLogo"), for: .normal)
        return headView
    }()
    
    lazy var searchView: HomeItemSearchView = {
        let searchView = HomeItemSearchView()
        let attrString = NSMutableAttributedString(string: "请输入关键词", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#999999") as Any,
            .font: UIFont.mediumFontOfSize(size: 14)
        ])
        searchView.searchTx.attributedPlaceholder = attrString
        searchView.backgroundColor = .white
        return searchView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(searchView)
        searchView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(1)
            make.height.equalTo(50)
        }
        
        view.addSubview(oneView)
        oneView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(companyListView)
        companyListView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
        
        // 监听 UITextField 的文本变化
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextField.textDidChangeNotification,
            object: self.searchView.searchTx
        )
        //获取热搜数据
        getHotsSearchInfo()
        
        setupUI()
    }
    
}

extension SearchJobListViewController: UITextFieldDelegate {
    
    @objc private func textDidChange() {
        let isComposing = self.searchView.searchTx.markedTextRange != nil
        if !isComposing {
            let searchStr = self.searchView.searchTx.text ?? ""
            
            // Check for special characters
            let filteredText = filterAllSpecialCharacters(searchStr)
            if filteredText != searchStr {
                ToastViewConfig.showToast(message: "禁止输入特殊字符")
                self.searchView.searchTx.text = filteredText
                return
            }
            
            if searchStr.count < 2 && !searchStr.isEmpty {
                ToastViewConfig.showToast(message: "至少输入2个关键词")
                self.oneView.isHidden = false
                self.tableView.isHidden = true
                //获取热搜数据
                getHotsSearchInfo()
                return
            } else if searchStr.count > 100 {
                self.searchView.searchTx.text = String(searchStr.prefix(100))
                ToastViewConfig.showToast(message: "最多输入100个关键词")
            } else if searchStr.isEmpty {
                self.oneView.isHidden = false
                self.tableView.isHidden = true
                //获取热搜数据
                getHotsSearchInfo()
                return
            }
            self.oneView.isHidden = true
            self.tableView.isHidden = false
            self.pageIndex = 1
            self.keyword = self.searchView.searchTx.text ?? ""
            self.getCompanyListInfo {}
        }
    }
}

extension SearchJobListViewController {
    
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
                self.getCompanyListInfo {}
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
                let dict = ["moduleId": "10"]
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
                let dict = ["moduleId": "10"]
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
extension SearchJobListViewController {
    
    //获取企业列表数据
    private func getCompanyListInfo(complete: @escaping (() -> Void)) {
        ViewHud.addLoadView()
        let dict = ["keyword": keyword,
                    "matchType": 1,
                    "industryType": entityIndustry,
                    "queryBoss": false,
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
    
    //获取最近搜索,浏览历史,热搜
    private func getHotsSearchInfo() {
        let group = DispatchGroup()
        ViewHud.addLoadView()
        group.enter()
        getLastSearchInfo(from: "10") { [weak self] modelArray in
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
        getLastHistroyInfo(from: "10") { [weak self] modelArray in
            self?.historyArray = modelArray
            group.leave()
        }
        
        group.enter()
        getLastHotsInfo(from: "10") { [weak self] modelArray in
            self?.hotsArray = modelArray
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.modelArray = [self.historyArray, self.hotsArray]
            self.oneView.modelArray = self.modelArray
            DispatchQueue.main.asyncAfter(delay: 0.25) {
                self.searchView.searchTx.becomeFirstResponder()
            }
            ViewHud.hideLoadView()
        }
        
        oneView.tagClickBlock = { [weak self] label in
            self?.lastSearchTextBlock?(label.text ?? "")
        }
        
    }
    
}

extension SearchJobListViewController: JXPagingViewListViewDelegate {
    
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
