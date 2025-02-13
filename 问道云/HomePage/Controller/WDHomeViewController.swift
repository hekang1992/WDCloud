//
//  WDHomeViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit
import JXPagingView
import JXSegmentedView

extension JXPagingListContainerView: @retroactive JXSegmentedViewListContainer {}

class WDHomeViewController: WDBaseViewController {
    
    //是否点击了顶部三个tab
    var isClickHeadTab: Bool = false
    
    //当前点击了第几个tab
    var selectIndex: Int = 0
    
    //头部view
    lazy var homeHeadView: HomeHeadView = preferredTableHeaderView()
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    
    var segmentedView: JXSegmentedView!
    
    let titles = ["问道头条", "问道讲堂"]
    
    var JXTableHeaderViewHeight: Int = 400
    
    var JXheightForHeaderInSection: Int = 36
    
    lazy var pagingView: JXPagingView = preferredPagingView()
    
    lazy var homeBgImageView: UIImageView = {
        let homeBgImageView = UIImageView()
        homeBgImageView.image = UIImage(named: "homelacunchimage")
        homeBgImageView.contentMode = .scaleAspectFill
        return homeBgImageView
    }()
    
    lazy var homeScroView: HomeNavSearchView = {
        let homeScroView = HomeNavSearchView()
        homeScroView.alpha = 0
        homeScroView.backgroundColor = UIColor.init(cssStr: "#2668FC")
        return homeScroView
    }()
    
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
        segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat(JXheightForHeaderInSection)))
        segmentedView.backgroundColor = UIColor.white
        segmentedView.dataSource = segmentedViewDataSource
        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = UIColor.init(cssStr: "#2353F0")!
        lineView.indicatorWidth = 18
        lineView.indicatorHeight = 3
        segmentedView.indicators = [lineView]
        
        view.addSubview(pagingView)
        pagingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        segmentedView.listContainer = pagingView.listContainerView
        //距离高度禁止
        pagingView.pinSectionHeaderVerticalOffset = Int(StatusHeightManager.navigationBarHeight + 20)
        view.addSubview(homeScroView)
        homeScroView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(Int(StatusHeightManager.navigationBarHeight + 20))
        }
        
        //跳转到会员页面
        homeHeadView.vipImageView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                if IS_LOGIN {
                    let memVc = MembershipCenterViewController()
                    self?.navigationController?.pushViewController(memVc, animated: true)
                }else {
                    self?.popLogin()
                }
            }).disposed(by: disposeBag)
        
        //获取banner数据
        getBannerInfo()
        //banner点击
        homeHeadView.bannerBlock = { [weak self] in
            if IS_LOGIN {
                let memVc = MembershipCenterViewController()
                self?.navigationController?.pushViewController(memVc, animated: true)
            }else {
                self?.popLogin()
            }
        }
        //点击item
        homeHeadView.itemBlock = { [weak self] model in
            if IS_LOGIN {
                self?.toSearchListPageWithModel(from: model)
            }else {
                self?.popLogin()
            }
        }
        //获取热搜
        getHotWords()
        self.homeHeadView.hotsView.refreshImageView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.getHotWords()
            }).disposed(by: disposeBag)
        
        //热搜3点击
        self.homeHeadView.hotsView.hotWordsBlock = { [weak self] model in
            let searchVc = SearchAllViewController()
            if IS_LOGIN {
                let type = model.type ?? ""
                if type == "1" {
                    searchVc.selectIndex = 0
                    searchVc.searchHeadView.searchTx.text = model.name ?? ""
                    self?.navigationController?.pushViewController(searchVc, animated: true)
                }else {
                    searchVc.selectIndex = 1
                    searchVc.searchHeadView.searchTx.text = model.name ?? ""
                    self?.navigationController?.pushViewController(searchVc, animated: true)
                }
            }else {
                self?.popLogin()
            }
        }
        
        //获取企业热搜
        getHotCompanyWords()
        
        //点击查企业更新文字轮博
        homeHeadView.tabView.oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.selectIndex = 0
            self?.isClickHeadTab = true
            self?.getHotCompanyWords()
        }).disposed(by: disposeBag)
        
        //点击查风险更新文字轮博
        homeHeadView.tabView.twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.selectIndex = 2
            self?.isClickHeadTab = true
            self?.getHotWords()
        }).disposed(by: disposeBag)
        
        //点击查财产更新文字轮博
        homeHeadView.tabView.threeBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.isClickHeadTab = true
            self?.getHotWords()
        }).disposed(by: disposeBag)
        
        //文字轮博点击
        homeHeadView.tabView.textBlock = { [weak self] model in
            if IS_LOGIN {
                DispatchQueue.main.async {
                    let searchAllVc = SearchAllViewController()
                    searchAllVc.selectIndex = self?.selectIndex ?? 0
                    searchAllVc.model.accept(model)
                    self?.navigationController?.pushViewController(searchAllVc, animated: true)
                }
            }else {
                self?.popLogin()
            }
        }
        
        homeScroView.textBlock = { [weak self] model in
            if IS_LOGIN {
                DispatchQueue.main.async {
                    let searchAllVc = SearchAllViewController()
                    searchAllVc.selectIndex = self?.selectIndex ?? 0
                    searchAllVc.model.accept(model)
                    self?.navigationController?.pushViewController(searchAllVc, animated: true)
                }
            }else {
                self?.popLogin()
            }
        }
        
        //添加启动页
        keyWindow?.addSubview(homeBgImageView)
        homeBgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //一定要加上这句代码,否则不会下拉刷新
    func preferredPagingView() -> JXPagingView {
        return JXPagingListRefreshView(delegate: self)
    }
    
    func preferredTableHeaderView() -> HomeHeadView {
        JXTableHeaderViewHeight = 318 + 28
        let header = HomeHeadView()
        //获取首页item
        getHomeItemInfo { [weak self] model in
            let items = model.children ?? []
            var multiplier = items.count / 5
            if multiplier >= 3 {
                multiplier = 3
            }
            self?.homeHeadView.itemModelArray.accept(items)
            self?.changeTableHeaderViewHeight(from: multiplier)
        }
        return header
    }
    
    @objc func changeTableHeaderViewHeight(from multiplier: Int) {
        JXTableHeaderViewHeight = 62 * multiplier + 318 + 28
        pagingView.resizeTableHeaderViewHeight(animatable: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 0.5, animations: {
                self.homeBgImageView.alpha = 0
            }) { _ in
                self.homeBgImageView.removeFromSuperview()
            }
        }
    }
}

