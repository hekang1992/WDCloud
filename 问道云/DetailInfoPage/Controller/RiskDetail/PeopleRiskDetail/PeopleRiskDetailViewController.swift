//
//  PeopleRiskDetailViewController.swift
//  问道云
//
//  Created by 何康 on 2025/1/17.
//

import UIKit
import JXSegmentedView
import JXPagingView

class PeopleRiskDetailViewController: WDBaseViewController {
    
    var enityId: String = ""
    
    var name: String = ""
    
    var intBlock: ((Double) -> Void)?
    
//    lazy var riskDetailView: RiskDetailView = {
//        let riskDetailView = RiskDetailView()
//        riskDetailView.backgroundColor = .white
//        return riskDetailView
//    }()
    
    //头部view
    lazy var homeHeadView: RiskDetailHeadView = preferredTableHeaderView()
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    
    var segmentedView: JXSegmentedView!
    
    let titles = ["自身风险", "关联风险", "历史风险"]
    
    var JXTableHeaderViewHeight: Int = Int(65 + StatusHeightManager.navigationBarHeight)
    
    var JXheightForHeaderInSection: Int = 36
    
    lazy var pagingView: JXPagingView = preferredPagingView()
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        return headView
    }()
    
    var functionType: String = ""// 1-自身风险，2-历史风险，3-日报，4-全部
    var dateType: String = ""
    var date: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.titleSelectedColor = UIColor.init(cssStr: "#333333")!
        segmentedViewDataSource.titleNormalColor = UIColor.init(cssStr: "#9FA4AD")!
        segmentedViewDataSource.titleNormalFont = UIFont.mediumFontOfSize(size: 15)
        segmentedViewDataSource.titleSelectedFont = UIFont.mediumFontOfSize(size: 15)
        
        //指示器和指示器颜色
        segmentedView = JXSegmentedView(frame: CGRectMake(0, 0, SCREEN_WIDTH, CGFloat(JXheightForHeaderInSection)))
        segmentedView.backgroundColor = UIColor.white
        segmentedView.dataSource = segmentedViewDataSource
        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = UIColor.init(cssStr: "#2353F0")!
        lineView.indicatorWidth = 18
        lineView.indicatorHeight = 3
        segmentedView.indicators = [lineView]
        
        view.addSubview(pagingView)
        pagingView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        segmentedView.listContainer = pagingView.listContainerView
        //距离高度禁止
        pagingView.pinSectionHeaderVerticalOffset = Int(StatusHeightManager.navigationBarHeight)
        headView.titlelabel.text = "个人风险信息"
        addHeadView(from: headView)
        //获取风险数据
        getRiskDetailInfo()
    }
    
    //一定要加上这句代码,否则不会下拉刷新
    func preferredPagingView() -> JXPagingView {
        return JXPagingListRefreshView(delegate: self)
    }
    
    //头部
    func preferredTableHeaderView() -> RiskDetailHeadView {
        let header = RiskDetailHeadView()
        //获取个人详情头部信息
        return header
    }
    
    @objc func changeTableHeaderViewHeight() {
        pagingView.resizeTableHeaderViewHeight(animatable: true)
    }
    
}

extension PeopleRiskDetailViewController {
#warning("获取人寰风险详情======数据不支持未开发")
    //获取风险详情
    private func getRiskDetailInfo() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["entityid": enityId,
                    "functionType": functionType,
                    "dateType": dateType,
                    "date": date]
        man.requestAPI(params: dict,
                       pageUrl: "/riskmonitor/riskmonitoring/riskDynamicslow",
                       method: .get) { result in
            switch result {
            case .success(let success):
                if let model = success.data {
                    
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}




extension PeopleRiskDetailViewController: JXPagingViewDelegate {
    
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
            let oneRiskVc = MySelfRiskDetailViewController()
            return oneRiskVc
        }else if index == 1 {
            let twoRiskVc = UnioRiskDetailViewController()
            return twoRiskVc
        }else {
            let threeRiskVc = HistoryRiskDetailViewController()
            return threeRiskVc
        }
    }
    
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        print("contentOffsetY======\(contentOffsetY)")
        self.intBlock?(contentOffsetY)
    }
}
