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
        segmentedPageViewController.categoryView.backgroundColor = .clear
        segmentedPageViewController.categoryView.alignment = .center
        segmentedPageViewController.categoryView.itemSpacing = 25
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
            oneVc.headGrand = nameBtn.isSelected
            twoVc.headGrand = nameBtn.isSelected
        }).disposed(by: disposeBag)
        
        addSegmentedPageViewController()
        setupPageViewControllers()
        
    }

}

extension DueDiligenceViewController: HGSegmentedPageViewControllerDelegate {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nameBtn.layoutButtonEdgeInsets(style: .right, space: 8)
    }
    
    private func addSegmentedPageViewController() {
        self.addChild(self.segmentedPageViewController)
        self.view.addSubview(self.segmentedPageViewController.view)
        self.segmentedPageViewController.didMove(toParent: self)
        self.segmentedPageViewController.view.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(nameBtn.snp.bottom).offset(22)
        }
    }
    
    private func setupPageViewControllers() {
        let titles: [String] = ["基础班", "专业版", "定制版"]
        segmentedPageViewController.pageViewControllers = [oneVc, twoVc, threeVc]
        segmentedPageViewController.selectedPage = 0
        self.segmentedPageViewController.categoryView.titles = titles
        self.segmentedPageViewController.view.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(nameBtn.snp.bottom).offset(22)
        }
    }
    
}
