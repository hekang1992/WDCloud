//
//  DueDiligenceViewController.swift
//  问道云
//
//  Created by Andrew on 2024/12/3.
//

import UIKit
import JXSegmentedView

class DueDiligenceViewController: WDBaseViewController {
    
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
    
    lazy var oneVc: OneDueDiligenceViewController = {
        let oneVc = OneDueDiligenceViewController()
        return oneVc
    }()
    
    lazy var twoVc: TwoDueDiligenceViewController = {
        let twoVc = TwoDueDiligenceViewController()
        return twoVc
    }()
    
    lazy var threeVc: ThreeDueDiligenceViewController = {
        let threeVc = ThreeDueDiligenceViewController()
        return threeVc
    }()
    
    private lazy var segmentedView: JXSegmentedView = createSegmentedView()
    private lazy var cocsciew: UIScrollView = createCocsciew()
    private var segmurce: JXSegmentedTitleDataSource!
    private var listVCArray = [WDBaseViewController]()
    
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
            if IS_LOGIN {
                let settingVc = DueDiligenceSettingViewController()
                self?.navigationController?.pushViewController(settingVc, animated: true)
            }else {
                self?.popLogin()
            }
        }).disposed(by: disposeBag)
    }
}

extension DueDiligenceViewController: JXSegmentedViewDelegate {
    
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
        cocsciew.addSubview(oneVc.view)
        oneVc.nav = self.navigationController
        listVCArray.append(oneVc)
        
        cocsciew.addSubview(twoVc.view)
        twoVc.nav = self.navigationController
        listVCArray.append(twoVc)
        
        cocsciew.addSubview(threeVc.view)
        threeVc.nav = self.navigationController
        listVCArray.append(threeVc)
        
        updateViewControllersLayout()
        segmentedView(segmentedView, didSelectedItemAt: 0)
    }
    
    private func updateViewControllersLayout() {
        for (index, vc) in listVCArray.enumerated() {
            vc.view.frame = CGRect(x: SCREEN_WIDTH * CGFloat(index), y: 0, width: SCREEN_WIDTH, height: 1)
        }
    }
    
    private func createCocsciew() -> UIScrollView {
        let scrollView = UIScrollView()
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
        segmurce.titles = ["基础版", "专业版", "定制版"]
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
