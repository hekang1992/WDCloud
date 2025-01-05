//
//  WDHomeViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit
import JXPagingView
import JXSegmentedView

extension JXPagingListContainerView: @retroactive JXSegmentedViewListContainer {}

class WDHomeViewController: WDBaseViewController {
    
    lazy var homeHeadView: HomeHeadView = {
        let homeHeadView = HomeHeadView()
        return homeHeadView
    }()
    
    var pagingView: JXPagingView!
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    
    var segmentedView: JXSegmentedView!
    
    let titles = ["问道头条", "问道讲堂"]
    
    var JXTableHeaderViewHeight: Int = 400
    
    var JXheightForHeaderInSection: Int = 36
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //首页头部view
        homeHeadView = HomeHeadView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: CGFloat(JXTableHeaderViewHeight)))
        
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.titleSelectedColor = UIColor.init(cssStr: "#333333")!
        segmentedViewDataSource.titleNormalColor = UIColor.init(cssStr: "#9FA4AD")!
        segmentedViewDataSource.titleNormalFont = UIFont.mediumFontOfSize(size: 15)
        segmentedViewDataSource.titleSelectedFont = UIFont.mediumFontOfSize(size: 15)
        
        //指示器和指示器颜色
        segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat(JXheightForHeaderInSection)))
        segmentedView.backgroundColor = UIColor.white
        segmentedView.dataSource = segmentedViewDataSource
        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = UIColor.init(cssStr: "#2353F0")!
        lineView.indicatorWidth = 18
        lineView.indicatorHeight = 3
        segmentedView.indicators = [lineView]
        
        pagingView = JXPagingView(delegate: self)
        view.addSubview(pagingView)
        pagingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        segmentedView.listContainer = pagingView.listContainerView
        pagingView.pinSectionHeaderVerticalOffset = Int(StatusHeightManager.navigationBarHeight + 20)
    }
    
}

extension WDHomeViewController: JXPagingViewDelegate {
    
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
            let newsListVc = HomeNewsListViewController()
            return newsListVc
        }else {
            let videoListVc = HomeVideoListViewController()
            return videoListVc
        }
    }
    
    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }
}
