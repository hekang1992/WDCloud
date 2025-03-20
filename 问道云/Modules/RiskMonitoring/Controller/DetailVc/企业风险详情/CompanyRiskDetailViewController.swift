//
//  CompanyRiskDetailViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/17.
//  风险详情页面

import UIKit
import JXSegmentedView
import JXPagingView
import SwiftyJSON

class CompanyRiskDetailViewController: WDBaseViewController {
    
    var enityId: String? {
        didSet {}
    }
    
    var name: String? {
        didSet {}
    }
    
    var logo: String? {
        didSet {}
    }
    
    var time: String? {
        didSet {}
    }
    
    var groupName: String? {
        didSet {}
    }
    
    var intBlock: ((Double) -> Void)?
    
    //头部view
    lazy var homeHeadView: CompanyRiskDetailHeadView = preferredTableHeaderView()
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    
    var segmentedView: JXSegmentedView!
    
    let titles = ["自身风险", "关联风险", "历史风险"]
    
    var JXTableHeaderViewHeight: Int = Int(84 + StatusHeightManager.navigationBarHeight)
    
    var JXheightForHeaderInSection: Int = 36
    
    lazy var pagingView: JXPagingView = preferredPagingView()
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        return headView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.titleSelectedColor = UIColor.init(cssStr: "#547AFF")!
        segmentedViewDataSource.titleNormalColor = UIColor.init(cssStr: "#9FA4AD")!
        segmentedViewDataSource.titleNormalFont = UIFont.mediumFontOfSize(size: 15)
        segmentedViewDataSource.titleSelectedFont = UIFont.mediumFontOfSize(size: 15)
        
        //指示器和指示器颜色
        segmentedView = JXSegmentedView(frame: CGRectMake(0, 0, SCREEN_WIDTH, CGFloat(JXheightForHeaderInSection)))
        segmentedView.backgroundColor = UIColor.white
        segmentedView.dataSource = segmentedViewDataSource
        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = UIColor.init(cssStr: "#547AFF ")!
        lineView.indicatorWidth = 18
        lineView.indicatorHeight = 3
        segmentedView.indicators = [lineView]
        
        view.addSubview(pagingView)
        pagingView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        segmentedView.listContainer = pagingView.listContainerView
        //距离高度禁止
        pagingView.pinSectionHeaderVerticalOffset = Int(StatusHeightManager.navigationBarHeight)
        headView.titlelabel.text = "企业风险信息"
        addHeadView(from: headView)
        //获取风险数据
//        getRiskDetailInfo()
    }
    
    //一定要加上这句代码,否则不会下拉刷新
    func preferredPagingView() -> JXPagingView {
        return JXPagingListRefreshView(delegate: self)
    }
    
    //头部
    func preferredTableHeaderView() -> CompanyRiskDetailHeadView {
        let header = CompanyRiskDetailHeadView()
        header.iconImageView.kf.setImage(with: URL(string: logo ?? ""), placeholder: UIImage.imageOfText(name ?? "", size: (45, 45)))
        header.namelabel.text = name
        header.timeLabel.text = "监控周期: \(time ?? "")"
        header.tagLabel.text = groupName ?? ""
        header.reportBtnBlock = { [weak self] in
            guard let self = self else { return }
            let oneRpVc = OneReportViewController()
            let entityid = enityId ?? ""
            let firmname = name ?? ""
            let json: JSON = ["orgId": entityid,
                              "orgName": firmname]
            let orgInfo = orgInfoModel(json: json)
            oneRpVc.orgInfo = orgInfo
            self.navigationController?.pushViewController(oneRpVc, animated: true)
        }
        
        //监控点击
        header.monitoringBtn
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                addMonitoringInfo { }
        }).disposed(by: disposeBag)
        
        return header
    }
    
    @objc func changeTableHeaderViewHeight() {
        pagingView.resizeTableHeaderViewHeight(animatable: true)
    }
    
}

/** 网络数据请求 */
extension CompanyRiskDetailViewController {
    
    private func addMonitoringInfo(complete: @escaping (() -> Void)) {
        let man = RequestManager()
        let dict = ["orgId": self.enityId ?? "", "groupId": ""]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitor-org/addRiskMonitorOrg",
                       method: .post) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    guard let self = self else { return }
                    let endDate = success.data?.endDate ?? ""
                    let startDate = success.data?.startDate ?? ""
                    homeHeadView.monitoringBtn.isHidden = true
                    showOrHideMonitoringInfo(from: 1, startTime: startDate, endTime: endDate, groupName: "默认分组")
                    ToastViewConfig.showToast(message: "监控成功")
                    complete()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //刷新头部监控按钮信息
    private func showOrHideMonitoringInfo(from monitorFlag: Int, startTime: String, endTime: String, groupName: String) {
        //头部信息
        if monitorFlag != 0 {
            let allTime = "监控周期:\(startTime) - \(endTime)"
            homeHeadView.timeLabel.text = allTime
            homeHeadView.tagLabel.text = groupName
            homeHeadView.tagLabel.isHidden = false
            homeHeadView.monitoringBtn.isHidden = true
        }else {
            homeHeadView.timeLabel.text = ""
            homeHeadView.tagLabel.isHidden = true
            homeHeadView.monitoringBtn.isHidden = false
        }
    }
    
}

extension CompanyRiskDetailViewController: JXPagingViewDelegate {
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return JXTableHeaderViewHeight
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return homeHeadView
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return JXheightForHeaderInSection
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentedView
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return titles.count
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        if index == 0 {
            let oneRiskVc = MySelfRiskDetailViewController()
            oneRiskVc.enityId = enityId ?? ""
            oneRiskVc.name = name ?? ""
            oneRiskVc.logo = logo ?? ""
            oneRiskVc.mainHeadView = homeHeadView
            return oneRiskVc
        }else if index == 1 {
            let twoRiskVc = UnioRiskDetailViewController()
            twoRiskVc.enityId = enityId ?? ""
            twoRiskVc.name = name ?? ""
            twoRiskVc.logo = logo ?? ""
            return twoRiskVc
        }else {
            let threeRiskVc = HistoryRiskDetailViewController()
            threeRiskVc.enityId = enityId ?? ""
            threeRiskVc.name = name ?? ""
            threeRiskVc.logo = logo ?? ""
            return threeRiskVc
        }
    }
    
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        print("contentOffsetY======\(contentOffsetY)")
        self.intBlock?(contentOffsetY)
    }
}
