//
//  PropertyLineBothViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/12.
//

import UIKit
import RxRelay
import JXSegmentedView
import TYAlertController

class PropertyLineBothViewController: WDBaseViewController {
    
    //企业ID
    var enityId = BehaviorRelay<String>(value: "")
    
    //企业名称
    var companyName = BehaviorRelay<String>(value: "")
    
    var logoUrl: String = ""
    
    var monitor: Bool = true
    
    //是否刷新搜索列表页面
    var refreshBlock: ((Int) -> Void)?
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .twoBtn)
        headView.headTitleView.isHidden = false
        headView.titlelabel.isHidden = true
        headView.oneBtn.setImage(UIImage(named: "moreniacion"), for: .normal)
        headView.twoBtn.setImage(UIImage(named: "rightHeadLogo"), for: .normal)
        return headView
    }()
    
    let segmentedView = JXSegmentedView()
    let segmentedDataSource = JXSegmentedTitleDataSource()
    let contentScrollView = UIScrollView()
    
    lazy var oneVc: PropertyLineOneViewController = {
        let oneVc = PropertyLineOneViewController()
        return oneVc
    }()
    
    lazy var twoVc: PropertyLineTwoViewController = {
        let twoVc = PropertyLineTwoViewController()
        return twoVc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        headView.oneBlock = { [weak self] in
            guard let self = self else { return }
            let moreView = PopRightMoreView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 300))
            let alertVc = TYAlertController(alert: moreView, preferredStyle: .actionSheet)!
            self.present(alertVc, animated: true)
            
            moreView.cancelBlock = { [weak self] in
                self?.dismiss(animated: true)
            }
            moreView.oneBlock = { [weak self] in
                self?.dismiss(animated: true)
                ToastViewConfig.showToast(message: "尽请期待")
            }
            moreView.twoBlock = { [weak self] in
                self?.dismiss(animated: true, completion: {
                    let downloadVc = MyDownloadViewController()
                    self?.navigationController?.pushViewController(downloadVc, animated: true)
                })
            }
            moreView.threeBlock = { [weak self] in
                self?.dismiss(animated: true, completion: {
                    let errorVc = DataErrorCorrectionViewController()
                    self?.navigationController?.pushViewController(errorVc, animated: true)
                })
            }
            moreView.fourBlock = { [weak self] in
                self?.dismiss(animated: true, completion: {
                    self?.navigationController?.popToRootViewController(animated: true)
                })
            }
            moreView.fiveBlock = { [weak self] in
                self?.dismiss(animated: true)
            }
            moreView.sixBlock = { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: {
                    let activityViewController = UIActivityViewController(activityItems: ["https://www.wintaocloud.com/"], applicationActivities: nil)
                    if let popoverController = activityViewController.popoverPresentationController {
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                        popoverController.permittedArrowDirections = .down
                    }
                    self.present(activityViewController, animated: true, completion: nil)
                })
                
            }
            
        }
        headView.twoBlock = { [weak self] in
            guard let self = self else { return }
            let searchVc = SearchAllViewController()
            searchVc.searchHeadView.searchTx.placeholder = self.companyName.value
            self.navigationController?.pushViewController(searchVc, animated: false)
        }
        setheadUI()

    }
}

extension PropertyLineBothViewController: JXSegmentedViewDelegate {
    
    private func setheadUI() {
        segmentedDataSource.titles = ["财产线索", "资产状况"]
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
        
        let modules = [oneVc, twoVc]
        for (index, vc) in modules.enumerated() {
            vc.view.frame = CGRect(x: CGFloat(index) * view.bounds.width, y: 0, width: view.bounds.width, height: contentScrollView.bounds.height)
            contentScrollView.addSubview(vc.view)
            addChild(vc)
            vc.didMove(toParent: self)
        }
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if index == 0 {
            oneVc.entityId = enityId.value
            oneVc.entityName = companyName.value
            oneVc.monitor = monitor
            oneVc.logoUrl = logoUrl
        }else {
            
        }
    }
    
}
