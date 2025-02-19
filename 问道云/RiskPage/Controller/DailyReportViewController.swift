//
//  DailyReportViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/7.
//  日报

import UIKit
import MJRefresh
import TYAlertController

class DailyReportViewController: WDBaseViewController {
    
    var allArray: [itemsModel] = []
    //企业
    var companyArray: [itemsModel] = []
    //个人
    var peopleArray: [itemsModel] = []
    
    var model: DataModel?
    //用来标记是否点击了个人
    var isClick: String = "0"

    var groupBtn: UIButton?
    
    //分组数据
    var groupArray: [rowsModel]?
    
    lazy var groupView: PopMonitoringGroupView = {
        let groupView = PopMonitoringGroupView(frame: self.view.bounds)
        return groupView
    }()
    
    var groupnumber: String = ""
    var groupName: String = "全部分组"
        
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
    
    lazy var companyBtn: UIButton = {
        let companyBtn = UIButton(type: .custom)
        companyBtn.setTitle("企业", for: .normal)
        companyBtn.titleLabel?.font = .mediumFontOfSize(size: 14)
        companyBtn.setTitleColor(UIColor.init(cssStr: "#547AFF "), for: .normal)
        return companyBtn
    }()
    
    lazy var peopleBtn: UIButton = {
        let peopleBtn = UIButton(type: .custom)
        peopleBtn.setTitle("个人", for: .normal)
        peopleBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        peopleBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        return peopleBtn
    }()
    
    lazy var oneLineView: UIView = {
        let oneLineView = UIView()
        oneLineView.backgroundColor = .init(cssStr: "#547AFF")
        return oneLineView
    }()
    
    lazy var twoLineView: UIView = {
        let twoLineView = UIView()
        twoLineView.backgroundColor = .init(cssStr: "#547AFF")
        twoLineView.isHidden = true
        return twoLineView
    }()
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = .white
        return coverView
    }()
    
    lazy var monitorView: PopCancelMonitoringView = {
        let monitorView = PopCancelMonitoringView(frame: self.view.bounds)
        return monitorView
    }()
    
    lazy var noMonitoringView: RiskNoMonitoringView = {
        let noMonitoringView = RiskNoMonitoringView()
        return noMonitoringView
    }()
    
    lazy var noLoginView: RiskNoLoginView = {
        let noLoginView = RiskNoLoginView()
        return noLoginView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
        //            guard let self = self else { return }
        //            getMonitoringCompanyInfo()
        //            getMonitoringPeopleInfo()
        //        })
        //
        //        //添加上拉加载更多
        //        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
        //            guard let self = self else { return }
        //            getMonitoringCompanyInfo()
        //            getMonitoringPeopleInfo()
        //        })
        if !IS_LOGIN {
            view.addSubview(noLoginView)
            noLoginView.iconImageView3
                .rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    PushLoginConfig.popLogin(from: self)
            }).disposed(by: disposeBag)
            noLoginView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if IS_LOGIN {
            ViewHud.addLoadView()
            let group = DispatchGroup()
            if self.isClick == "0" {
                //获取监控企业列表
                group.enter()
                getMonitoringCompanyInfo {
                    group.leave()
                }
            }else {
                //获取监控人员列表
                group.enter()
                getMonitoringPeopleInfo {
                    group.leave()
                }
            }
            group.enter()
            getMonitoringGroupInfo {
                group.leave()
            }
            group.notify(queue: .main) {
                // 隐藏 loading
                DispatchQueue.main.asyncAfter(delay: 1.0) {
                    ViewHud.hideLoadView()
                }
                print("All requests completed")
            }
        }
    }
    
}

extension DailyReportViewController {
    
