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
    
    var isClick: String = "0"
    
    var pageNum: Int = 1
    
    var groupId: String = ""
    
    var dataModel = BehaviorRelay<DataModel?>(value: nil)
    
    var allArray: [rowsModel] = []
    
    var companyModel = BehaviorRelay<DataModel?>(value: nil)
    var peopleModel = BehaviorRelay<DataModel?>(value: nil)
    
    var groupModel = BehaviorRelay<DataModel?>(value: nil)
    
    var groupnumber: String = ""
    
    var groupName: String = "全部分组"
    
    lazy var noLoginView: RiskNoLoginView = {
        let noLoginView = RiskNoLoginView()
        return noLoginView
    }()
    
    lazy var noMonitoringView: RiskNoMonitoringView = {
        let noMonitoringView = RiskNoMonitoringView()
        return noMonitoringView
    }()
    
    lazy var monitorView: PopCancelMonitoringView = {
        let monitorView = PopCancelMonitoringView(frame: self.view.bounds)
        return monitorView
    }()
    
    lazy var groupView: PopMonitoringGroupView = {
        let groupView = PopMonitoringGroupView(frame: self.view.bounds)
        return groupView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(MonitoringCell.self, forCellReuseIdentifier: "MonitoringCell")
        tableView.estimatedRowHeight = 80
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if IS_LOGIN {
            self.noLoginView.isHidden = true
            view.addSubview(noMonitoringView)
            noMonitoringView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            noMonitoringView.block = { [weak self] in
                guard let self = self else { return }
                let searchVc = SearchMonitoringViewController()
                self.navigationController?.pushViewController(searchVc, animated: true)
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
            let companyArray = companyModel?.rows ?? []
            let peopleArray = peopleModel?.rows ?? []
            let gurad = (!companyArray.isEmpty) || (!peopleArray.isEmpty)
            return gurad
        }.bind(to: noMonitoringView.rx.isHidden).disposed(by: disposeBag)
    }
}


extension DailyReportViewController {
    
    func getGroupInfo() {
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
        }
    }
    
    func getCompanyInfo() {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["reportTermType": "day",
                    "entityType": "1",
                    "groupId": groupId,
                    "pageSize": 20,
                    "pageNum": pageNum] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitor-org/queryRiskMonitorOrg",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self, let model = success.data, let modelArray = model.rows, let total = model.total {
                        self.dataModel.accept(model)
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
                            self.addNodataView(from: self.tableView)
                        }
                        if self.allArray.count != total {
                            self.tableView.mj_footer?.isHidden = false
                        }else {
                            self.tableView.mj_footer?.isHidden = true
                        }
                        self.tableView.reloadData()
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func getPeopleInfo() {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["reportTermType": "day",
                    "entityType": "2",
                    "groupId": groupId,
                    "pageSize": 20,
                    "pageNum": pageNum] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitor-org/queryRiskMonitorOrg",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self, let model = success.data, let modelArray = model.rows, let total = model.total {
                        self.dataModel.accept(model)
                        self.peopleModel.accept(model)
                        if pageNum == 1 {
                            pageNum = 1
                            self.allArray.removeAll()
                        }
                        pageNum += 1
                        self.allArray.append(contentsOf: modelArray)
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
                }
                break
            case .failure(_):
                break
            }
        }
    }
}

extension DailyReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.isClick == "0" {
            return 30
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.isClick == "0" {
            let headView = UIView()
            headView.backgroundColor = .init(cssStr: "#F8F9FB")
            let oneLabel = UILabel()
            let count = self.allArray.count
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
        cell.moreBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let alertVc = TYAlertController(alert: monitorView, preferredStyle: .actionSheet)!
            monitorView.cancelBtn.rx.tap.subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
            //取消监控
            monitorView.cancelMonBtn.rx.tap.subscribe(onNext: { [weak self] in
                //                self?.cancelMonitoringInfo(from: model)
            }).disposed(by: disposeBag)
            //移动分组
            monitorView.setBtn.rx.tap.subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: {
                    //                    self?.moveGroupInfo(from: self?.groupArray ?? [], itemModel: model)
                })
            }).disposed(by: disposeBag)
            
            self.present(alertVc, animated: true)
        }).disposed(by: disposeBag)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isClick == "0" {
            let model = self.allArray[indexPath.row]
            let riskDetailVc = CompanyRiskDetailViewController()
            riskDetailVc.name = model.firmname ?? ""
            riskDetailVc.enityId = model.entityid ?? ""
            riskDetailVc.logo = model.logo ?? ""
            riskDetailVc.time = model.createtime ?? ""
            self.navigationController?.pushViewController(riskDetailVc, animated: true)
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
                menuBtn.setTitle(model.groupname ?? "", for: .normal)
                //根据分组去筛选数据
                self?.groupName = model.groupname ?? ""
                self?.groupnumber = model.groupnumber ?? ""
                
            })
        }
        self.present(alertVc, animated: true)
    }
    
}
