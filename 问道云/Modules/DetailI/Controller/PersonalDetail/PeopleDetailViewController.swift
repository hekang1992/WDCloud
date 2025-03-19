//
//  PeopleDetailViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/12.
//  企业详情

import UIKit
import JXSegmentedView
import JXPagingView

class PeopleDetailViewController: WDBaseViewController {
    
    var personId: String = ""
    
    var intBlock: ((Double) -> Void)?
    
    //简介
    lazy var infoView: CompanyDescInfoView = {
        let infoView = CompanyDescInfoView()
        return infoView
    }()
    
    //头部view
    lazy var homeHeadView: PeopleDetailHeadView = preferredTableHeaderView()
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    
    var segmentedView: JXSegmentedView!
    
    let titles = ["个人详情", "关联企业", "历史信息"]
    
    var JXTableHeaderViewHeight: Int = 385
    
    var JXheightForHeaderInSection: Int = 36
    
    lazy var pagingView: JXPagingView = preferredPagingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.titleSelectedColor = UIColor.init(cssStr: "#333333")!
        segmentedViewDataSource.titleNormalColor = UIColor.init(cssStr: "#9FA4AD")!
        segmentedViewDataSource.titleNormalFont = UIFont.mediumFontOfSize(size: 15)
        segmentedViewDataSource.titleSelectedFont = UIFont.mediumFontOfSize(size: 15)
        
        //指示器和指示器颜色
        segmentedView = JXSegmentedView(frame: CGRectMake(0, 0, SCREEN_WIDTH, CGFloat(JXheightForHeaderInSection)))
        segmentedView.backgroundColor = UIColor.white
        segmentedView.dataSource = segmentedViewDataSource
        segmentedView.defaultSelectedIndex = 1
        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = UIColor.init(cssStr: "#547AFF ")!
        lineView.indicatorWidth = 18
        lineView.indicatorHeight = 3
        segmentedView.indicators = [lineView]
        
        view.addSubview(pagingView)
        pagingView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        segmentedView.listContainer = pagingView.listContainerView
        //距离高度禁止
        pagingView.pinSectionHeaderVerticalOffset = 0
        //获取风险数据
        getPeopleRiskInfo()
        //获取图谱信息
        getAtlasInfo()
    }
    
    //一定要加上这句代码,否则不会下拉刷新
    func preferredPagingView() -> JXPagingView {
        return JXPagingListRefreshView(delegate: self)
    }
    
    //头部
    func preferredTableHeaderView() -> PeopleDetailHeadView {
        JXTableHeaderViewHeight = 385
        let header = PeopleDetailHeadView()
        //获取个人详情头部信息
        getPeopleHeadInfo()
        return header
    }
    
}

/** 网络数据请求*/
extension PeopleDetailViewController {
    