extension WDHomeViewController {
    
    //获取首页item
    private func getHomeItemInfo(complete: @escaping ((childrenModel) -> Void)) {
        let man = RequestManager()
        ViewHud.addLoadView()
        let appleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let dict = ["moduleType": "1",
                    "appleVersion": appleVersion]
        man.requestAPI(params: dict,
                       pageUrl: customer_menuTree,
                       method: .get) { result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if let model = success.data?.items?.first?.children?.last {
                    complete(model)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取banner
    func getBannerInfo() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["binnertype": "1"]
        man.requestAPI(params: dict,
                       pageUrl: bannerHome_url,
                       method: .get) { [weak self] reslut in
            ViewHud.hideLoadView()
            switch reslut {
            case .success(let success):
                if success.code == 200 {
                    self?.homeHeadView.bannerModelArray = success.data?.rows ?? []
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //热搜 全部 企业加人员
    func getHotWords() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["moduleId": ""]
        man.requestAPI(params: dict,
                       pageUrl: browser_hotwords,
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    self.homeHeadView.hotsView.modelArray.accept(model.data ?? [])
                    if self.isClickHeadTab {
                        self.homeHeadView.tabView.modelArray.accept(model.data ?? [])
                        self.homeScroView.modelArray.accept(model.data ?? [])
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //热搜1 企业热搜
    func getHotCompanyWords() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["moduleId": "01"]
        man.requestAPI(params: dict,
                       pageUrl: browser_hotwords,
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    self.homeHeadView.tabView.modelArray.accept(model.data ?? [])
                    self.homeScroView.modelArray.accept(model.data ?? [])
                }
                break
            case .failure(_):
                break
            }
        }
    }
}

extension WDHomeViewController {
    
    private func toSearchListPageWithModel(from model: childrenModel) {
        let menuID = model.menuId ?? ""
        if menuID == "10200" {
            let searchVc = SearchAllViewController()
            searchVc.selectIndex = 1
            searchVc.searchHeadView.searchTx.placeholder = "请输入老板,股东,高管姓名"
            self.navigationController?.pushViewController(searchVc, animated: true)
        }else if menuID == "10500" {//查股东
            let shareVc = SearchShareholderViewController()
            self.navigationController?.pushViewController(shareVc, animated: true)
        }else if menuID == "10600" {//查老赖
            let beatVc = SearchDeadbeatViewController()
            self.navigationController?.pushViewController(beatVc, animated: true)
        }else if menuID == "10800" {
            ToastViewConfig.showToast(message: "敬请期待")
        }else if menuID == "10900" {//司法sus
            let lawSuitVc = SearchLawSuitViewController()
            self.navigationController?.pushViewController(lawSuitVc, animated: true)
        }else if menuID == "11000" {//行政处罚
            let sanctionVc = HomeSanctionViewController()
            self.navigationController?.pushViewController(sanctionVc, animated: true)
        }else if menuID == "11100" {//债券违约
            let bondVc = SearchDondDefaultViewController()
            self.navigationController?.pushViewController(bondVc, animated: true)
        }else if menuID == "11200" {//公告大全
            let noticeVc = NoticeAllViewController()
            self.navigationController?.pushViewController(noticeVc, animated: true)
        }else if menuID == "11300" {//法律法规
            let lawVc = HomeLawsViewController()
            self.navigationController?.pushViewController(lawVc, animated: true)
        }else if menuID == "11400" {//风险监控
            NotificationCenter.default.post(name: NSNotification.Name(RISK_VC), object: nil)
        }else if menuID == "11500" {//尽职调查
            NotificationCenter.default.post(name: NSNotification.Name(DILI_VC), object: nil)
        }else if menuID == "11600" {//一键报告
            let oneRpVc = HomeOneReportViewController()
            self.navigationController?.pushViewController(oneRpVc, animated: true)
        }else if menuID == "11900" {//实际控制人
            let controllVc = SearchControllingPersonViewController()
            self.navigationController?.pushViewController(controllVc, animated: true)
        }else if menuID == "12000" {//最终受益人
            let beneficialVc = SearchBeneficialOwnerViewController()
            self.navigationController?.pushViewController(beneficialVc, animated: true)
        }else if menuID == "12100" {//被执行人
            
        }else if menuID == "12200" {//限制高消费
            let highVc = SearchHighConsumptionViewController()
            self.navigationController?.pushViewController(highVc, animated: true)
        }else if menuID == "12300" {//法院公告
            let courtVc = SearchCourtNoticeViewController()
            self.navigationController?.pushViewController(courtVc, animated: true)
        }else if menuID == "12400" {//开庭公告
            let startVc = SearchStartCourtNoticeViewController()
            self.navigationController?.pushViewController(startVc, animated: true)
        }else if menuID == "12500" {//司法拍卖
            let buyVc = SearchJudicialAuctioniewViewController()
            self.navigationController?.pushViewController(buyVc, animated: true)
        }else if menuID == "12600" {//税收违法
            let taxVc = SearchTaxViolationViewController()
            self.navigationController?.pushViewController(taxVc, animated: true)
        }else if menuID == "12700" {//环保处罚
            let environmentalVc = SearchEnvironmentalPenaltyViewController()
            self.navigationController?.pushViewController(environmentalVc, animated: true)
        }else if menuID == "12800" {//贷款逾期
            let loanDefaultVc = SearchLoanDefaultViewController()
            self.navigationController?.pushViewController(loanDefaultVc, animated: true)
        }else if menuID == "12900" {//资产冻结
            let freezeVc = SearchAssetFreezeViewController()
            self.navigationController?.pushViewController(freezeVc, animated: true)
        }else if menuID == "13000" {//资产查封
            let seizureVc = SearchAssetSeizureViewController()
            self.navigationController?.pushViewController(seizureVc, animated: true)
        }else if menuID == "13100" {//资产抵押
            let backLendingVc = SearchBackedLendingViewController()
            self.navigationController?.pushViewController(backLendingVc, animated: true)
        }else if menuID == "13200" {//对外担保
            let guaranteeVc = SearchExternalGuaranteeViewController()
            self.navigationController?.pushViewController(guaranteeVc, animated: true)
        }else if menuID == "13300" {//对外投资
            let investmentVc = SearchOverseasInvestmentViewController()
            self.navigationController?.pushViewController(investmentVc, animated: true)
        }
    }
    
}


extension WDHomeViewController: JXPagingViewDelegate {
    
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
            let newsListVc = HomeNewsListViewController()
            return newsListVc
        }else {
            let videoListVc = HomeVideoListViewController()
            return videoListVc
        }
    }
    
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY > 200 {
            UIView.animate(withDuration: 0.25) {
                self.homeScroView.alpha = 1
            }
        }else {
            UIView.animate(withDuration: 0.25) {
                self.homeScroView.alpha = 0
            }
        }
    }
}
