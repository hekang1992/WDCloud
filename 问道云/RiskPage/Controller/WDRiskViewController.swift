//
//  WDRiskViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/17.
//

import UIKit
import HGSegmentedPageViewController

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
    
    lazy var segmentedPageViewController: HGSegmentedPageViewController = {
        let segmentedPageViewController = HGSegmentedPageViewController()
        segmentedPageViewController.categoryView.backgroundColor = .clear
        segmentedPageViewController.categoryView.alignment = .center
        segmentedPageViewController.categoryView.itemSpacing = 0
        segmentedPageViewController.categoryView.leftMargin = 0
        segmentedPageViewController.categoryView.rightMargin = 0
        segmentedPageViewController.categoryView.topBorder.isHidden = true
        segmentedPageViewController.categoryView.itemWidth = SCREEN_WIDTH * 0.25
        segmentedPageViewController.categoryView.vernierWidth = 20
        segmentedPageViewController.categoryView.titleNomalFont = .mediumFontOfSize(size: 14)
        segmentedPageViewController.categoryView.titleSelectedFont = .mediumFontOfSize(size: 14)
        segmentedPageViewController.categoryView.titleNormalColor = .init(cssStr: "#FFFFFF")?.withAlphaComponent(0.6)
        segmentedPageViewController.categoryView.titleSelectedColor = .init(cssStr: "#FFFFFF")
        segmentedPageViewController.categoryView.vernier.backgroundColor = .init(cssStr: "#FFFFFF")
        segmentedPageViewController.delegate = self
        return segmentedPageViewController
    }()
    
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
        
        addSegmentedPageViewController()
        setupPageViewControllers()
        
    }
    
}

extension WDRiskViewController: HGSegmentedPageViewControllerDelegate {
    
    private func addSegmentedPageViewController() {
        self.addChild(self.segmentedPageViewController)
        self.view.addSubview(self.segmentedPageViewController.view)
        self.segmentedPageViewController.didMove(toParent: self)
        self.segmentedPageViewController.view.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(12)
        }
    }
    
    private func setupPageViewControllers() {
        let titles: [String] = ["日报", "周报", "月报", "全部"]
        segmentedPageViewController.pageViewControllers = [oneVc, twoVc, threeVc, fourVc]
        segmentedPageViewController.selectedPage = 0
        self.segmentedPageViewController.categoryView.titles = titles
        self.segmentedPageViewController.view.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(12)
        }
    }
    
}