    //获取图谱信息
    private func getAtlasInfo() {
        let man = RequestManager()
        let appleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let dict = ["moduleType": "7",
                    "appleVersion": appleVersion,
                    "appType": "apple"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/customermenu/customerMenuTree",
                       method: .get) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if success.code == 200 {
                        self.homeHeadView.oneItems = success.data?.items?.first?.children?.last?.children ?? []
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取风险详情数据
    private func getPeopleRiskInfo() {
        let man = RequestManager()
        let dict = ["entityId": personId,
                    "entityCategory": "2"]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/risk/riskTracking",
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if let model = success.data, let code = success.code, code == 200 {
                    self?.refreshRiskUI(from: model)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //刷新风险数据
    private func refreshRiskUI(from model: DataModel) {
        homeHeadView.oneRiskView.namelabel.text = "经营风险"
        if let model = model.operationRisk, let riskCnt = model.riskCnt, !riskCnt.isEmpty  {
            let count = model.riskCnt ?? ""
            let descStr = model.riskInfo ?? ""
            homeHeadView.oneRiskView.numLabel.text = count
            homeHeadView.oneRiskView.descLabel.text = "\(descStr)(\(count))"
            homeHeadView.oneRiskView.timeLabel.text = model.riskTime ?? ""
        }else {
            homeHeadView.oneRiskView.numLabel.text = "0"
            homeHeadView.oneRiskView.descLabel.text = "暂无数据"
            homeHeadView.oneRiskView.timeLabel.text = ""
        }
        
        
        homeHeadView.twoRiskView.namelabel.text = "法律风险"
        if let model = model.lawRisk, let riskCnt = model.riskCnt, !riskCnt.isEmpty  {
            let count = model.riskCnt ?? ""
            let descStr = model.riskInfo ?? ""
            homeHeadView.twoRiskView.numLabel.text = count
            homeHeadView.twoRiskView.descLabel.text = "\(descStr)(\(count))"
            homeHeadView.twoRiskView.timeLabel.text = model.riskTime ?? ""
        }else {
            homeHeadView.twoRiskView.numLabel.text = "0"
            homeHeadView.twoRiskView.descLabel.text = "暂无数据"
            homeHeadView.twoRiskView.timeLabel.text = ""
        }
        
        homeHeadView.threeRiskView.namelabel.text = "财务风险"
        if let model = model.financeRisk, let riskCnt = model.riskCnt, !riskCnt.isEmpty  {
            let count = model.riskCnt ?? ""
            let descStr = model.riskInfo ?? ""
            homeHeadView.threeRiskView.numLabel.text = count
            homeHeadView.threeRiskView.descLabel.text = "\(descStr)(\(count))"
            homeHeadView.threeRiskView.timeLabel.text = model.riskTime ?? ""
        }else {
            homeHeadView.threeRiskView.numLabel.text = "0"
            homeHeadView.threeRiskView.descLabel.text = "暂无数据"
            homeHeadView.threeRiskView.timeLabel.text = ""
        }
        
        homeHeadView.fourRiskView.namelabel.text = "舆情风险"
        if let model = model.opinionRisk, let riskCnt = model.riskCnt, !riskCnt.isEmpty  {
            let count = model.riskCnt ?? ""
            let descStr = model.riskInfo ?? ""
            homeHeadView.fourRiskView.numLabel.text = count
            homeHeadView.fourRiskView.descLabel.text = "\(descStr)(\(count))"
            homeHeadView.fourRiskView.timeLabel.text = model.riskTime ?? ""
        }else {
            homeHeadView.fourRiskView.numLabel.text = "0"
            homeHeadView.fourRiskView.descLabel.text = "暂无数据"
            homeHeadView.fourRiskView.timeLabel.text = ""
        }
        
        //动态
        let timeStr = model.riskDynamic?.riskTime?.isEmpty ?? true ? "暂无数据" : model.riskDynamic!.riskTime!
        homeHeadView.timelabel.text = timeStr
        homeHeadView.desclabel.text = model.riskDynamic?.riskInfo ?? ""
    }
    
    //获取个人头部信息
    private func getPeopleHeadInfo() {
        let dict = [String: Any]()
        let man = RequestManager()
        let pageUrl = "/firminfo/v2/person/search/\(personId)"
        man.requestAPI(params: dict,
                       pageUrl: pageUrl,
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if let model = success.data {
                    self?.refreshHeadUI(from: model)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //刷新个人详情头部UI
    private func refreshHeadUI(from model: DataModel) {
        //头像
        self.homeHeadView.iconImageView.image = UIImage.imageOfText(model.personName ?? "", size: (40, 40))
        //名字
        self.homeHeadView.namelabel.text = model.personName ?? ""
        //tags
        self.homeHeadView.tagArray.accept(model.tags ?? [])
        //desc
        let descInfo = model.resume ?? ""
        homeHeadView.desLabel.text = "简介: \(descInfo)"
        let attributedString = NSMutableAttributedString(string: "简介: \(descInfo)")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        infoView.desLabel.attributedText = attributedString
        self.homeHeadView.moreBtnBlock = { [weak self] in
            guard let self = self else { return }
            keyWindow?.addSubview(infoView)
            infoView.snp.makeConstraints { make in
                make.left.bottom.equalToSuperview()
                make.width.equalTo(SCREEN_WIDTH)
                make.top.equalTo(self.homeHeadView.desLabel.snp.top)
            }
            UIView.animate(withDuration: 0.25) {
                self.infoView.alpha = 1
                self.homeHeadView.desLabel.alpha = 0
                self.homeHeadView.moreButton.alpha = 0
            }
        }
        infoView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.25) {
                    self.infoView.alpha = 0
                    self.homeHeadView.desLabel.alpha = 1
                    self.homeHeadView.moreButton.alpha = 1
                }
            }).disposed(by: disposeBag)
        
        //合作伙伴
        self.homeHeadView.onenumlabel.text = String(model.shareholderList?.count ?? 0)
        self.homeHeadView.model.accept(model)
        self.homeHeadView.pcollectionView.reloadData()
        
    }
    
}

extension PeopleDetailViewController: JXPagingViewDelegate {
    
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
            let oneVc = PeopleDetailOneViewController()
            oneVc.personId = personId
            return oneVc
        }else if index == 1 {
            let twoVc = PeopleDetailTwoViewController()
            twoVc.personId = personId
            return twoVc
        }else {
            let threeVc = PeopleDetailThreeViewController()
            threeVc.personId = personId
            return threeVc
        }
    }
    
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        print("contentOffsetY======\(contentOffsetY)")
        self.intBlock?(contentOffsetY)
    }
}
