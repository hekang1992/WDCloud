//
//  WDRiskViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/17.
//

import UIKit
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
    
    var titles = ["日报", "周报", "月报", "全部"]
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    
    var segmentedView: JXSegmentedView!
    
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
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
        
        segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.titleSelectedColor = UIColor.init(cssStr: "#FFFFFF")!
        segmentedViewDataSource.titleNormalColor = UIColor.init(cssStr: "#FFFFFF")!.withAlphaComponent(0.6)
        segmentedViewDataSource.titleNormalFont = UIFont.mediumFontOfSize(size: 15)
        segmentedViewDataSource.titleSelectedFont = UIFont.mediumFontOfSize(size: 15)
        
        //指示器和指示器颜色
        segmentedView = JXSegmentedView()
        segmentedView.dataSource = segmentedViewDataSource
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorColor = UIColor.init(cssStr: "#FFFFFF")!
        indicator.lineStyle = .lengthen
        indicator.indicatorHeight = 2
        indicator.indicatorWidth = 15
        segmentedView.indicators = [indicator]
        ctImageView.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(18)
            make.left.right.equalToSuperview()
            make.height.equalTo(32)
        }
        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        listContainerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(52)
        }
    }
    
}

extension WDRiskViewController: JXSegmentedListContainerViewDataSource {
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            let vc = DailyReportViewController()
            if index == 0 {
               vc.titles = ["吃鸡🍗", "吃西瓜🍉", "吃热狗🌭"]
            }else {
                vc.titles = ["高尔夫🏌", "滑雪⛷", "自行车🚴"]
            }
            return vc
        }
        let vc = DailyReportViewController()
        if index == 0 {
           vc.titles = ["吃鸡🍗", "吃西瓜🍉", "吃热狗🌭"]
        }else {
            vc.titles = ["高尔夫🏌", "滑雪⛷", "自行车🚴"]
        }
        return vc
    }
    
}
