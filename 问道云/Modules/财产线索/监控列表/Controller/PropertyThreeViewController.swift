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
        headView.oneBtn.setImage(UIImage(named: "rightHeadLogo"), for: .normal)
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
    
    var listArray: [WDBaseViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        headView.backBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.backBlock?()
        }).disposed(by: disposeBag)
        
        view.addSubview(ctImageView)
        ctImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(4.5)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-25)
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
        segmentedView(segmentedView, didSelectedItemAt: 0)
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
        segmentedView.delegate = self
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
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if index == 0 {
            if listArray.contains(bothVc) {
                return
            }
            bothVc.view.frame = CGRect(x: CGFloat(index) * SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: 1)
            cocsciew.addSubview(bothVc.view)
            addChild(bothVc)
            bothVc.didMove(toParent: self)
            listArray.append(bothVc)
        }else if index == 1 {
            if listArray.contains(companyVc) {
                return
            }
            companyVc.view.frame = CGRect(x: CGFloat(index) * SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - StatusHeightManager.navigationBarHeight - 40 - StatusHeightManager.tabBarHeight)
            cocsciew.addSubview(companyVc.view)
            addChild(companyVc)
            companyVc.didMove(toParent: self)
            listArray.append(companyVc)
        }else {
            if listArray.contains(peopleVc) {
                return
            }
            peopleVc.view.frame = CGRect(x: CGFloat(index) * SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - StatusHeightManager.navigationBarHeight - 40 - StatusHeightManager.tabBarHeight)
            cocsciew.addSubview(peopleVc.view)
            addChild(peopleVc)
            peopleVc.didMove(toParent: self)
            listArray.append(peopleVc)
        }
    }
    
}
