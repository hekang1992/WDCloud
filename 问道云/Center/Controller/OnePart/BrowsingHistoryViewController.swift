//
//  BrowsingHistoryViewController.swift
//  问道云
//
//  Created by Andrew on 2024/12/15.
//  浏览历史页面

import UIKit
import RxRelay
import JXSegmentedView

class BrowsingHistoryViewController: WDBaseViewController {
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "浏览历史"
        return headView
    }()
    
    private lazy var segmentedView: JXSegmentedView = createSegmentedView()
    private lazy var cocsciew: UIScrollView = createCocsciew()
    private var segmurce: JXSegmentedTitleDataSource!
    private var listVCArray = [HistoryListViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(StatusHeightManager.navigationBarHeight)
        }
        //添加切换
        addsentMentView()
        //添加子控制器
        setupViewControllers()
    }

}

extension BrowsingHistoryViewController: JXSegmentedViewDelegate {
    
    func addsentMentView() {
        view.addSubview(segmentedView)
        view.addSubview(cocsciew)
        segmentedView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom)
            make.height.equalTo(32)
        }
        cocsciew.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(segmentedView.snp.bottom).offset(1)
        }
    }
    
    func setupViewControllers() {
        listVCArray.forEach { $0.view.removeFromSuperview() }
        listVCArray.removeAll()
        for _ in 0..<4 {
            let vc = HistoryListViewController()
            vc.navController = navigationController
            cocsciew.addSubview(vc.view)
            listVCArray.append(vc)
        }
        
        updateViewControllersLayout()
        segmentedView(segmentedView, didSelectedItemAt: 0)
    }
    
    private func updateViewControllersLayout() {
        for (index, vc) in listVCArray.enumerated() {
            vc.view.frame = CGRect(x: SCREEN_WIDTH * CGFloat(index), y: 0, width: SCREEN_WIDTH, height: 1)
        }
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if index == 0 {
            let oneVc = self.listVCArray[0] 
            oneVc.getHistroyListInfo(from: "", pageNum: 1)
        }else if index == 1 {
            let twoVc = self.listVCArray[1]
            twoVc.getHistroyListInfo(from: "1", pageNum: 1)
        }else if index == 2 {
            let threeVc = self.listVCArray[2]
            threeVc.getHistroyListInfo(from: "2", pageNum: 1)
        }else {
            let fourVc = self.listVCArray[3]
            fourVc.getHistroyListInfo(from: "3", pageNum: 1)
        }
    }
    
    private func createSegmentedView() -> JXSegmentedView {
        let segmentedView = JXSegmentedView()
        segmentedView.delegate = self
        segmentedView.backgroundColor = .white
        segmurce = JXSegmentedTitleDataSource()
        segmurce.titles = ["全部", "企业", "人员", "其他"]
        segmurce.isTitleColorGradientEnabled = true
        segmurce.titleSelectedFont = .mediumFontOfSize(size: 14)
        segmurce.titleNormalFont = .regularFontOfSize(size: 14)
        segmurce.titleNormalColor = UIColor.init(cssStr: "#666666")!
        segmurce.titleSelectedColor = UIColor.init(cssStr: "#333333")!
        segmentedView.dataSource = segmurce
        let indicator = createSegmentedIndicator()
        segmentedView.indicators = [indicator]
        segmentedView.contentScrollView = cocsciew
        return segmentedView
    }
    
    private func createCocsciew() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.init(cssStr: "#F5F5F5")
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH * 4, height: 0)
        return scrollView
    }
    
    private func createSegmentedIndicator() -> JXSegmentedIndicatorLineView {
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.indicatorHeight = 2
        indicator.lineStyle = .lengthen
        indicator.indicatorColor = UIColor.init(cssStr: "#547AFF")!
        return indicator
    }
    
}
