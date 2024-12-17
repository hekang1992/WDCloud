//
//  MyTicketViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/17.
//  我的开票

import UIKit
import RxRelay
import JXSegmentedView

class MyTicketViewController: WDBaseViewController {
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    private lazy var segmentedView: JXSegmentedView = createSegmentedView()
    private lazy var cocsciew: UIScrollView = createCocsciew()
    private var segmurce: JXSegmentedTitleDataSource!
    private var listVCArray = [WDBaseViewController]()
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "发票列表"
        return headView
    }()
    
    lazy var ticketView: MyTicketView = {
        let ticketView = MyTicketView()
        ticketView.backgroundColor = .white
        return ticketView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(ticketView)
        ticketView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        //添加切换
        addsentMentView()
        //添加子控制器
        setupViewControllers()
    }

}

extension MyTicketViewController: JXSegmentedViewDelegate {
    
    //代理方法
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        
    }
    
    private func createSegmentedView() -> JXSegmentedView {
        let segmentedView = JXSegmentedView()
        segmentedView.delegate = self
        segmentedView.backgroundColor = .white
        segmurce = JXSegmentedTitleDataSource()
        segmurce.titles = ["发票申请", "发票记录"]
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
        scrollView.backgroundColor = .white
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH * 2, height: 0)
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
    
    func addsentMentView() {
        ticketView.addSubview(segmentedView)
        ticketView.addSubview(cocsciew)
        segmentedView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(24)
            make.height.equalTo(32)
        }
        cocsciew.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(segmentedView.snp.bottom)
        }
    }
    
    func setupViewControllers() {
        listVCArray.forEach { $0.view.removeFromSuperview() }
        listVCArray.removeAll()
        let oneVc = OneTicketViewController()
        cocsciew.addSubview(oneVc.view)
        listVCArray.append(oneVc)
        
        let twoVc = TwoTicketViewController()
        cocsciew.addSubview(twoVc.view)
        listVCArray.append(twoVc)
        
        updateViewControllersLayout()
        segmentedView(segmentedView, didSelectedItemAt: 0)
    }
    
    private func updateViewControllersLayout() {
        for (index, vc) in listVCArray.enumerated() {
            vc.view.frame = CGRect(x: SCREEN_WIDTH * CGFloat(index), y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - segmentedView.frame.maxY)
        }
    }
    
}