    //查询监控分组
    func getMonitoringGroupInfo(completion: @escaping () -> Void) {
        let man = RequestManager()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber]
        man.requestAPI(params: dict,
                       pageUrl: "/riskmonitor/monitorgroup/selectmonitorgroup",
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if let model = success.data {
                    self?.groupArray = model.rows ?? []
                }
                break
            case .failure(_):
                break
            }
            completion()
        }
    }
    
    //获取监控企业列表
    func getMonitoringCompanyInfo(completion: @escaping () -> Void) {
        let dict = ["time": "today",
                    "groupnumber": groupnumber]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/riskmonitor/riskmonitoring/monitoringEnterprises",
                       method: .get) { [weak self] result in
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let self = self, let model = success.data {
                    let total = model.total ?? 0
                    if total == 0 {
                        //去添加
                        self.allArray.removeAll()
                        self.tableView.reloadData()
                        if self.groupnumber == "" {
                            goAddMonitoringCompanyUI()
                        }else {
                            self.addNodataView(from: self.tableView)
                        }
                    }else {
                        //存在监控列表
                        self.emptyView.removeFromSuperview()
                        addExistListUI()
                        self.model = model
                        self.peopleArray = model.items ?? []
                        self.allArray = self.peopleArray
                        //刷新头部数字
                        let count = self.peopleArray.count
                        self.tableView.reloadData()
                        self.companyBtn.setTitle("企业 \(count)", for: .normal)
                    }
                }
                break
            case .failure(_):
                break
            }
            completion()
        }
    }
    
    //获取监控人员列表
    func getMonitoringPeopleInfo(completion: @escaping () -> Void) {
        let dict = ["time": "today"]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/riskmonitor/riskmonitoring/monitorPerson",
                       method: .get) { [weak self] result in
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let self = self, let model = success.data {
                    self.peopleArray = model.items ?? []
                    //刷新头部数字
                    let count = self.peopleArray.count
                    self.peopleBtn.setTitle("个人 \(count)", for: .normal)
                    if isClick == "1" {
                        self.allArray = self.peopleArray
                        self.tableView.reloadData()
                    }
                }
                break
            case .failure(_):
                break
            }
            completion()
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
            let rcount = self.model?.recentNews ?? 0
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
                self?.cancelMonitoringInfo(from: model)
            }).disposed(by: disposeBag)
            //移动分组
            monitorView.setBtn.rx.tap.subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: {
                    self?.moveGroupInfo(from: self?.groupArray ?? [], itemModel: model)
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
    
    //登录成功--不存在列表信息
    private func goAddMonitoringCompanyUI() {
        view.addSubview(noMonitoringView)
        noMonitoringView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        noMonitoringView.block = { [weak self] in
            guard let self = self else { return }
            let searchVc = SearchMonitoringViewController()
            self.navigationController?.pushViewController(searchVc, animated: true)
        }
    }
    
    private func popGroupView(from menuBtn: UIButton) {
        let alertVc = TYAlertController(alert: groupView, preferredStyle: .actionSheet)!
        groupView.groupArray = self.groupArray ?? []
        groupView.cancelBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
        groupView.block = { [weak self] model in
            self?.dismiss(animated: true, completion: {
                menuBtn.setTitle(model.groupname ?? "", for: .normal)
                //根据分组去筛选数据
                self?.groupName = model.groupname ?? ""
                self?.groupnumber = model.groupnumber ?? ""
                ViewHud.addLoadView()
                self?.getMonitoringCompanyInfo {
                    ViewHud.hideLoadView()
                }
            })
        }
        self.present(alertVc, animated: true)
    }
    
    private func addExistListUI() {
        view.addSubview(coverView)
        view.addSubview(tableView)
        coverView.addSubview(companyBtn)
        coverView.addSubview(peopleBtn)
        coverView.addSubview(oneLineView)
        coverView.addSubview(twoLineView)
        coverView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(32)
        }
        companyBtn.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH * 0.5)
        }
        peopleBtn.snp.makeConstraints { make in
            make.left.equalTo(companyBtn.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH * 0.5)
        }
        oneLineView.snp.makeConstraints { make in
            make.centerX.equalTo(companyBtn.snp.centerX)
            make.size.equalTo(CGSize(width: 15, height: 2))
            make.bottom.equalToSuperview()
        }
        twoLineView.snp.makeConstraints { make in
            make.centerX.equalTo(peopleBtn.snp.centerX)
            make.size.equalTo(CGSize(width: 15, height: 2))
            make.bottom.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.bottom.equalToSuperview()
            make.top.equalTo(coverView.snp.bottom)
        }
        companyBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.companyBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
            self?.companyBtn.titleLabel?.font = .mediumFontOfSize(size: 14)
            self?.peopleBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
            self?.peopleBtn.titleLabel?.font = .regularFontOfSize(size: 14)
            self?.oneLineView.isHidden = false
            self?.twoLineView.isHidden = true
            self?.isClick = "0"
            ViewHud.addLoadView()
            self?.getMonitoringCompanyInfo {
                ViewHud.hideLoadView()
            }
        }).disposed(by: disposeBag)
        
        peopleBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.peopleBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
            self?.peopleBtn.titleLabel?.font = .mediumFontOfSize(size: 14)
            self?.companyBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
            self?.companyBtn.titleLabel?.font = .regularFontOfSize(size: 14)
            self?.oneLineView.isHidden = true
            self?.twoLineView.isHidden = false
            self?.isClick = "1"
            ViewHud.addLoadView()
            self?.getMonitoringPeopleInfo {
                ViewHud.hideLoadView()
            }
        }).disposed(by: disposeBag)
        
    }
    
    //取消监控
    private func cancelMonitoringInfo(from model: itemsModel) {
        ViewHud.addLoadView()
        let datanumber = model.datanumber ?? ""
        let man = RequestManager()
        let dict = ["datanumber": datanumber]
        man.requestAPI(params: dict,
                       pageUrl: "/riskmonitor/monitortarget/dalectmonitortarget",
                       method: .delete) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if let self = self, let model = success.data {
                    self.dismiss(animated: true) {
                        if self.isClick == "0" {
                            ViewHud.addLoadView()
                            self.getMonitoringCompanyInfo {
                                ViewHud.hideLoadView()
                            }
                        }else {
                            ViewHud.addLoadView()
                            self.getMonitoringPeopleInfo {
                                ViewHud.hideLoadView()
                            }
                        }
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    //移动分组
    private func moveGroupInfo(from model: [rowsModel], itemModel: itemsModel) {
        let groupView = FocusCompanyPopGroupView(frame: self.view.bounds)
        groupView.model.accept(model)
        let alertVc = TYAlertController(alert: groupView, preferredStyle: .alert)!
        self.present(alertVc, animated: true)
        groupView.cblock = { [weak self] in
            self?.dismiss(animated: true)
        }
        groupView.sblock = { [weak self] imodel in
            let man = RequestManager()
            let dict = ["dataNumber": itemModel.datanumber ?? "",
                        "groupNumber": imodel.groupnumber ?? ""]
            man.requestAPI(params: dict,
                           pageUrl: "/riskmonitor/monitortarget/updatemonitortarget",
                           method: .post) { result in
                switch result {
                case .success(_):
                    self?.dismiss(animated: true, completion: {
                        if self?.isClick == "0" {
                            ViewHud.addLoadView()
                            self?.getMonitoringCompanyInfo {
                                ViewHud.hideLoadView()
                            }
                        }else {
                            ViewHud.addLoadView()
                            self?.getMonitoringPeopleInfo {
                                ViewHud.hideLoadView()
                            }
                        }
                    })
                    break
                case .failure(_):
                    self?.dismiss(animated: true)
                    break
                }
            }
        }
    }
    
}
