//
//  PropertyCompanyViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/20.
//

import UIKit
import RxRelay
import RxSwift
import DropMenuBar
import JXPagingView
import MJRefresh
import SkeletonView
import TYAlertController

class PropertyCompanyViewController: WDBaseViewController {
    
    private let man = RequestManager()
    
    var blockModel: ((DataModel) -> Void)?
    
    //城市数据
    var regionModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    var industryModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    //被搜索的关键词
    var searchWordsRelay = BehaviorRelay<String>(value: "")

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(PropertyListViewCell.self, forCellReuseIdentifier: "PropertyListViewCell")
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
    
    //搜索参数
    var pageIndex: Int = 1
    var entityArea: String = ""//地区
    var entityIndustry: String = ""//行业
    var allArray: [DataModel] = []//加载更多
    var dataModel: DataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.searchWordsRelay
            .distinctUntilChanged()
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.pageIndex = 1
                if !text.isEmpty {
                    self.searchListInfo()
                }
            }).disposed(by: disposeBag)
        
        //添加下拉筛选
        let regionMenu = MenuAction(title: "全国", style: .typeList)!
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
            let regionArray = getThreeIndustryInfo(from: modelArray ?? [])
            industryMenu.listDataSource = regionArray
        }).disposed(by: disposeBag)
        
        industryMenu.didSelectedMenuResult = { [weak self] index, model, grand in
            guard let self = self else { return }
            self.entityIndustry = model?.currentID ?? ""
            self.pageIndex = 1
            self.searchListInfo()
        }
        
        let menuView = DropMenuBar(action: [regionMenu, industryMenu])!
        menuView.backgroundColor = .white
        view.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalToSuperview().offset(1)
            make.height.equalTo(30)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(menuView.snp.bottom).offset(1)
            make.left.right.bottom.equalToSuperview()
        }
        
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            pageIndex = 1
            searchListInfo()
        })
        
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            searchListInfo()
        })
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton()
        print("检查骨架屏是否激活========\(tableView.sk.isSkeletonActive)")
        print("检查是否支持骨架屏=========\(tableView.isSkeletonable)")
    }
    
}

extension PropertyCompanyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = .init(cssStr: "#F5F5F5")
        let numLabel = UILabel()
        numLabel.textColor = UIColor.init(cssStr: "#666666")
        numLabel.font = .regularFontOfSize(size: 12)
        numLabel.textAlignment = .left
        let count = String(self.dataModel?.companyPage?.total ?? 0)
        numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "搜索到\(count)个企业有财产线索", font: .regularFontOfSize(size: 12))
        headView.addSubview(numLabel)
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(22)
        }
        return headView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyListViewCell", for: indexPath) as! PropertyListViewCell
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        let model = self.allArray[indexPath.row]
        model.searchStr = self.searchWordsRelay.value
        cell.model = model
        cell.cellBlock = { [weak self] in
            guard let self = self else { return }
            self.tableView(tableView, didSelectRowAt: indexPath)
        }
        cell.monitoringBlock = { [weak self] model, monitoringBtn in
            guard let self = self else { return }
            let monitor = model.monitor ?? false
            if monitor {
                propertyLineCancelInfo(from: model, monitoringBtn: monitoringBtn)
            }else {
                prppertyLineMonitrongInfo(from: model, monitoringBtn: monitoringBtn)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.allArray[indexPath.row]
        print("公司名称=====\(model.subjectName ?? "")")
        let cell = tableView.cellForRow(at: indexPath) as! PropertyListViewCell
        self.checkInfo(from: model, cell: cell)
    }
}

extension PropertyCompanyViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "PropertyListViewCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        let cell = skeletonView.dequeueReusableCell(withIdentifier: "PropertyListViewCell", for: indexPath) as! PropertyListViewCell
        cell.selectionStyle = .none
        return cell
    }
    
}

/** 网络数据请求 */
extension PropertyCompanyViewController {
    
