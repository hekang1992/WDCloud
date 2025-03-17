//
//  PropertyThreeViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/20.
//

import UIKit
import JXSegmentedView

class PropertyThreeViewController: WDBaseViewController {
    
    var backBlock: (() -> Void)?
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "监控列表"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setBackgroundImage(UIImage(named: "headrightoneicon"), for: .normal)
        return headView
    }()
    
    private lazy var segmentedView: JXSegmentedView = createSegmentedView()
    private lazy var cocsciew: UIScrollView = createCocsciew()
    private var segmurce: JXSegmentedTitleDataSource!
    private var listVCArray = [WDBaseViewController]()
    
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
        
        //添加切换
        addsentMentView()
        //添加子控制器
        setupViewControllers()
        
    }
}

extension PropertyThreeViewController: JXSegmentedViewDelegate {
    
    func addsentMentView() {
        view.addSubview(segmentedView)
        view.addSubview(cocsciew)
        segmentedView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(headView.snp.bottom)
            make.height.equalTo(40)
        }
        cocsciew.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(segmentedView.snp.bottom).offset(1)
        }
    }
    
    func setupViewControllers() {
        listVCArray.forEach { $0.view.removeFromSuperview() }
        listVCArray.removeAll()
        
        cocsciew.addSubview(bothVc.view)
        bothVc.navController = navigationController
        listVCArray.append(bothVc)
        
        cocsciew.addSubview(companyVc.view)
        listVCArray.append(companyVc)
        
        cocsciew.addSubview(peopleVc.view)
        listVCArray.append(peopleVc)
        
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
        segmentedView.backgroundColor = .white
        segmurce = JXSegmentedTitleDataSource()
        segmurce.titles = ["全部", "企业", "人员"]
        segmurce.isTitleColorGradientEnabled = true
        segmurce.titleSelectedFont = .mediumFontOfSize(size: 14)
        segmurce.titleNormalFont = .regularFontOfSize(size: 14)
        segmurce.titleNormalColor = UIColor.init(cssStr: "#9FA4AD")!
        segmurce.titleSelectedColor = UIColor.init(cssStr: "#333333")!
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
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH * 3, height: 0)
        return scrollView
    }
    
    private func createSegmentedIndicator() -> JXSegmentedIndicatorLineView {
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 15
        indicator.indicatorHeight = 4
        indicator.lineStyle = .normal
        indicator.indicatorColor = UIColor.init(cssStr: "#547AFF")!
        return indicator
    }
    
}
