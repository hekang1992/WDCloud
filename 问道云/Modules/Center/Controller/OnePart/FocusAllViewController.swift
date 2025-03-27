//
//  FocusViewController.swift
//  问道云
//
//  Created by Andrew on 2024/12/15.
//  我的关注页面

import UIKit
import RxRelay
import JXSegmentedView

class FocusAllViewController: WDBaseViewController {
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .twoBtn)
        headView.oneBtn.setImage(UIImage(named: "santiaogang"), for: .normal)
        headView.twoBtn.setImage(UIImage(named: "sesachiamge"), for: .normal)
        headView.titlelabel.text = "我的关注"
        return headView
    }()
    
    lazy var companyVc: FocusCompanyViewController = {
        let companyVc = FocusCompanyViewController()
        return companyVc
    }()
    
    lazy var peopleVc: FocusPeopleViewController = {
        let peopleVc = FocusPeopleViewController()
        return peopleVc
    }()
    
    private lazy var segmentedView: JXSegmentedView = createSegmentedView()
    
    private lazy var cocsciew: UIScrollView = createCocsciew()
    
    private var segmurce: JXSegmentedTitleDataSource!
    
    private var listVCArray = [WDBaseViewController]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(StatusHeightManager.navigationBarHeight)
        }
        headView.twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            let searchVc = FocusSearchViewController()
            self?.navigationController?.pushViewController(searchVc, animated: false)
        }).disposed(by: disposeBag)
        
        //添加切换
        addsentMentView()
        
        //添加子控制器
        segmentedView(segmentedView, didSelectedItemAt: 0)
    }
    
}

extension FocusAllViewController: JXSegmentedViewDelegate {
    
    func addsentMentView() {
        view.addSubview(segmentedView)
        view.addSubview(cocsciew)
        segmentedView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
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
        segmentedView.delegate = self
        segmentedView.backgroundColor = .white
        segmurce = JXSegmentedTitleDataSource()
        segmurce.titles = ["企业", "人员"]
        segmurce.isTitleColorGradientEnabled = true
        segmurce.titleSelectedFont = .mediumFontOfSize(size: 14)
        segmurce.titleNormalFont = .regularFontOfSize(size: 14)
        segmurce.titleNormalColor = UIColor.init(cssStr: "#666666")!
        segmurce.titleSelectedColor = UIColor.init(cssStr: "#333333")!
        segmentedView.dataSource = segmurce
        let indicator = createSegmentedIndicator()
        segmentedView.indicators = [indicator]
        segmentedView.contentScrollView = cocsciew
        return segmentedView
    }
    
    private func createSegmentedIndicator() -> JXSegmentedIndicatorLineView {
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 16
        indicator.indicatorHeight = 4
        indicator.lineStyle = .normal
        indicator.indicatorColor = UIColor.init(cssStr: "#547AFF")!
        return indicator
    }
    
    private func createCocsciew() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.init(cssStr: "#F5F5F5")
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH * 2, height: 0)
        return scrollView
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if index == 0 {
            cocsciew.addSubview(companyVc.view)
            listVCArray.append(companyVc)
            companyVc.view.frame = CGRect(x: SCREEN_WIDTH * CGFloat(index), y: 0, width: SCREEN_WIDTH, height: cocsciew.frame.height)
            companyVc.nav = navigationController
            DispatchQueue.main.asyncAfter(delay: 0.5) {
                self.companyVc.getCompanyAllInfo()
            }   
        }else {
            cocsciew.addSubview(peopleVc.view)
            listVCArray.append(peopleVc)
            peopleVc.view.frame = CGRect(x: SCREEN_WIDTH * CGFloat(index), y: 0, width: SCREEN_WIDTH, height: cocsciew.frame.height)
            peopleVc.nav = navigationController
            DispatchQueue.main.asyncAfter(delay: 0.5) {
                self.peopleVc.getPeopleAllInfo()
            }
        }
    }
    
}
