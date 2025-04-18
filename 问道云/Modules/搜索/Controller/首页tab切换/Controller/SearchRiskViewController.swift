//
//  SearchRiskViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/7.
//  首页风险搜索

import UIKit
import JXPagingView
import RxRelay
import MJRefresh
import RxSwift
import DropMenuBar
import TYAlertController

class SearchRiskViewController: WDBaseViewController {
    
    private var cman = RequestManager()
    
    private var man = RequestManager()
    
    var completeBlock: (() -> Void)?
    
    //城市数据
    var regionModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    
    //行业数据
    var industryModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    
    //公司搜索参数
    var pageIndex: Int = 1
    var entityArea: String = ""//公司时候的地区
    var entityIndustry: String = ""//公司时候的行业
    var allArray: [pageDataModel] = []//公司时候加载更多
    
    //人员搜索参数
    var entityPeopleArea: String = ""//公司时候的地区
    var entityPeopleIndustry: String = ""//公司时候的行业
    var allPeopleArray: [itemsModel] = []//人员时候加载更多
    
    //被搜索的关键词
    var searchWords = BehaviorRelay<String?>(value: nil)
    var keyword: String = ""//搜索的文字
    //浏览历史
    var historyArray: [rowsModel] = []
    //热门搜索
    var hotsArray: [rowsModel] = []
    //总数组
    var modelArray: [[rowsModel]] = []
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    //搜索文字回调
    var lastSearchTextBlock: ((String) -> Void)?
    
    lazy var oneView: CommonHotsView = {
        let oneView = CommonHotsView()
        return oneView
    }()
    
    //企业加人员
    lazy var twoRiskListView: TwoRiskListView = {
        let twoRiskListView = TwoRiskListView()
        twoRiskListView.backgroundColor = .white
        twoRiskListView.isHidden = true
        twoRiskListView.tableView.isSkeletonable = true
        twoRiskListView.tableView.showAnimatedGradientSkeleton()
        return twoRiskListView
    }()
    
    //只有人员
    lazy var listPeopleView: RiskListPeopleView = {
        let listPeopleView = RiskListPeopleView()
        listPeopleView.backgroundColor = .white
        listPeopleView.isHidden = true
        listPeopleView.tableView.isSkeletonable = true
        listPeopleView.tableView.showAnimatedGradientSkeleton()
        return listPeopleView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    
    lazy var companyBtn: UIButton = {
        let companyBtn = UIButton()
        companyBtn.titleLabel?.font = .mediumFontOfSize(size: 12)
        companyBtn.layer.cornerRadius = 3
        companyBtn.layer.borderWidth = 1
        companyBtn.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        companyBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.2)
        companyBtn.setTitleColor(.init(cssStr: "#547AFF"), for: .normal)
        companyBtn.setTitle("企业", for: .normal)
        companyBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        companyBtn.isHidden = true
        return companyBtn
    }()
    
    lazy var peopleBtn: UIButton = {
        let peopleBtn = UIButton()
        peopleBtn.titleLabel?.font = .mediumFontOfSize(size: 12)
        peopleBtn.layer.cornerRadius = 3
        peopleBtn.layer.borderWidth = 1
        peopleBtn.layer.borderColor = UIColor.init(cssStr: "#CCCCCC")?.cgColor
        peopleBtn.backgroundColor = .white
        peopleBtn.setTitleColor(.init(cssStr: "#999999"), for: .normal)
        peopleBtn.setTitle("人员", for: .normal)
        peopleBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        peopleBtn.isHidden = true
        return peopleBtn
    }()
    
