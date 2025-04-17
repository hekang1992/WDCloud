//
//  PeopleBothViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/15.
//  个人总详情

import UIKit
import RxRelay
import JXSegmentedView

class PeopleBothViewController: WDBaseViewController {
    
    //个人ID
    var personId = BehaviorRelay<String>(value: "")
    
    //个人名称
    var peopleName = BehaviorRelay<String>(value: "")
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.headTitleView.isHidden = false
        headView.titlelabel.isHidden = true
        headView.oneBtn.setImage(UIImage(named: "rightHeadLogo"), for: .normal)
        return headView
    }()
    
    let segmentedView = JXSegmentedView()
    let segmentedDataSource = JXSegmentedTitleDataSource()
    let contentScrollView = UIScrollView()
    
    lazy var peopleDetailVc: PeopleDetailViewController = {
        let peopleDetailVc = PeopleDetailViewController()
        peopleDetailVc.personId = self.personId.value
        return peopleDetailVc
    }()
    
    lazy var activityDetailVc: PeopleActivityViewController = {
        let activityDetailVc = PeopleActivityViewController()
        activityDetailVc.personId = self.personId.value
        activityDetailVc.personName = self.peopleName.value
        return activityDetailVc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        
        setheadUI()
        
        peopleDetailVc.intBlock = { [weak self] contentY, name in
            guard let self = self else { return  }
            if contentY >= 200 {
                self.headView.headTitleView.isHidden = true
                self.headView.nameLabel.isHidden = false
                self.headView.nameLabel.text = name
            }else {
                self.headView.headTitleView.isHidden = false
                self.headView.nameLabel.isHidden = true
            }
        }
        
        peopleDetailVc.activityBlock = { [weak self] in
            guard let self = self else { return }
            self.segmentedView.selectItemAt(index: 1)
        }
        
    }
    
}

extension PeopleBothViewController: JXSegmentedViewDelegate {
    
    private func setheadUI() {
        segmentedDataSource.titles = ["个人", "动态"]
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
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.showsVerticalScrollIndicator = false
        view.addSubview(contentScrollView)
        contentScrollView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(headView.snp.bottom)
        }
        contentScrollView.contentSize = CGSize(width: SCREEN_WIDTH * 2, height: contentScrollView.bounds.height)
        
        let modules = [peopleDetailVc, activityDetailVc]
        for (index, vc) in modules.enumerated() {
            vc.view.frame = CGRect(x: CGFloat(index) * view.bounds.width, y: 0, width: SCREEN_WIDTH, height: contentScrollView.bounds.height)
            contentScrollView.addSubview(vc.view)
            addChild(vc)
            vc.didMove(toParent: self)
        }
    }
    
}
