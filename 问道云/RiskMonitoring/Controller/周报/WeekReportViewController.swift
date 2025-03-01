//
//  WeekReportViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/7.
//  周报

import UIKit
import JXPagingView
import JXSegmentedView

class WeekReportViewController: WDBaseViewController {
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    lazy var companyVc: WeekCompanyViewController = {
        let companyVc = WeekCompanyViewController()
        return companyVc
    }()
    
    lazy var peopleVc: WeekPeopleViewController = {
        let peopleVc = WeekPeopleViewController()
        return peopleVc
    }()
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    
    var segmentedView: JXSegmentedView!
    
    var JXTableHeaderViewHeight: Int = 0
    
    var JXheightForHeaderInSection: Int = 36
    
    lazy var pagingView: JXPagingView = preferredPagingView()
    
    var titles: [String] = ["企业", "个人"]
    
    lazy var noMonitoringView: RiskNoMonitoringView = {
        let noMonitoringView = RiskNoMonitoringView()
        noMonitoringView.isHidden = true
        return noMonitoringView
    }()
    
    lazy var noLoginView: RiskNoLoginView = {
        let noLoginView = RiskNoLoginView()
        noLoginView.isHidden = true
        return noLoginView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.titleSelectedColor = UIColor.init(cssStr: "#3849F7")!
        segmentedViewDataSource.titleNormalColor = UIColor.init(cssStr: "#333333")!.withAlphaComponent(0.6)
        segmentedViewDataSource.titleNormalFont = UIFont.mediumFontOfSize(size: 15)
        segmentedViewDataSource.titleSelectedFont = UIFont.mediumFontOfSize(size: 15)
        
        //指示器和指示器颜色
        segmentedView = JXSegmentedView(frame: CGRectMake(0, 0, SCREEN_WIDTH, CGFloat(JXheightForHeaderInSection)))
        segmentedView.dataSource = segmentedViewDataSource
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorColor = UIColor.init(cssStr: "#3849F7")!
        indicator.lineStyle = .lengthen
        indicator.indicatorHeight = 2
        indicator.indicatorWidth = 15
        segmentedView.indicators = [indicator]
        
        view.addSubview(pagingView)
        pagingView.isHidden = true
        pagingView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalToSuperview().offset(1)
            make.bottom.equalToSuperview()
        }
        segmentedView.listContainer = pagingView.listContainerView
        
        view.addSubview(noMonitoringView)
        noMonitoringView.block = { [weak self] in
            let searchVc = SearchMonitoringViewController()
            self?.navigationController?.pushViewController(searchVc, animated: true)
        }
        noMonitoringView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalToSuperview().offset(1)
            make.bottom.equalToSuperview()
        }
        view.addSubview(noLoginView)
        noLoginView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalToSuperview().offset(1)
            make.bottom.equalToSuperview()
        }
        noLoginView.loginBlock = { [weak self] in
            self?.popLogin()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if IS_LOGIN {
            //获取数字信息
            noLoginView.isHidden = true
            getNumInfo()
        }else {
            noLoginView.isHidden = false
        }
    }
    
}

extension WeekReportViewController {
    
    private func getNumInfo() {
        let dict = [String: Any]()
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitortarget/queryRiskMonitorEntity",
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self, let model = success.data {
                        showMonitoringView(from: model)
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func showMonitoringView(from model: DataModel) {
        let orgNum = model.orgNum ?? 0
        let personNum = model.personNum ?? 0
        let titles = ["企业\(orgNum)", "人员\(personNum)"]
        segmentedViewDataSource.titles = titles
        segmentedView.reloadData()
        
        if orgNum == 0 && personNum == 0 {
            self.pagingView.isHidden = true
            self.noMonitoringView.isHidden = false
        }else {
            self.pagingView.isHidden = false
            self.noMonitoringView.isHidden = true
        }
        
    }
    
}

extension WeekReportViewController: JXPagingViewDelegate {
    
    //一定要加上这句代码,否则不会下拉刷新
    func preferredPagingView() -> JXPagingView {
        return JXPagingListRefreshView(delegate: self)
    }
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return JXTableHeaderViewHeight
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        let headView = UIView()
        return headView
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return JXheightForHeaderInSection
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentedView
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return titles.count
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        if index == 0 {
            return companyVc
        }else {
            return peopleVc
        }
    }
    
}

extension WeekReportViewController: JXPagingViewListViewDelegate {
    
    func listView() -> UIView {
        return self.view
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }
    
    func listScrollView() -> UIScrollView { tableView }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
    
}
