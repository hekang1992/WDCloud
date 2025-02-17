//
//  DueDiligenceViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/17.
//

import UIKit
import HGSegmentedPageViewController

class DueDiligenceViewController: WDBaseViewController {
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "appheadbgimage")
        ctImageView.isUserInteractionEnabled = true
        return ctImageView
    }()
    
    lazy var nameBtn: UIButton = {
        let nameBtn = UIButton(type: .custom)
        nameBtn.setTitle("企业尽职调查", for: .normal)
        nameBtn.setTitleColor(.white, for: .normal)
        nameBtn.titleLabel?.font = .mediumFontOfSize(size: 18)
        nameBtn.setImage(UIImage(named: "changimagebtn"), for: .normal)
        return nameBtn
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setImage(UIImage(named: "shezhianniuimage"), for: .normal)
        oneBtn.adjustsImageWhenHighlighted = false
        return oneBtn
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
        view.addSubview(ctImageView)
        ctImageView.addSubview(nameBtn)
        ctImageView.addSubview(oneBtn)
        ctImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(233)
        }
        nameBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(StatusHeightManager.statusBarHeight + 10)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
            make.width.equalTo(250)
        }
        oneBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nameBtn.snp.centerY)
            make.right.equalToSuperview().offset(-14)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        nameBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            nameBtn.isSelected.toggle()
            nameBtn.setTitle(nameBtn.isSelected ? "专项尽职调查" : "企业尽职调查", for: .normal)
        }).disposed(by: disposeBag)
        
//        addSegmentedPageViewController()
//        setupPageViewControllers()
        
    }

}

extension DueDiligenceViewController: HGSegmentedPageViewControllerDelegate {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nameBtn.layoutButtonEdgeInsets(style: .right, space: 8)
    }
    
//    private func addSegmentedPageViewController() {
//        self.addChild(self.segmentedPageViewController)
//        self.view.addSubview(self.segmentedPageViewController.view)
//        self.segmentedPageViewController.didMove(toParent: self)
//        self.segmentedPageViewController.view.snp.makeConstraints { make in
//            make.left.bottom.right.equalToSuperview()
//            make.top.equalTo(headView.snp.bottom)
//        }
//    }
//    
//    private func setupPageViewControllers() {
//        let titles: [String] = ["企业", "人员"]
//        segmentedPageViewController.pageViewControllers = [companyVc, peopleVc]
//        segmentedPageViewController.selectedPage = 0
//        self.segmentedPageViewController.categoryView.titles = titles
//        self.segmentedPageViewController.view.snp.makeConstraints { make in
//            make.left.bottom.right.equalToSuperview()
//            make.top.equalTo(headView.snp.bottom)
//        }
//    }
    
}
