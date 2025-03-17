//
//  CompanyBothViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/12.
//

import UIKit
import RxRelay
import JXSegmentedView

class CompanyBothViewController: WDBaseViewController {
    
    //企业ID
    var enityId = BehaviorRelay<String>(value: "")
    
    //企业名称
    var companyName = BehaviorRelay<String>(value: "")
    
    //是否刷新搜索列表页面
    var refreshBlock: ((Int) -> Void)?
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.headTitleView.isHidden = false
        headView.titlelabel.isHidden = true
        headView.oneBtn.setBackgroundImage(UIImage(named: "headrightoneicon"), for: .normal)
        return headView
    }()
    
    let segmentedView = JXSegmentedView()
    let segmentedDataSource = JXSegmentedTitleDataSource()
    let contentScrollView = UIScrollView()
    
    lazy var companyDetailVc: CompanyDetailViewController = {
        let companyDetailVc = CompanyDetailViewController()
        companyDetailVc.enityId = self.enityId.value
        companyDetailVc.refreshBlock = { [weak self] index in
            self?.refreshBlock?(index)
        }
        return companyDetailVc
    }()
    
    lazy var activityDetailVc: CompanyActivityViewController = {
        let activityDetailVc = CompanyActivityViewController()
        activityDetailVc.enityId = self.enityId.value
        return activityDetailVc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        
        setheadUI()
        companyDetailVc.intBlock = { [weak self] contentY in
            guard let self = self else { return }
            if contentY >= 200 {
                self.headView.headTitleView.isHidden = true
                self.headView.titlelabel.isHidden = false
                self.headView.titlelabel.text = companyName.value
            }else {
                self.headView.headTitleView.isHidden = false
                self.headView.titlelabel.isHidden = true
            }
        }
    }
}

extension CompanyBothViewController: JXSegmentedViewDelegate {
    
    private func setheadUI() {
        segmentedDataSource.titles = ["企业", "动态"]
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedDataSource.titleSelectedColor = UIColor(cssStr: "#333333")!
        segmentedDataSource.titleNormalColor = UIColor(cssStr: "#999999")!
        segmentedDataSource.titleNormalFont = .mediumFontOfSize(size: 15)
        segmentedDataSource.titleSelectedFont = segmentedDataSource.titleNormalFont
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedView.dataSource = segmentedDataSource
        segmentedView.backgroundColor = .white
        segmentedView.delegate = self
        
        // 设置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 16
        indicator.indicatorHeight = 4
        indicator.indicatorColor = UIColor.init(cssStr: "#547AFF")!
        segmentedView.indicators = [indicator]
        self.headView.headTitleView.addSubview(segmentedView)
        segmentedView.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        setupContentScrollView()
        segmentedView.contentScrollView = contentScrollView
    }
    
    func setupContentScrollView() {
        contentScrollView.isPagingEnabled = true
        contentScrollView.bounces = false
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.showsHorizontalScrollIndicator = false
        view.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(headView.snp.bottom)
        }
        contentScrollView.contentSize = CGSize(width: view.bounds.width * 2, height: contentScrollView.bounds.height)
        
        let modules = [companyDetailVc, activityDetailVc]
        for (index, vc) in modules.enumerated() {
            vc.view.frame = CGRect(x: CGFloat(index) * view.bounds.width, y: 0, width: view.bounds.width, height: contentScrollView.bounds.height)
            contentScrollView.addSubview(vc.view)
            addChild(vc)
            vc.didMove(toParent: self)
        }
    }
    
}
