//
//  WeekReportViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/7.
//  日报

import UIKit
import JXPagingView
import MJRefresh
import TYAlertController

class WeekReportViewController: WDBaseViewController {
    
    var allArray: [itemsModel] = []
    //企业
    var companyArray: [itemsModel] = []
    //个人
    var peopleArray: [itemsModel] = []
    
    var model: DataModel?
    //用来标记是否点击了个人
    var isClick: String = "0"
    
    lazy var iconImageView1: UIImageView = {
        let iconImageView1 = UIImageView()
        iconImageView1.image = UIImage(named: "wendaoimage1")
        return iconImageView1
    }()
    
    lazy var iconImageView2: UIImageView = {
        let iconImageView2 = UIImageView()
        iconImageView2.image = UIImage(named: "riskiamgewendaore")
        return iconImageView2
    }()
    
    lazy var iconImageView3: UIImageView = {
        let iconImageView3 = UIImageView()
        iconImageView3.image = UIImage(named: "loginiamgerisk")
        return iconImageView3
    }()
    
    var groupBtn: UIButton?
    
    var groupArray: [rowsModel]?
    
    lazy var groupView: PopMonitoringGroupView = {
        let groupView = PopMonitoringGroupView(frame: self.view.bounds)
        return groupView
    }()
    
    var groupnumber: String = ""
    var groupName: String = "全部分组"
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
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

extension WeekReportViewController {
    
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
        let dict = ["time": "week",
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
                        goAddMonitoringCompanyUI()
                    }else {
                        //存在监控列表
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
        let dict = ["time": "week"]
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

extension WeekReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
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
            let headView = UIView()
            headView.backgroundColor = .random()
            return headView
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
    
    private func goAddMonitoringCompanyUI() {
        iconImageView3.image = UIImage(named: "tianjiajianonmgqiye")
        view.addSubview(iconImageView1)
        view.addSubview(iconImageView2)
        view.addSubview(iconImageView3)
        self.iconImageView3 = iconImageView3
        iconImageView1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset((SCREEN_WIDTH - 341) * 0.5)
            make.top.equalToSuperview().offset(18.5)
            make.size.equalTo(CGSize(width: 341, height: 108))
        }
        iconImageView2.snp.makeConstraints { make in
            make.centerX.equalTo(iconImageView1.snp.centerX)
            make.top.equalTo(iconImageView1.snp.bottom).offset(18.5)
            make.size.equalTo(CGSize(width: 355, height: 276))
        }
        iconImageView3.snp.makeConstraints { make in
            make.centerX.equalTo(iconImageView1.snp.centerX)
            make.top.equalTo(iconImageView2.snp.bottom).offset(111)
            make.size.equalTo(CGSize(width: 147, height: 46))
        }
        iconImageView3.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let searchVc = SearchMonitoringViewController()
                self.navigationController?.pushViewController(searchVc, animated: true)
            }).disposed(by: disposeBag)
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
                self?.getMonitoringCompanyInfo {
                    
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
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-StatusHeightManager.tabBarHeight)
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
            self?.getMonitoringCompanyInfo {
                
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
            self?.getMonitoringPeopleInfo {
                
            }
        }).disposed(by: disposeBag)
        
    }
    
}

extension WeekReportViewController: JXPagingViewListViewDelegate {
    
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
