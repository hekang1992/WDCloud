//
//  DailyReportViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/7.
//  日报

import UIKit
import MJRefresh
import TYAlertController
import RxRelay
import RxSwift

class DailyReportViewController: WDBaseViewController {
    
    weak var naviController: UINavigationController?
    
    var isClick: String = "0"
    
    var pageNum: Int = 1
    
    var groupId: String = ""
    
    var dataModel = BehaviorRelay<DataModel?>(value: nil)
    
    var allArray: [rowsModel] = []
    
    var companyModel = BehaviorRelay<DataModel?>(value: nil)
    var peopleModel = BehaviorRelay<DataModel?>(value: nil)
    
    var groupModel = BehaviorRelay<DataModel?>(value: nil)
    
    var groupName: String = "全部分组"
    
    //未登录
    lazy var noLoginView: RiskNoLoginView = {
        let noLoginView = RiskNoLoginView()
        return noLoginView
    }()
    
    //登录没有数据
    lazy var noMonitoringView: RiskNoMonitoringView = {
        let noMonitoringView = RiskNoMonitoringView()
        return noMonitoringView
    }()
    
    //登录存在数据
    lazy var monitoringView: RiskMonitoringView = {
        let monitoringView = RiskMonitoringView()
        monitoringView.tableView.delegate = self
        monitoringView.tableView.dataSource = self
        return monitoringView
    }()
    
    lazy var monitorView: PopCancelMonitoringView = {
        let monitorView = PopCancelMonitoringView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 200))
        return monitorView
    }()
    
    lazy var groupView: PopMonitoringGroupView = {
        let groupView = PopMonitoringGroupView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 280))
        return groupView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if IS_LOGIN {
            self.noLoginView.isHidden = true
            view.addSubview(noMonitoringView)
            view.addSubview(monitoringView)
            noMonitoringView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            monitoringView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            noMonitoringView.block = { [weak self] in
                guard let self = self else { return }
                let searchVc = SearchMonitoringViewController()
                naviController?.navigationController?.pushViewController(searchVc, animated: true)
            }
        }else {
            view.addSubview(noLoginView)
            noLoginView.loginBlock = { [weak self] in
                guard let self = self else { return }
                self.popLogin()
            }
            noLoginView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            self.noLoginView.isHidden = false
        }
        
        let combine = Observable.combineLatest(companyModel, peopleModel)
        combine.map { companyModel, peopleModel in
            let companyTotal = companyModel?.total ?? 0
            let peopleTotal = peopleModel?.total ?? 0
            let gurad = (companyTotal != 0) || (peopleTotal != 0)
            return gurad
        }
        .bind(to: noMonitoringView.rx.isHidden)
        .disposed(by: disposeBag)
        
        combine.map { companyModel, peopleModel in
            let companyTotal = companyModel?.total ?? 0
            let peopleTotal = peopleModel?.total ?? 0
            let gurad = (companyTotal != 0) || (peopleTotal != 0)
            return !gurad
        }
        .bind(to: monitoringView.rx.isHidden)
        .disposed(by: disposeBag)
        
        monitoringView.companyBlock = { [weak self] btn in
            guard let self = self else { return }
            self.isClick = "0"
            self.pageNum = 1
            ViewHud.addLoadView()
            self.getCompanyInfo {
                ViewHud.hideLoadView()
            }
        }
        
        monitoringView.peopleBlock = { [weak self] btn in
            guard let self = self else { return }
            self.isClick = "1"
            self.pageNum = 1
            ViewHud.addLoadView()
            self.getPeopleInfo {
                ViewHud.hideLoadView()
            }
        }
        
        self.monitoringView.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.pageNum = 1
            ViewHud.addLoadView()
            if self.isClick == "0" {
                self.getCompanyInfo {
                    ViewHud.hideLoadView()
                }
            }else {
                self.getPeopleInfo {
                    ViewHud.hideLoadView()
                }
            }
        })
        
        self.monitoringView.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            ViewHud.addLoadView()
            if self.isClick == "0" {
                self.getCompanyInfo {
                    ViewHud.hideLoadView()
                }
            }else {
                self.getPeopleInfo {
                    ViewHud.hideLoadView()
                }
            }
        })
    }
    
    func getListInfo() {
        ViewHud.addLoadView()
        let group = DispatchGroup()
        
        group.enter()
        getGroupInfo {
            group.leave()
        }
        
        group.enter()
        getCompanyInfo {
            group.leave()
        }
        
        group.enter()
        getPeopleInfo {
            group.leave()
        }
        
        group.notify(queue: .main) {
            ViewHud.hideLoadView()
            print("All requests completed.")
        }
    }
    
}


