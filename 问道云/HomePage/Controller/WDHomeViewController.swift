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
                }
                break
            case .failure(_):
                break
            }
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
        print("contentOffsetY======\(contentOffsetY)")
        if contentOffsetY > 140 {
            UIView.animate(withDuration: 0.3) {
                
            }
        }else {
            UIView.animate(withDuration: 0.3) {
                
            }
        }
    }
}
