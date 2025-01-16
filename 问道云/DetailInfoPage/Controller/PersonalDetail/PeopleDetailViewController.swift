//
//  PeopleDetailViewController.swift
//  问道云
//
//  Created by 何康 on 2025/1/12.
//  企业详情

import UIKit
import JXSegmentedView
import JXPagingView

class PeopleDetailViewController: WDBaseViewController {
    
    var enityId: String = ""
    
    var intBlock: ((Double) -> Void)?
    
    lazy var companyDetailView: PeopleDetailView = {
        let companyDetailView = PeopleDetailView()
        companyDetailView.backgroundColor = .white
        return companyDetailView
    }()
    
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
        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = UIColor.init(cssStr: "#2353F0")!
        lineView.indicatorWidth = 18
        lineView.indicatorHeight = 3
        segmentedView.indicators = [lineView]
        
        view.addSubview(pagingView)
        pagingView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        
        segmentedView.listContainer = pagingView.listContainerView
        //距离高度禁止
        pagingView.pinSectionHeaderVerticalOffset = 0
        
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
    
    private func getPeopleHeadInfo() {
        let dict = [String: Any]()
        let man = RequestManager()
        let pageUrl = "/firminfo/person/search/\(enityId)"
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
                  path: "/personal-chart/equity-penetration?firmname=\(firmname)&shareholderName=\(personname)"),
            
            .init(imageResource: "gerenguanxitu",
                  path: "/personal-chart/relationship-graph?firmname=\(firmname)&shareholderName=\(personname)"),
            
            .init(imageResource: "shijiguanquna",
                  path: "/personal-chart/actual-controller?firmname=\(firmname)&legalname=\(personname)"),
            
            .init(imageResource: "shouyisuoyouqian",
                  path: "/personal-chart/beneficial-owner?firmname=\(firmname)&legalname=\(personname)"),
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
            oneVc.enityId = enityId
            return oneVc
        }else if index == 1 {
            let twoVc = PeopleDetailTwoViewController()
            twoVc.enityId = enityId
            return twoVc
        }else {
            let threeVc = PeopleDetailThreeViewController()
            threeVc.enityId = enityId
            return threeVc
        }
    }
    
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        print("contentOffsetY======\(contentOffsetY)")
        self.intBlock?(contentOffsetY)
    }
}
