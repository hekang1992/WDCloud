//
//  WDRiskViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/17.
//

import UIKit
import HGSegmentedPageViewController
import JXSegmentedView

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
    
    private lazy var segmentedView: JXSegmentedView = createSegmentedView()
    private lazy var cocsciew: UIScrollView = createCocsciew()
    private var segmurce: JXSegmentedTitleDataSource!
    private var listVCArray = [WDBaseViewController]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(ctImageView)
        addHeadView(from: headView)
        ctImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(233)
        }
        
        //添加切换
        addsentMentView()
        //添加子控制器
        setupViewControllers()
    }
    
}

extension WDRiskViewController: JXSegmentedViewDelegate {
    
    func addsentMentView() {
        ctImageView.addSubview(segmentedView)
        view.addSubview(cocsciew)
        segmentedView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(5)
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
        
        cocsciew.addSubview(oneVc.view)
        oneVc.naviController = navigationController
        listVCArray.append(oneVc)
        
        cocsciew.addSubview(twoVc.view)
        listVCArray.append(twoVc)
        
        cocsciew.addSubview(threeVc.view)
        listVCArray.append(threeVc)
        
        cocsciew.addSubview(fourVc.view)
        listVCArray.append(fourVc)
        
        updateViewControllersLayout()
        segmentedView(segmentedView, didSelectedItemAt: 0)
    }
    
    private func updateViewControllersLayout() {
        for (index, vc) in listVCArray.enumerated() {
            vc.view.frame = CGRect(x: SCREEN_WIDTH * CGFloat(index), y: 0, width: SCREEN_WIDTH, height: 1)
        }
    }
    
    private func createSegmentedView() -> JXSegmentedView {
        let segmentedView = JXSegmentedView()
        segmentedView.backgroundColor = .clear
        segmurce = JXSegmentedTitleDataSource()
        segmurce.titles = ["日报", "周报", "月报", "全部"]
        segmurce.isTitleColorGradientEnabled = true
        segmurce.titleSelectedFont = .mediumFontOfSize(size: 14)
        segmurce.titleNormalFont = .regularFontOfSize(size: 14)
        segmurce.titleNormalColor = (UIColor.init(cssStr: "#FFFFFF")?.withAlphaComponent(0.8))!
        segmurce.titleSelectedColor = UIColor.init(cssStr: "#FFFFFF")!
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
        indicator.indicatorColor = UIColor.init(cssStr: "#FFFFFF")!
        return indicator
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if index == 0 {
            let oneVc = listVCArray[0] as!DailyReportViewController
            oneVc.getListInfo()
        }else if index == 1 {
            
        }else if index == 2 {
            
        }else {
            
        }
    }
    
}
