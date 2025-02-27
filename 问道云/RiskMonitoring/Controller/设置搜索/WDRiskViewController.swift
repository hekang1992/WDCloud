//
//  WDRiskViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/17.
//

import UIKit
import HGSegmentedPageViewController
import JXSegmentedView
import JXPagingView

class WDRiskViewController: WDBaseViewController {
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "appheadbgimage")
        ctImageView.isUserInteractionEnabled = true
        return ctImageView
    }()
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .twoBtn)
        headView.titlelabel.text = "风险监控"
        headView.lineView.isHidden = true
        headView.titlelabel.textColor = .white
        headView.bgView.backgroundColor = .clear
        headView.oneBtn.setImage(UIImage(named: "pluscircleimage"), for: .normal)
        headView.twoBtn.setImage(UIImage(named: "shezhianniuimage"), for: .normal)
        headView.backBtn.isHidden = true
        headView.oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let searchVc = SearchMonitoringViewController()
            self.navigationController?.pushViewController(searchVc, animated: true)
        }).disposed(by: disposeBag)
        headView.twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let settingVc = RiskSettingViewController()
            self.navigationController?.pushViewController(settingVc, animated: true)
        }).disposed(by: disposeBag)
        return headView
    }()
    
    lazy var oneVc: DailyReportViewController = {
        let oneVc = DailyReportViewController()
        return oneVc
    }()
    
    lazy var twoVc: WeekReportViewController = {
        let twoVc = WeekReportViewController()
        return twoVc
    }()
    
    lazy var threeVc: MonthReportViewController = {
        let threeVc = MonthReportViewController()
        return threeVc
    }()
    
    lazy var fourVc: BothReportViewController = {
        let fourVc = BothReportViewController()
        return fourVc
    }()
    
    var titles = ["日报", "周报", "月报", "全部"]
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    
    var segmentedView: JXSegmentedView!
    
    var JXTableHeaderViewHeight: Int = 0
    
    var JXheightForHeaderInSection: Int = 36
    
    lazy var pagingView: JXPagingView = preferredPagingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(ctImageView)
        addHeadView(from: headView)
        ctImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(233)
        }
        
        segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.titleSelectedColor = UIColor.init(cssStr: "#FFFFFF")!
        segmentedViewDataSource.titleNormalColor = UIColor.init(cssStr: "#FFFFFF")!.withAlphaComponent(0.6)
        segmentedViewDataSource.titleNormalFont = UIFont.mediumFontOfSize(size: 15)
        segmentedViewDataSource.titleSelectedFont = UIFont.mediumFontOfSize(size: 15)
        
        //指示器和指示器颜色
        segmentedView = JXSegmentedView(frame: CGRectMake(0, 0, SCREEN_WIDTH, CGFloat(JXheightForHeaderInSection)))
        segmentedView.dataSource = segmentedViewDataSource
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorColor = UIColor.init(cssStr: "#FFFFFF")!
        indicator.lineStyle = .lengthen
        indicator.indicatorHeight = 2
        indicator.indicatorWidth = 15
        segmentedView.indicators = [indicator]
        
        view.addSubview(pagingView)
        pagingView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(headView.snp.bottom).offset(18)
            make.bottom.equalToSuperview()
        }
        pagingView.mainTableView.backgroundColor = .clear
        segmentedView.listContainer = pagingView.listContainerView
    }
    
}

extension WDRiskViewController: JXPagingViewDelegate {

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
            let oneRiskVc = DailyReportViewController()
            return oneRiskVc
        }else if index == 1 {
            let twoRiskVc = WeekReportViewController()
            return twoRiskVc
        }else if index == 2 {
            let threeRiskVc = MonthReportViewController()
            return threeRiskVc
        }else {
            let fourRiskVc = BothReportViewController()
            return fourRiskVc
        }
    }
}
