//
//  FocusViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/15.
//  我的关注页面

import UIKit
import RxRelay
import JXSegmentedView
import HGSegmentedPageViewController

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
    
    lazy var companyVc: FocusCompanyViewController = {
        let companyVc = FocusCompanyViewController()
        return companyVc
    }()
    
    lazy var peopleVc: FocusPeopleViewController = {
        let peopleVc = FocusPeopleViewController()
        return peopleVc
    }()
    
    lazy var segmentedPageViewController: HGSegmentedPageViewController = {
        let segmentedPageViewController = HGSegmentedPageViewController()
        segmentedPageViewController.categoryView.alignment = .center
        segmentedPageViewController.categoryView.itemSpacing = 25
        segmentedPageViewController.categoryView.topBorder.isHidden = true
        segmentedPageViewController.categoryView.itemWidth = SCREEN_WIDTH * 0.25
        segmentedPageViewController.categoryView.vernierWidth = 15
        segmentedPageViewController.categoryView.titleNomalFont = .mediumFontOfSize(size: 14)
        segmentedPageViewController.categoryView.titleSelectedFont = .mediumFontOfSize(size: 14)
        segmentedPageViewController.categoryView.titleNormalColor = .init(cssStr: "#9FA4AD")
        segmentedPageViewController.categoryView.titleSelectedColor = .init(cssStr: "#333333")
        segmentedPageViewController.categoryView.vernier.backgroundColor = .init(cssStr: "#547AFF")
        segmentedPageViewController.delegate = self
        return segmentedPageViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(historyView)
        historyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addHeadView(from: headView)
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(StatusHeightManager.navigationBarHeight)
        }
        headView.twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            let searchVc = FocusSearchViewController()
            self?.navigationController?.pushViewController(searchVc, animated: false)
        }).disposed(by: disposeBag)
        //设置
        addSegmentedPageViewController()
        setupPageViewControllers()
    }
    
}

extension FocusAllViewController: HGSegmentedPageViewControllerDelegate {
    
    private func addSegmentedPageViewController() {
        self.addChild(self.segmentedPageViewController)
        self.view.addSubview(self.segmentedPageViewController.view)
        self.segmentedPageViewController.didMove(toParent: self)
        self.segmentedPageViewController.view.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom)
        }
    }
    
    private func setupPageViewControllers() {
        let titles: [String] = ["企业", "人员"]
        segmentedPageViewController.pageViewControllers = [companyVc, peopleVc]
        segmentedPageViewController.selectedPage = 0
        self.segmentedPageViewController.categoryView.titles = titles
        self.segmentedPageViewController.view.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom)
        }
    }

}