    //选中的按钮标记
    var selectedButton: UIButton?
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(oneView)
        view.addSubview(twoRiskListView)
        view.addSubview(listPeopleView)
        oneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        //企业加人员
        twoRiskListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        //只有人员
        listPeopleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(35.5)
            make.left.right.bottom.equalToSuperview()
        }
        
        //点击最近搜索
        self.oneView.tagClickBlock = { [weak self] label in
            let searchStr = label.text ?? ""
            self?.lastSearchTextBlock?(searchStr)
        }
        
        //添加下拉刷新企业
        self.twoRiskListView.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.pageIndex = 1
            self.searchListInfo()
        })
        
        //添加上拉加载更多企业
        self.twoRiskListView.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.searchListInfo()
        })
        
        //添加下拉刷新人员
        self.listPeopleView.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.pageIndex = 1
            self.searchPeopleListinfo(from: true)
        })
        
        //添加上拉加载更多人员
        self.listPeopleView.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.searchPeopleListinfo(from: true)
        })
        
        view.addSubview(companyBtn)
        view.addSubview(peopleBtn)
        
        companyBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3.5)
            make.left.equalToSuperview().offset(13)
            make.height.equalTo(28.5)
            make.width.equalTo((SCREEN_WIDTH - 40) * 0.5)
        }
        
        peopleBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3.5)
            make.right.equalToSuperview().offset(-13)
            make.height.equalTo(28.5)
            make.width.equalTo((SCREEN_WIDTH - 40) * 0.5)
        }
        
        twoRiskListView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.top.equalTo(peopleBtn.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        //企业风险搜索添加下拉选择
        addMenuWithCompanyView()
        //人员风险搜索添加下拉选择
        addMenuWithPeopleView()
        //网络请求
        getDataInfo()
        
        //企业ID回调
        twoRiskListView.entityIdBlock = { [weak self] model in
            let riskDetailVc = CompanyRiskDetailViewController()
            riskDetailVc.enityId = model.orgInfo?.orgId ?? ""
            riskDetailVc.name = model.orgInfo?.orgName ?? ""
            riskDetailVc.logo = model.orgInfo?.logo ?? ""
            self?.navigationController?.pushViewController(riskDetailVc, animated: true)
        }
        
        //这里不仅仅是可以点击人员了....还有可能是企业
        twoRiskListView.peopleBlock = { [weak self] model in
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
        
        listPeopleView.block = { [weak self] model in
            let peopleRiskVc = PeopleRiskDetailViewController()
            peopleRiskVc.name = model.personName ?? ""
            peopleRiskVc.personId = model.personId ?? ""
            self?.navigationController?.pushViewController(peopleRiskVc, animated: true)
        }
        
        //删除最近搜索
        oneView.deleteBlock = {
            ShowAlertManager.showAlert(title: "删除", message: "是否确定删除最近搜索?", confirmAction: {
                ViewHud.addLoadView()
                let man = RequestManager()
                let dict = ["moduleId": "05"]
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
                let dict = ["moduleId": "05"]
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
            let entityType = model.entityType ?? 0
            if entityType == 1 {
                let companyRiskVc = CompanyRiskDetailViewController()
                companyRiskVc.enityId = model.entityId ?? ""
                companyRiskVc.name = model.entityName ?? ""
                self?.navigationController?.pushViewController(companyRiskVc, animated: true)
            }else {
                let peopleRiskVc = PeopleRiskDetailViewController()
                peopleRiskVc.personId = model.entityId ?? ""
                peopleRiskVc.name = model.entityName ?? ""
                self?.navigationController?.pushViewController(peopleRiskVc, animated: true)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getHotsSearchInfo()
    }
    
}

//数据请求
extension SearchRiskViewController {
    
    //搜索
    private func getDataInfo() {
        self.searchWords
            .asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self, let text = text else { return }
                //取消请求
                man.cancelLastRequest()
                self.keyword = text
                if !text.isEmpty, text.count >= 2 {
                    self.pageIndex = 1
                    self.buttonTapped(companyBtn)
                }else {
                    self.pageIndex = 1
                    self.allArray.removeAll()
                    self.oneView.isHidden = false
                    self.twoRiskListView.isHidden = true
                    self.listPeopleView.isHidden = true
                    self.companyBtn.isHidden = true
                    self.peopleBtn.isHidden = true
                    getHotsSearchInfo()
                }
        }).disposed(by: disposeBag)
        
    }
    
    
    //风险列表数据企业
    private func searchListInfo() {
        ViewHud.addLoadView()
        let dict = ["keywords": keyword,
                    "industryType": entityIndustry,
                    "region": entityArea,
                    "pageNum": pageIndex,
                    "pageSize": 20,
                    "type": "1"] as [String : Any]
        cman.requestAPI(params: dict,
                       pageUrl: "/entity/risk/getRiskData",
                       method: .get) { [weak self] result in
            self?.twoRiskListView.tableView.mj_header?.endRefreshing()
            self?.twoRiskListView.tableView.mj_footer?.endRefreshing()
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if let self = self,
                   let model = success.data,
                   let code = success.code,
                   code == 200, let total = model.pageMeta?.totalNum {
                    self.oneView.isHidden = true
                    self.twoRiskListView.isHidden = false
                    if pageIndex == 1 {
                        pageIndex = 1
                        self.allArray.removeAll()
                    }
                    pageIndex += 1
                    let pageData = model.pageData ?? []
                    self.allArray.append(contentsOf: pageData)
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
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
                    self.twoRiskListView.searchWordsRelay.accept(keyword)
                    DispatchQueue.main.asyncAfter(delay: 0.25) {
                        self.twoRiskListView.tableView.hideSkeleton()
                        self.twoRiskListView.tableView.reloadData()
                    }
                    //根据数据刷新按钮文字
                    let companyNum = String(model.pageMeta?.totalNum ?? 0)
                    self.companyBtn.setTitle("企业 \(companyNum)", for: .normal)
                    self.companyBtn.isHidden = false
                    self.peopleBtn.isHidden = false
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //只搜索人员
    func searchPeopleListinfo(from grand: Bool) {
        ViewHud.addLoadView()
        let dict = ["keywords": keyword,
                    "industryType": entityIndustry,
                    "region": entityArea,
                    "pageNum": pageIndex,
                    "pageSize": 20,
                    "type": "2"] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/risk/getRiskData",
                       method: .get) { [weak self] result in
            self?.listPeopleView.tableView.mj_header?.endRefreshing()
            self?.listPeopleView.tableView.mj_footer?.endRefreshing()
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if let self = self,
                   let model = success.data,
                   let code = success.code,
                   code == 200,
                   let total = model.total {
                    if grand {
                        self.oneView.isHidden = true
                        self.listPeopleView.isHidden = false
                    }else {
                        self.oneView.isHidden = false
                        self.listPeopleView.isHidden = true
                    }
                    if pageIndex == 1 {
                        pageIndex = 1
                        self.allPeopleArray.removeAll()
                    }
                    pageIndex += 1
                    let pageData = model.items ?? []
                    self.allPeopleArray.append(contentsOf: pageData)
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
                    }else {
                        self.addNodataView(from: self.listPeopleView.whiteView)
                    }
                    if self.allPeopleArray.count != total {
                        self.listPeopleView.tableView.mj_footer?.isHidden = false
                    }else {
                        self.listPeopleView.tableView.mj_footer?.isHidden = true
                    }
                    self.listPeopleView.dataModel.accept(model)
                    //                    self.listPeopleView.dataModelArray.accept(self.allPeopleArray)
                    self.listPeopleView.searchWordsRelay.accept(keyword)
                    DispatchQueue.main.asyncAfter(delay: 0.25) {
                        self.listPeopleView.tableView.hideSkeleton()
                        self.listPeopleView.tableView.reloadData()
                    }
                    
                    //根据数据刷新按钮文字
                    let peopleNum = String(model.total ?? 0)
                    self.peopleBtn.setTitle("人员 \(peopleNum)", for: .normal)
                    self.companyBtn.isHidden = false
                    self.peopleBtn.isHidden = false
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
        getLastSearchInfo(from: "05") { [weak self] modelArray in
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
        getLastHistroyInfo(from: "05") { [weak self] modelArray in
            self?.historyArray = modelArray
            group.leave()
        }
        
        group.enter()
        getLastHotsInfo(from: "05") { [weak self] modelArray in
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

extension SearchRiskViewController {
    
    @objc func buttonTapped(_ sender: UIButton) {
        // 根据当前点击的按钮切换样式
        if sender == companyBtn {
            updateButtonStyles(selectedButton: companyBtn, unselectedButton: peopleBtn)
            self.pageIndex = 1
            self.searchListInfo()
            self.searchPeopleListinfo(from: false)
            self.listPeopleView.isHidden = true
            self.twoRiskListView.isHidden = false
        } else if sender == peopleBtn {
            updateButtonStyles(selectedButton: peopleBtn, unselectedButton: companyBtn)
            self.pageIndex = 1
            self.searchPeopleListinfo(from: true)
            self.listPeopleView.isHidden = false
            self.twoRiskListView.isHidden = true
        }
    }
    
    func updateButtonStyles(selectedButton: UIButton, unselectedButton: UIButton) {
        // 更新选中按钮的样式
        selectedButton.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        selectedButton.backgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.2)
        selectedButton.setTitleColor(.init(cssStr: "#547AFF"), for: .normal)
        
        // 更新未选中按钮的样式
        unselectedButton.layer.borderColor = UIColor.init(cssStr: "#CCCCCC")?.cgColor
        unselectedButton.backgroundColor = .white
        unselectedButton.setTitleColor(.init(cssStr: "#999999"), for: .normal)
        
        // 更新选中的按钮标记
        self.selectedButton = selectedButton
    }
    
}

extension SearchRiskViewController {
    
    private func addMenuWithCompanyView() {
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
        self.twoRiskListView.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(32)
        }
    }
    
    private func addMenuWithPeopleView() {
        //添加下拉筛选
        let regionMenu = MenuAction(title: "地区", style: .typeList)!
        self.regionModelArray.asObservable().asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            let regionArray = getThreeRegionInfo(from: modelArray ?? [])
            regionMenu.listDataSource = regionArray
        }).disposed(by: disposeBag)
        
        regionMenu.didSelectedMenuResult = { [weak self] index, model, grand in
            guard let self = self else { return }
            self.entityPeopleArea = model?.currentID ?? ""
            self.pageIndex = 1
            self.searchPeopleListinfo(from: true)
        }
        
        let industryMenu = MenuAction(title: "行业", style: .typeList)!
        self.industryModelArray.asObservable().asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            let industryArray = getThreeIndustryInfo(from: modelArray ?? [])
            industryMenu.listDataSource = industryArray
        }).disposed(by: disposeBag)
        
        industryMenu.didSelectedMenuResult = { [weak self] index, model, grand in
            guard let self = self else { return }
            self.entityPeopleIndustry = model?.currentID ?? ""
            self.pageIndex = 1
            self.searchPeopleListinfo(from: true)
        }
        
        let menuView = DropMenuBar(action: [regionMenu, industryMenu])!
        menuView.backgroundColor = .white
        self.listPeopleView.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(32)
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