extension DailyReportViewController {
    
    func getGroupInfo(complete: @escaping () -> Void) {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = [String: Any]()
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitorgroup/selectMonitorGroup",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let model = success.data {
                        self?.groupModel.accept(model)
                    }
                }
                break
            case .failure(_):
                break
            }
            complete()
        }
    }
    
    func getCompanyInfo(complete: @escaping () -> Void) {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["reportTermType": "day",
                    "groupId": groupId,
                    "pageSize": 10,
                    "pageNum": pageNum] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitor-org/queryRiskMonitorOrg",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            self?.monitoringView.tableView.mj_header?.endRefreshing()
            self?.monitoringView.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self, let model = success.data, let modelArray = model.rows, let total = model.total {
                        self.dataModel.accept(model)
                        self.monitoringView.companyBtn.setTitle("企业 \(total)", for: .normal)
                        self.companyModel.accept(model)
                        if pageNum == 1 {
                            pageNum = 1
                            self.allArray.removeAll()
                        }
                        pageNum += 1
                        self.allArray.append(contentsOf: modelArray)
                        if total != 0 {
                            self.emptyView.removeFromSuperview()
                        }else {
                            self.addNodataView(from: self.monitoringView.tableView)
                        }
                        if self.allArray.count != total {
                            self.monitoringView.tableView.mj_footer?.isHidden = false
                        }else {
                            self.monitoringView.tableView.mj_footer?.isHidden = true
                        }
                        self.monitoringView.tableView.reloadData()
                    }
                }
                break
            case .failure(_):
                break
            }
            complete()
        }
    }
    
    func getPeopleInfo(complete: @escaping () -> Void) {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["reportTermType": "day",
                    "pageNum": pageNum,
                    "pageSize": 20,] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitor-person/queryRiskMonitorPerson",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            self?.monitoringView.tableView.mj_header?.endRefreshing()
            self?.monitoringView.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self, let model = success.data, let modelArray = model.rows, let total = model.total {
                        self.peopleModel.accept(model)
                        self.monitoringView.peopleBtn.setTitle("个人 \(total)", for: .normal)
                        if self.isClick == "1" {
                            self.dataModel.accept(model)
                            if pageNum == 1 {
                                pageNum = 1
                                self.allArray.removeAll()
                            }
                            pageNum += 1
                            self.allArray.append(contentsOf: modelArray)
                            if total != 0 {
                                self.emptyView.removeFromSuperview()
                            }else {
                                self.addNodataView(from: self.monitoringView.tableView)
                            }
                            if self.allArray.count != total {
                                self.monitoringView.tableView.mj_footer?.isHidden = false
                            }else {
                                self.monitoringView.tableView.mj_footer?.isHidden = true
                            }
                            self.monitoringView.tableView.reloadData()
                        }
                    }
                }
                break
            case .failure(_):
                break
            }
            complete()
        }
    }
}

