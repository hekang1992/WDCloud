//
//  WDDiligenceViewController.swift
//  问道云
//
//  Created by Andrew on 2024/12/3.
//

import UIKit
import JXSegmentedView

class WDDiligenceViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "尽职调查"
        headView.lineView.isHidden = true
        headView.titlelabel.textColor = .white
        headView.bgView.backgroundColor = .clear
        headView.oneBtn.setImage(UIImage(named: "shezhianniuimage"), for: .normal)
        headView.backBtn.isHidden = true
        return headView
    }()
    
    lazy var diligenceView: DiligenceView = {
        let diligenceView = DiligenceView()
        return diligenceView
    }()
    
    private lazy var segmentedView: JXSegmentedView = createSegmentedView()
    private lazy var cocsciew: UIScrollView = createCocsciew()
    private var segmurce: JXSegmentedTitleDataSource!
    private var listVCArray = [DiligenceListViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(diligenceView)
        diligenceView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        diligenceView.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(StatusHeightManager.navigationBarHeight)
        }
        //添加切换
        addsentMentView()
        //添加子控制器
        setupViewControllers()
        headView.oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.popLogin()
        }).disposed(by: disposeBag)
    }
}

extension WDDiligenceViewController: JXSegmentedViewDelegate {
    
    func addsentMentView() {
        diligenceView.addSubview(segmentedView)
        diligenceView.addSubview(cocsciew)
        segmentedView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(18)
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
        for _ in 0..<2 {
            let vc = DiligenceListViewController()
            cocsciew.addSubview(vc.view)
            listVCArray.append(vc)
        }
        
        updateViewControllersLayout()
        segmentedView(segmentedView, didSelectedItemAt: 0)
    }
    
    private func updateViewControllersLayout() {
        for (index, vc) in listVCArray.enumerated() {
            vc.view.frame = CGRect(x: SCREEN_WIDTH * CGFloat(index), y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - segmentedView.frame.maxY)
        }
    }
    
    private func createCocsciew() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .random()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH * 3, height: 0)
        return scrollView
    }
    
    private func createSegmentedView() -> JXSegmentedView {
        let segmentedView = JXSegmentedView()
        segmentedView.delegate = self
        segmentedView.backgroundColor = .clear
        segmurce = JXSegmentedTitleDataSource()
        segmurce.titles = ["企业尽职调查", "专项尽职调查"]
        segmurce.isTitleColorGradientEnabled = true
        segmurce.titleSelectedFont = .mediumFontOfSize(size: 15)
        segmurce.titleNormalFont = .regularFontOfSize(size: 15)
        segmurce.titleNormalColor = UIColor.white.withAlphaComponent(0.6)
        segmurce.titleSelectedColor = .white
        
        segmentedView.dataSource = segmurce
        let indicator = createSegmentedIndicator()
        segmentedView.indicators = [indicator]
        segmentedView.contentScrollView = cocsciew
        return segmentedView
    }
    
    private func createSegmentedIndicator() -> JXSegmentedIndicatorLineView {
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 30
        indicator.indicatorHeight = 2
        indicator.lineStyle = .lengthen
        indicator.indicatorColor = .white
        return indicator
    }
    
}
