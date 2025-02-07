//
//  DailyReportViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/7.
//  日报

import UIKit
import JXPagingView
import MJRefresh

class DailyReportViewController: WDBaseViewController {
    
    var pageNum = 1
    var pageSize = 20
    
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
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(MonitoringCell.self, forCellReuseIdentifier: "MonitoringCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
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
        if IS_LOGIN {
            //获取监控企业列表
            getMonitoringCompanyInfo()
            //获取监控人员列表
            getMonitoringPeopleInfo()
        }else {
            self.noLoginUI()
        }
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getMonitoringCompanyInfo()
            getMonitoringPeopleInfo()
        })
        
        //添加上拉加载更多
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getMonitoringCompanyInfo()
            getMonitoringPeopleInfo()
        })
    }
    
}

extension DailyReportViewController {
    
    //获取监控企业列表
    func getMonitoringCompanyInfo() {
        ViewHud.addLoadView()
        let dict = ["time": "today",
                    "pageNum": pageNum,
                    "pageSize": pageSize] as [String : Any]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/riskmonitor/riskmonitoring/monitoringEnterprises",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
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
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取监控人员列表
    func getMonitoringPeopleInfo() {
        ViewHud.addLoadView()
        let dict = ["time": "today",
                    "pageNum": pageNum,
                    "pageSize": pageSize] as [String : Any]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/riskmonitor/riskmonitoring/monitorPerson",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                break
            case .failure(_):
                break
            }
        }
    }
    
}

extension DailyReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = .init(cssStr: "#F8F9FB")
        let descLabel = UILabel()
        descLabel.text = "已监控企业"
        descLabel.textColor = .init(cssStr: "#333333")
        descLabel.font = .regularFontOfSize(size: 12)
        headView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH * 0.75)
        }
        let groupBtn = UIButton(type: .custom)
        self.groupBtn = groupBtn
        groupBtn.setTitle("全部分组", for: .normal)
        groupBtn.setTitleColor(.init(cssStr: "#666666"), for: .normal)
        groupBtn.titleLabel?.font = .regularFontOfSize(size: 10)
        groupBtn.setImage(UIImage(named: "downgrayimge"), for: .normal)
        headView.addSubview(groupBtn)
        groupBtn.snp.makeConstraints { make in
            make.left.equalTo(SCREEN_WIDTH - 62)
            make.size.equalTo(CGSize(width: 52, height: 14))
            make.centerY.equalTo(descLabel.snp.centerY)
        }
        return headView
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonitoringCell", for: indexPath) as! MonitoringCell
        cell.textLabel?.text = "fdafad"
        return cell
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
    
    private func noLoginUI() {
        view.addSubview(iconImageView1)
        view.addSubview(iconImageView2)
        view.addSubview(iconImageView3)
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
            make.size.equalTo(CGSize(width: 118.5, height: 43))
        }
        iconImageView3
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                PushLoginConfig.popLogin(from: self)
        }).disposed(by: disposeBag)
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
            make.left.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(coverView.snp.bottom)
        }
        companyBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.companyBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
            self?.companyBtn.titleLabel?.font = .mediumFontOfSize(size: 14)
            self?.peopleBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
            self?.peopleBtn.titleLabel?.font = .regularFontOfSize(size: 14)
            self?.oneLineView.isHidden = false
            self?.twoLineView.isHidden = true
        }).disposed(by: disposeBag)
        
        peopleBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.peopleBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
            self?.peopleBtn.titleLabel?.font = .mediumFontOfSize(size: 14)
            self?.companyBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
            self?.companyBtn.titleLabel?.font = .regularFontOfSize(size: 14)
            self?.oneLineView.isHidden = true
            self?.twoLineView.isHidden = false
        }).disposed(by: disposeBag)
        
    }
    
}

extension DailyReportViewController: JXPagingViewListViewDelegate {
    
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
