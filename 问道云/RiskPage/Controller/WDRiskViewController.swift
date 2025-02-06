//
//  WDRiskViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit
import JXSegmentedView

class WDRiskViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .twoBtn)
        headView.titlelabel.text = "风险监控"
        headView.titlelabel.textColor = .white
        headView.bgView.backgroundColor = .clear
        headView.oneBtn.setImage(UIImage(named: "pluscircleimage"), for: .normal)
        headView.twoBtn.setImage(UIImage(named: "shezhianniuimage"), for: .normal)
        headView.backBtn.isHidden = true
        return headView
    }()
    
    lazy var riskView: RiskView = {
        let riskView = RiskView()
        return riskView
    }()
    
    var timeArray = ["today", "week", "month", ""]
    
    private lazy var segmentedView: JXSegmentedView = createSegmentedView()
    private lazy var cocsciew: UIScrollView = createCocsciew()
    private var segmurce: JXSegmentedTitleDataSource!
    private var listVCArray = [RiskListViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(riskView)
        riskView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        riskView.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(StatusHeightManager.navigationBarHeight)
        }
        //添加切换
        addsentMentView()
        //添加子控制器
        setupViewControllers()
        headView.oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let searchVc = SearchMonitoringViewController()
            self.navigationController?.pushViewController(searchVc, animated: true)
        }).disposed(by: disposeBag)
    }

}

extension WDRiskViewController: JXSegmentedViewDelegate {
    
    func addsentMentView() {
        riskView.addSubview(segmentedView)
        riskView.addSubview(cocsciew)
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
        for i in 0..<4 {
            let vc = RiskListViewController()
            vc.time = timeArray[i]
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
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if index == 0 {
            let oneVc = self.listVCArray[0]
            oneVc.getMonitoringCompanyInfo()
            oneVc.backBlock = { [weak self] in
                let searchVc = SearchMonitoringViewController()
                self?.navigationController?.pushViewController(searchVc, animated: true)
            }
        }else if index == 1 {
            let twoVc = self.listVCArray[1]
            twoVc.getMonitoringCompanyInfo()
            twoVc.backBlock = { [weak self] in
                let searchVc = SearchMonitoringViewController()
                self?.navigationController?.pushViewController(searchVc, animated: true)
            }
        }else if index == 2 {
            let threeVc = self.listVCArray[2]
            threeVc.getMonitoringCompanyInfo()
            threeVc.backBlock = { [weak self] in
                let searchVc = SearchMonitoringViewController()
                self?.navigationController?.pushViewController(searchVc, animated: true)
            }
        }else {
            let fourVc = self.listVCArray[3]
            fourVc.getMonitoringCompanyInfo()
            fourVc.backBlock = { [weak self] in
                let searchVc = SearchMonitoringViewController()
                self?.navigationController?.pushViewController(searchVc, animated: true)
            }
        }
    }
    
    private func createSegmentedView() -> JXSegmentedView {
        let segmentedView = JXSegmentedView()
        segmentedView.delegate = self
        segmentedView.backgroundColor = .clear
        segmurce = JXSegmentedTitleDataSource()
        segmurce.titles = ["日报", "周报", "月报", "全部"]
        segmurce.isTitleColorGradientEnabled = true
        segmurce.titleSelectedFont = .mediumFontOfSize(size: 14)
        segmurce.titleNormalFont = .regularFontOfSize(size: 14)
        segmurce.titleNormalColor = .white
        segmurce.titleSelectedColor = .white
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
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH * 4, height: 0)
        return scrollView
    }
    
    private func createSegmentedIndicator() -> JXSegmentedIndicatorLineView {
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.indicatorHeight = 2
        indicator.lineStyle = .lengthen
        indicator.indicatorColor = .white
        return indicator
    }
    
}
