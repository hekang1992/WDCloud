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

extension PeopleDetailViewController {
    
    //获取风险详情数据
    private func getPeopleRiskInfo() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["personId": personId]
        man.requestAPI(params: dict,
                       pageUrl: "/riskmonitor/riskmonitoring/riskTrackingNew",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
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
        homeHeadView.oneRiskView.namelabel.text = model.map1?.name ?? ""
        homeHeadView.oneRiskView.numLabel.text = model.map1?.sumTotal ?? "0"
        let oneStr = model.map1?.itemname?.isEmpty ?? true ? "暂无数据" : model.map1!.itemname!
        homeHeadView.oneRiskView.descLabel.text = oneStr
        homeHeadView.oneRiskView.timeLabel.text = model.map1?.risktime ?? ""
        
        
        homeHeadView.twoRiskView.namelabel.text = model.map2?.name ?? ""
        homeHeadView.twoRiskView.numLabel.text = model.map2?.sumTotal ?? "0"
        let twoStr = model.map2?.itemname?.isEmpty ?? true ? "暂无数据" : model.map2!.itemname!
        homeHeadView.twoRiskView.descLabel.text = twoStr
        homeHeadView.twoRiskView.timeLabel.text = model.map2?.risktime ?? ""
        
        homeHeadView.threeRiskView.namelabel.text = model.map3?.name ?? ""
        homeHeadView.threeRiskView.numLabel.text = model.map3?.sumTotal ?? "0"
        let threeStr = model.map3?.itemname?.isEmpty ?? true ? "暂无数据" : model.map3!.itemname!
        homeHeadView.threeRiskView.descLabel.text = threeStr
        homeHeadView.threeRiskView.timeLabel.text = model.map3?.risktime ?? ""
        
        homeHeadView.fourRiskView.namelabel.text = model.map4?.name ?? ""
        homeHeadView.fourRiskView.numLabel.text = model.map4?.sumTotal ?? "0"
        let fourStr = model.map4?.itemname?.isEmpty ?? true ? "暂无数据" : model.map4!.itemname!
        homeHeadView.fourRiskView.descLabel.text = fourStr
        homeHeadView.fourRiskView.timeLabel.text = model.map4?.risktime ?? ""

        //动态
        let timeStr = model.entityRiskEventInfo?.riskTime?.isEmpty ?? true ? "暂无数据" : model.entityRiskEventInfo!.riskTime!
        homeHeadView.timelabel.text = timeStr
        homeHeadView.desclabel.text = model.entityRiskEventInfo?.dynamiccontent ?? ""
    }
    
    private func getPeopleHeadInfo() {
        let dict = [String: Any]()
        let man = RequestManager()
        ViewHud.addLoadView()
        let pageUrl = "/firminfo/person/search/\(personId)"
        man.requestAPI(params: dict,
                       pageUrl: pageUrl,
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
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
        let descInfo = model.basicInfo?.resume ?? ""
        self.homeHeadView.desLabel.text = "简介: \(descInfo)"
        
        infoView.desLabel.text = "简介: \(descInfo)"
        self.homeHeadView.moreBtnBlock = { [weak self] in
            guard let self = self else { return }
            keyWindow?.addSubview(infoView)
            infoView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
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
        
        //常用服务
        let firmname = model.firmname ?? ""
        let personname = model.personName ?? ""
        self.homeHeadView.oneItems = [
            .init(imageResource: "peopleicon",
                  path: "\(base_url)/personal-chart/equity-penetration?firmname=\(firmname)&shareholderName=\(personname)"),
            
            .init(imageResource: "gerenguanxitu",
                  path: "\(base_url)/personal-chart/relationship-graph?firmname=\(firmname)&shareholderName=\(personname)"),
            
            .init(imageResource: "shijiguanquna",
                  path: "\(base_url)/personal-chart/actual-controller?firmname=\(firmname)&legalname=\(personname)"),
            
            .init(imageResource: "shouyisuoyouqian",
                  path: "\(base_url)/personal-chart/beneficial-owner?firmname=\(firmname)&legalname=\(personname)"),
        ]
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