    //财产线索列表
    private func searchListInfo() {
        ViewHud.addLoadView()
        let dict = ["keyWords": self.searchWordsRelay.value,
                    "searchType": "0",
                    "industryCode": entityIndustry,
                    "areaCode": entityArea,
                    "pageNum": pageIndex,
                    "pageSize": 20] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/property/clues/search/findPropertySearchList",
                       method: .post) { [weak self] result in
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self, let model = success.data, let total = model.companyPage?.total {
                        self.dataModel = model
                        self.blockModel?(model)
                        if pageIndex == 1 {
                            self.allArray.removeAll()
                        }
                        pageIndex += 1
                        let pageData = model.companyPage?.data ?? []
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
                        DispatchQueue.main.asyncAfter(delay: 0.25) {
                            self.tableView.hideSkeleton()
                            self.tableView.reloadData()
                        }
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    private func checkInfo(from model: DataModel, cell: PropertyListViewCell) {
        let entityType = "1"
        let entityId = model.subjectId ?? ""
        let entityName = model.subjectName ?? ""
        let dict = ["entityType": entityType,
                    "entityId": entityId,
                    "entityName": entityName]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/operation/equity-property/check",
                       method: .get) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    let bothVc = PropertyLineBothViewController()
                    let enityId = model.subjectId ?? ""
                    let companyName = model.subjectName ?? ""
                    bothVc.entityType = 1
                    bothVc.enityId.accept(enityId)
                    bothVc.companyName.accept(companyName)
                    bothVc.logoUrl = model.logoUrl ?? ""
                    bothVc.monitor = model.monitor ?? false
                    self.navigationController?.pushViewController(bothVc, animated: true)
                }else if success.code == 702 {
                    let buyVipView = PopBuyVipView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 400))
                    buyVipView.bgImageView.image = UIImage(named: "poponereportimge")
                    let alertVc = TYAlertController(alert: buyVipView, preferredStyle: .alert)!
                    buyVipView.cancelBlock = {
                        self.dismiss(animated: true)
                    }
                    buyVipView.buyOneBlock = {
                        //跳转购买单次会员
                        self.dismiss(animated: true, completion: {
                            let oneVc = BuyOnePropertyLineViewController()
                            oneVc.entityType = 1
                            oneVc.entityId = model.subjectId ?? ""
                            oneVc.entityName = model.subjectName ?? ""
                            //刷新列表
                            oneVc.refreshBlock = {
                                model.monitor = true
                                cell.monitoringBtn.setImage(UIImage(named: "propertyhavjiank"), for: .normal)
                            }
                            self.navigationController?.pushViewController(oneVc, animated: true)
                        })
                    }
                    buyVipView.buyVipBlock = {
                        //跳转购买会员
                        self.dismiss(animated: true, completion: {
                            let memVc = MembershipCenterViewController()
                            self.navigationController?.pushViewController(memVc, animated: true)
                        })
                    }
                    self.present(alertVc, animated: true)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //添加监控
    func prppertyLineMonitrongInfo(from model: DataModel, monitoringBtn: UIButton) {
        ViewHud.addLoadView()
        let entityId = model.subjectId ?? ""
        let entityName = model.subjectName ?? ""
        let customerNumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let entityType = 1
        let man = RequestManager()
        let dict = ["entityId": entityId,
                    "entityName": entityName,
                    "entityType": entityType,
                    "customerNumber": customerNumber] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/monitor",
                       method: .post) { [weak self] result in
            guard let self = self else { return }
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    model.monitor = true
                    monitoringBtn.setImage(UIImage(named: "propertyhavjiank"), for: .normal)
                    self.addUnioInfo(form: entityId, name: entityName)
                    ToastViewConfig.showToast(message: "监控成功")
                }else if success.code == 702 {
                    let buyVipView = PopBuyVipView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 400))
                    buyVipView.bgImageView.image = UIImage(named: "poponereportimge")
                    let alertVc = TYAlertController(alert: buyVipView, preferredStyle: .alert)!
                    buyVipView.cancelBlock = {
                        self.dismiss(animated: true)
                    }
                    buyVipView.buyOneBlock = {
                        //跳转购买单次会员
                        self.dismiss(animated: true, completion: {
                            let oneVc = BuyOnePropertyLineViewController()
                            oneVc.entityType = 1
                            oneVc.entityId = model.subjectId ?? ""
                            oneVc.entityName = model.subjectName ?? ""
                            //刷新列表
                            oneVc.refreshBlock = { [weak self] in
                                guard let self = self else { return }
                                addUnioInfo(form: entityId, name: entityName)
                                model.monitor = true
                                monitoringBtn.setImage(UIImage(named: "propertyhavjiank"), for: .normal)
                            }
                            self.navigationController?.pushViewController(oneVc, animated: true)
                        })
                    }
                    buyVipView.buyVipBlock = {
                        //跳转购买会员
                        self.dismiss(animated: true, completion: {
                            let memVc = MembershipCenterViewController()
                            self.navigationController?.pushViewController(memVc, animated: true)
                        })
                    }
                    self.present(alertVc, animated: true)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //取消监控
    func propertyLineCancelInfo(from model: DataModel, monitoringBtn: UIButton) {
        ViewHud.addLoadView()
        let entityId = model.subjectId ?? ""
        let entityName = model.subjectName ?? ""
        let entityType = "1"
        let man = RequestManager()
        let dict = ["entityId": entityId,
                    "entityName": entityName,
                    "entityType": entityType]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/monitor/cancel",
                       method: .post) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                guard let self = self else { return }
                if success.code == 200 {
                    model.monitor = false
                    monitoringBtn.setImage(UIImage(named: "propertymongijan"), for: .normal)
                    ToastViewConfig.showToast(message: "取消监控成功")
                }else if success.code == 702 {
                    
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //添加关联方信息
    func addUnioInfo(form entityId: String, name: String) {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["entityId": entityId,
                    "entityType": "1"]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/monitor/relation",
                       method: .get) { result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let modelArray = success.data?.monitorRelationVOList {
                        let popView = PropertyAlertView(frame: CGRectMake(0, StatusHeightManager.navigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - StatusHeightManager.navigationBarHeight))
                        popView.ctImageView.image = UIImage.imageOfText(name, size: (30, 30))
                        popView.nameLabel.text = name
                        popView.modelArray = modelArray
                        popView.tableView.reloadData()
                        UIView.animate(withDuration: 0.25) {
                            keyWindow?.addSubview(popView)
                        }
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}

extension PropertyCompanyViewController: JXPagingViewListViewDelegate {
    
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
