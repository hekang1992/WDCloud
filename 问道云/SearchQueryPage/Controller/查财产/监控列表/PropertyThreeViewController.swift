//
//  PropertyThreeViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/20.
//

import UIKit
import HGSegmentedPageViewController

class PropertyThreeViewController: WDBaseViewController {
    
    var backBlock: (() -> Void)?
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "监控列表"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setImage(UIImage(named: "headrightoneicon"), for: .normal)
        return headView
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
    
    lazy var bothVc: PropertyThreeBothViewController = {
        let bothVc = PropertyThreeBothViewController()
        return bothVc
    }()
    
    lazy var companyVc: PropertyThreeCompanyViewController = {
        let companyVc = PropertyThreeCompanyViewController()
        return companyVc
    }()
    
    lazy var peopleVc: PropertyThreePeopleViewController = {
        let peopleVc = PropertyThreePeopleViewController()
        return peopleVc
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "jiankongtianjiaaddimage")
        ctImageView.isUserInteractionEnabled = true
        return ctImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        headView.backBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.backBlock?()
        }).disposed(by: disposeBag)
        
        addSegmentedPageViewController()
        setupPageViewControllers()
        
        view.addSubview(ctImageView)
        ctImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-4.5)
            make.bottom.equalToSuperview().offset(-25)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        ctImageView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let addVc = SearchAddPropertyViewController()
                self?.navigationController?.pushViewController(addVc, animated: true)
            }).disposed(by: disposeBag)
    }
}

extension PropertyThreeViewController: HGSegmentedPageViewControllerDelegate {
    
    private func addSegmentedPageViewController() {
        self.addChild(self.segmentedPageViewController)
        self.view.addSubview(self.segmentedPageViewController.view)
        self.segmentedPageViewController.didMove(toParent: self)
        self.segmentedPageViewController.view.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.headView.snp.bottom)
        }
    }
    
    private func setupPageViewControllers() {
        let titles: [String] = ["全部", "企业", "人员"]
        segmentedPageViewController.pageViewControllers = [bothVc, companyVc, peopleVc]
        segmentedPageViewController.selectedPage = 0
        self.segmentedPageViewController.categoryView.titles = titles
        self.segmentedPageViewController.view.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.headView.snp.bottom)
        }
    }
    
}
