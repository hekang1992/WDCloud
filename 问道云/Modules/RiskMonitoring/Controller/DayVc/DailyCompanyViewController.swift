//
//  DailyCompanyViewController.swift
//  问道云
//
//  Created by Andrew on 2025/3/1.
//

import UIKit
import JXSegmentedView
import MJRefresh
import RxRelay
import TYAlertController
import SwiftyJSON

class DailyCompanyViewController: WDBaseViewController {
    
    var vc: DailyReportViewController?
    
    var pageNum: Int = 1
    
    var groupId: String = ""
    
    var groupName: String = "全部分组"
    
    var companyArray: [rowsModel] = []
    
    var groupModel = BehaviorRelay<DataModel?>(value: nil)
    
    var companyModel = BehaviorRelay<DataModel?>(value: nil)
    
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    lazy var dailyView: RiskHaveDataView = {
        let dailyView = RiskHaveDataView()
        dailyView.tableView.delegate = self
        dailyView.tableView.dataSource = self
        return dailyView
    }()
    
    lazy var monitorView: PopCancelMonitoringView = {
        let monitorView = PopCancelMonitoringView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 200))
        return monitorView
    }()
    
    lazy var groupView: PopMonitoringGroupView = {
        let groupView = PopMonitoringGroupView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 280))
        return groupView
    }()
    
    var isRequset: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(dailyView)
        dailyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.dailyView.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.pageNum = 1
            getGroupInfo()
            getCompanyInfo()
        })
        
        self.dailyView.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getGroupInfo()
            getCompanyInfo()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("企业日报========")
        if IS_LOGIN && isRequset {
            isRequset = false
            self.pageNum = 1
            getGroupInfo()
            getCompanyInfo()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isRequset = true
    }
    
}

extension DailyCompanyViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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
        let rcount = self.companyModel.value?.totaRiskCnt ?? 0
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
        groupBtn.setTitleColor(.init(cssStr: "#547AFF"), for: .normal)
        groupBtn.titleLabel?.font = .regularFontOfSize(size: 10)
        groupBtn.setImage(UIImage(named: "downgrayimge"), for: .normal)
        headView.addSubview(groupBtn)
        groupBtn.snp.makeConstraints { make in
            make.left.equalTo(SCREEN_WIDTH - 62)
            make.height.equalTo(14.pix())
            make.centerY.equalTo(twoLabel.snp.centerY)
        }
        groupBtn.layoutButtonEdgeInsets(style: .right, space: 2)
        return headView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.companyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.companyArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonitoringCell", for: indexPath) as! MonitoringCell
        cell.selectionStyle = .none
        cell.companyModel = model
        //弹窗设置分组或者取消监控
        cell.moreBlock = { [weak self] in
            guard let self = self else { return }
            let alertVc = TYAlertController(alert: monitorView, preferredStyle: .actionSheet)!
            monitorView.block1 = { [weak self] in
                self?.dismiss(animated: true)
            }
            //取消监控
            monitorView.block2 = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: {
                    self.cancelMonitoringInfo(from: model, indexPath: indexPath)
                })
            }
            
            //移动分组
            monitorView.block3 = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: {
                    self.moveGroupInfo(from: self.groupModel.value?.rows ?? [], rowsModel: model)
                })
            }
            self.present(alertVc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.companyArray[indexPath.row]
        let riskDetailVc = CompanyRiskDetailViewController()
        riskDetailVc.name = model.orgName ?? ""
        riskDetailVc.enityId = model.orgId ?? ""
        riskDetailVc.logo = model.logo ?? ""
        riskDetailVc.time = (model.startDate ?? "") + "至" + (model.endDate ?? "")
        riskDetailVc.groupName = model.groupName ?? ""
        self.navigationController?.pushViewController(riskDetailVc, animated: true)
    }
    
}

/** 网络数据请求 */
extension DailyCompanyViewController {
    
    func getCompanyInfo() {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["reportTermType": "day",
                    "groupId": groupId,
                    "pageSize": 20,
                    "pageNum": pageNum] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitor-org/queryRiskMonitorOrg",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            self?.dailyView.tableView.mj_header?.endRefreshing()
            self?.dailyView.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self,
                       let model = success.data,
                       let modelArray = model.rows,
                       let total = model.total {
                        self.companyModel.accept(model)
                        if self.pageNum == 1 {
                            self.companyArray.removeAll()
                        }
                        self.pageNum += 1
                        self.companyArray.append(contentsOf: modelArray)
                        if total != 0 {
                            self.noNetView.removeFromSuperview()
                            self.emptyView.removeFromSuperview()
                        }else {
                            self.addNodataView(from: self.dailyView.tableView)
                            self.emptyView.snp.makeConstraints { make in
                                make.left.equalToSuperview()
                                make.top.equalToSuperview().offset(64)
                                make.height.equalTo(SCREEN_HEIGHT)
                                make.width.equalTo(SCREEN_WIDTH)
                            }
                        }
                        if self.companyArray.count != total {
                            self.dailyView.tableView.mj_footer?.isHidden = false
                        }else {
                            self.dailyView.tableView.mj_footer?.isHidden = true
                        }
                        self.dailyView.tableView.reloadData()
                    }
                }
                break
            case .failure(_):
                if let self = self, let vc = vc {
                    self.addNoNetView(from: vc.view)
                    self.noNetView.snp.makeConstraints { make in
                        make.left.equalToSuperview()
                        make.top.equalToSuperview().offset(64)
                        make.height.equalTo(SCREEN_HEIGHT)
                        make.width.equalTo(SCREEN_WIDTH)
                    }
                    self.noNetView.refreshBlock = { [weak self] in
                        self?.getCompanyInfo()
                    }
                }
                break
            }
        }
    }
    
    func getGroupInfo() {
        let man = RequestManager()
        let dict = [String: Any]()
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitorgroup/selectMonitorGroup",
                       method: .get) { [weak self] result in
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
    
    private func popGroupView(from menuBtn: UIButton) {
        var groupArray: [rowsModel] = self.groupModel.value?.rows ?? []
        let alertVc = TYAlertController(alert: groupView, preferredStyle: .actionSheet)!
        let json: JSON = ["groupName": "全部分组", "id": ""]
        let model = rowsModel(json: json)
        groupArray.insert(model, at: 0)
        groupView.groupArray = groupArray
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
                self?.getCompanyInfo()
            })
        }
        self.present(alertVc, animated: true)
    }
    
    //取消监控
    private func cancelMonitoringInfo(from model: rowsModel, indexPath: IndexPath) {
        let dict = ["orgId": model.orgId ?? ""]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitor-org/cancelRiskMonitorOrg",
                       method: .post) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    self?.pageNum = 1
                    self?.getCompanyInfo()
                    ToastViewConfig.showToast(message: "取消监控成功")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //移动分组
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
                            ToastViewConfig.showToast(message: "移动成功")
                            self.dismiss(animated: true) {
                                self.pageNum = 1
                                self.getGroupInfo()
                                self.getCompanyInfo()
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

extension DailyCompanyViewController: JXSegmentedListContainerViewListDelegate, JXSegmentedListContainerViewDataSource {
    
    func listView() -> UIView {
        return view
    }
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return 0
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> any JXSegmentedListContainerViewListDelegate {
        return RiskHaveDataView()
    }
    
}
