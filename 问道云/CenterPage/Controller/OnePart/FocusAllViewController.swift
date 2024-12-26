//
//  FocusViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/15.
//  我的关注页面

import UIKit
import RxRelay
import JXSegmentedView

class FocusAllViewController: WDBaseViewController {
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .twoBtn)
        headView.oneBtn.setImage(UIImage(named: "santiaogang"), for: .normal)
        headView.twoBtn.setImage(UIImage(named: "sesachiamge"), for: .normal)
        headView.titlelabel.text = "我的关注"
        return headView
    }()
    
    lazy var historyView: HistoryView = {
        let historyView = HistoryView()
        historyView.backgroundColor = .white
        return historyView
    }()
    
    private lazy var segmentedView: JXSegmentedView = createSegmentedView()
    private lazy var cocsciew: UIScrollView = createCocsciew()
    private var segmurce: JXSegmentedTitleDataSource!
    private var listVCArray = [WDBaseViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(historyView)
        historyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        historyView.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(StatusHeightManager.navigationBarHeight)
        }
        //添加切换
        addsentMentView()
        //添加子控制器
        setupViewControllers()
        headView.twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            let searchVc = FocusSearchViewController()
            self?.navigationController?.pushViewController(searchVc, animated: false)
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentedView(segmentedView, didSelectedItemAt: 0)
    }
    
}

extension FocusAllViewController: JXSegmentedViewDelegate, UIScrollViewDelegate {
    
    //代理方法
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if index == 0 {
            let oneVc = self.listVCArray[0] as! FocusCompanyViewController
            oneVc.getAllGroup()
            oneVc.getRegion()
            oneVc.getIndustry()
            oneVc.getFocusCompanyList()
        }else {
            let twoVc = self.listVCArray[1] as! FocusPeopleViewController
            twoVc.getAllGroup()
            twoVc.getRegion()
            twoVc.getIndustry()
            twoVc.getFocusPeopleList()
        }
    }
    
    func addsentMentView() {
        historyView.addSubview(segmentedView)
        historyView.addSubview(cocsciew)
        segmentedView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(12)
            make.height.equalTo(32)
        }
        cocsciew.frame = CGRectMake(0, StatusHeightManager.navigationBarHeight + 44, SCREEN_WIDTH, SCREEN_HEIGHT - StatusHeightManager.navigationBarHeight - 44)
    }
    
    func setupViewControllers() {
        listVCArray.forEach { $0.view.removeFromSuperview() }
        listVCArray.removeAll()
        
        let onevc = FocusCompanyViewController()
        cocsciew.addSubview(onevc.view)
        listVCArray.append(onevc)
        
        let twovc = FocusPeopleViewController()
        cocsciew.addSubview(twovc.view)
        listVCArray.append(twovc)
        
        updateViewControllersLayout()
    }
    
    private func updateViewControllersLayout() {
        for (index, vc) in listVCArray.enumerated() {
            vc.view.frame = CGRect(x: SCREEN_WIDTH * CGFloat(index), y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - StatusHeightManager.navigationBarHeight - 44)
        }
    }
    
    private func createSegmentedView() -> JXSegmentedView {
        let segmentedView = JXSegmentedView()
        segmentedView.delegate = self
        segmentedView.backgroundColor = .white
        segmurce = JXSegmentedTitleDataSource()
        segmurce.titles = ["企业", "人员"]
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
    
}
