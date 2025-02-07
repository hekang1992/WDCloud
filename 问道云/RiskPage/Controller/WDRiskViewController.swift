//
//  WDRiskViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit
import JXSegmentedView
import JXPagingView

class WDRiskViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .twoBtn)
        headView.titlelabel.text = "风险监控"
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
        return headView
    }()
    
    //头部view
    lazy var homeHeadView: RiskView = preferredTableHeaderView()
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    
    var segmentedView: JXSegmentedView!
    
    let titles = ["日报", "周报", "月报", "全部"]
    
    var JXTableHeaderViewHeight: Int = Int(StatusHeightManager.navigationBarHeight)
    
    var JXheightForHeaderInSection: Int = 36
    
    lazy var pagingView: JXPagingView = preferredPagingView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.titleSelectedColor = UIColor.init(cssStr: "#FFFFFF")!
        segmentedViewDataSource.titleNormalColor = (UIColor.init(cssStr: "#FFFFFF")?.withAlphaComponent(0.6))!
        segmentedViewDataSource.titleNormalFont = UIFont.regularFontOfSize(size: 15)
        segmentedViewDataSource.titleSelectedFont = UIFont.mediumFontOfSize(size: 15)
        
        //指示器和指示器颜色
        segmentedView = JXSegmentedView(frame: CGRectMake(0, 0, SCREEN_WIDTH, CGFloat(JXheightForHeaderInSection)))
        segmentedView.backgroundColor = UIColor.clear
        segmentedView.dataSource = segmentedViewDataSource
        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = UIColor.init(cssStr: "#FFFFFF")!
        lineView.indicatorWidth = 18
        lineView.indicatorHeight = 3
        segmentedView.indicators = [lineView]
        
        view.addSubview(pagingView)
        pagingView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        segmentedView.listContainer = pagingView.listContainerView
        //距离高度禁止
        pagingView.pinSectionHeaderVerticalOffset = Int(StatusHeightManager.navigationBarHeight)
        headView.titlelabel.text = "风险监控"
        addHeadView(from: headView)
    }

}

extension WDRiskViewController {
    //一定要加上这句代码,否则不会下拉刷新
    func preferredPagingView() -> JXPagingView {
        return JXPagingListRefreshView(delegate: self)
    }
    
    func preferredTableHeaderView() -> RiskView {
        let riskView = RiskView()
        return riskView
    }
    
}
    
extension WDRiskViewController: JXPagingViewDelegate {
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return JXTableHeaderViewHeight
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return homeHeadView
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
            let dailyVc = DailyReportViewController()
            return dailyVc
        }else if index == 1 {
            let weekVc = WeekReportViewController()
            return weekVc
        }else if index == 2 {
            let monthVc = MonthReportViewController()
            return monthVc
        }else {
            let bothVc = BothReportViewController()
            return bothVc
        }
    }
    
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        print("contentOffsetY======\(contentOffsetY)")
    }
}