extension DailyReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.isClick == "0" {
            return 30
        }else {
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.isClick == "0" {
            let headView = UIView()
            headView.backgroundColor = .init(cssStr: "#F8F9FB")
            let oneLabel = UILabel()
            let count = self.companyModel.value?.total ?? 0
            oneLabel.textColor = .init(cssStr: "#333333")
            oneLabel.attributedText = GetRedStrConfig.getRedStr(from: "\(count)", fullText: "已监控企业\(count)", colorStr: "#FF4444")
            oneLabel.font = .regularFontOfSize(size: 12)
            headView.addSubview(oneLabel)
            oneLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(10)
                make.top.bottom.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            
            let twoLabel = UILabel()
            let rcount = self.dataModel.value?.recentNews ?? 0
            twoLabel.textColor = .init(cssStr: "#333333")
            twoLabel.attributedText = GetRedStrConfig.getRedStr(from: "\(rcount)+", fullText: "当日新动态\(rcount)+", colorStr: "#FF4444")
            twoLabel.font = .regularFontOfSize(size: 12)
            headView.addSubview(twoLabel)
            twoLabel.snp.makeConstraints { make in
                make.left.equalTo(oneLabel.snp.right).offset(9)
                make.top.bottom.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            let groupBtn = UIButton(type: .custom)
            groupBtn.setTitle(self.groupName, for: .normal)
            groupBtn.rx.tap.subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.popGroupView(from: groupBtn)
            }).disposed(by: disposeBag)
            groupBtn.setTitleColor(.init(cssStr: "#666666"), for: .normal)
            groupBtn.titleLabel?.font = .regularFontOfSize(size: 10)
            groupBtn.setImage(UIImage(named: "downgrayimge"), for: .normal)
            headView.addSubview(groupBtn)
            groupBtn.snp.makeConstraints { make in
                make.left.equalTo(SCREEN_WIDTH - 62)
                make.size.equalTo(CGSize(width: 52, height: 14))
                make.centerY.equalTo(twoLabel.snp.centerY)
            }
            groupBtn.layoutButtonEdgeInsets(style: .right, space: 2)
            return headView
        }else {
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.allArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonitoringCell", for: indexPath) as! MonitoringCell
        cell.selectionStyle = .none
        cell.model = model
        //弹窗设置分组或者取消监控
        cell.moreBlock = { [weak self] in
            guard let self = self else { return }
            let alertVc = TYAlertController(alert: monitorView, preferredStyle: .actionSheet)!
            alertVc.backgoundTapDismissEnable = true
            monitorView.block1 = { [weak self] in
                self?.dismiss(animated: true)
            }
            //取消监控
            monitorView.block2 = { [weak self] in
                self?.dismiss(animated: true, completion: {
                    self?.cancelMonitoringInfo(from: model, indexPath: indexPath)
                })
            }
            //移动分组
            monitorView.block3 = { [weak self] in
                self?.dismiss(animated: true, completion: {
                    self?.moveGroupInfo(from: self?.groupModel.value?.rows ?? [], rowsModel: model)
                })
            }
            self.present(alertVc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isClick == "0" {
            let model = self.allArray[indexPath.row]
            let orgName = model.orgName ?? ""
            let orgId = model.orgId ?? ""
            let logo = model.logo ?? ""
            let startDate = (model.startDate ?? "") + "至" + (model.endDate ?? "")
            let groupName = model.groupName ?? ""
            let riskDetailVc = CompanyRiskDetailViewController()
            riskDetailVc.enityId = orgId
            riskDetailVc.name = orgName
            riskDetailVc.logo = logo
            riskDetailVc.time = startDate
            riskDetailVc.groupName = groupName
            naviController?.navigationController?.pushViewController(riskDetailVc, animated: true)
        }else {
            ToastViewConfig.showToast(message: "数据端不支持,iOS端没有画这个页面")
        }
        
    }
    
    private func popGroupView(from menuBtn: UIButton) {
        let alertVc = TYAlertController(alert: groupView, preferredStyle: .actionSheet)!
        groupView.groupArray = self.groupModel.value?.rows ?? []
        groupView.cancelBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
        groupView.block = { [weak self] model in
            self?.dismiss(animated: true, completion: {
                menuBtn.setTitle(model.groupName ?? "", for: .normal)
                //根据分组去筛选数据
                self?.pageNum = 1
                self?.groupName = model.groupName ?? ""
                self?.groupId = model.eid ?? ""
                ViewHud.addLoadView()
                if self?.isClick == "0" {
                    self?.getCompanyInfo {
                        ViewHud.hideLoadView()
                    }
                }else {
                    self?.getPeopleInfo {
                        ViewHud.hideLoadView()
                    }
                }
            })
        }
        self.present(alertVc, animated: true)
    }
    
    private func cancelMonitoringInfo(from model: rowsModel, indexPath: IndexPath) {
        let dict = ["orgId": model.orgId ?? ""]
        let man = RequestManager()
        man.requestAPI(params: dict, pageUrl: "/entity/monitor-org/cancelRiskMonitorOrg", method: .post) { result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    ViewHud.addLoadView()
                    self.getCompanyInfo {
                        ViewHud.hideLoadView()
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    private func moveGroupInfo(from modelArray: [rowsModel], rowsModel: rowsModel) {
        let groupView = FocusCompanyPopGroupView()
        groupView.frame = self.view.superview!.frame
        groupView.model.accept(modelArray)
        let alertVc = TYAlertController(alert: groupView, preferredStyle: .alert)!
        self.present(alertVc, animated: true)
        groupView.cblock = { [weak self] in
            self?.dismiss(animated: true)
        }
        groupView.sblock = { model in
            let man = RequestManager()
            let dict = ["orgId": rowsModel.orgId ?? "",
                        "groupId": model.eid ?? ""]
            man.requestAPI(params: dict,
                           pageUrl: "/entity/monitor-org/updRiskMonitorOrgGroup",
                           method: .post) { [weak self] result in
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        if let self = self {
                            ViewHud.addLoadView()
                            self.dismiss(animated: true) {
                                self.pageNum = 1
                                self.getCompanyInfo { ViewHud.hideLoadView() }
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
    
}
