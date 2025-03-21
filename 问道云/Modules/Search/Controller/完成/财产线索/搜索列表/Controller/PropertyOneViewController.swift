//
//  PropertyOneViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/10.
//

import UIKit
import RxRelay
import RxSwift
import JXPagingView
import JXSegmentedView

class PropertyOneViewController: WDBaseViewController {
    
    var backBlock: (() -> Void)?
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    
    var segmentedView: JXSegmentedView!
    
    let titles = ["企业", "自然人"]
    
    var JXTableHeaderViewHeight: Int = Int(StatusHeightManager.navigationBarHeight + 50)
    
    var JXheightForHeaderInSection: Int = 40
    
    lazy var pagingView: JXPagingView = preferredPagingView()
    
    var model = BehaviorRelay<rowsModel?>(value: nil)
    
    let segmentedDataSource = JXSegmentedTitleDataSource()
    
    lazy var headView: PropertyHeadView = {
        let headView = PropertyHeadView()
        return headView
    }()
    
    lazy var oneView: PropertyLineHotView = {
        let oneView = PropertyLineHotView()
        oneView.backgroundColor = .white
        return oneView
    }()
    
    lazy var companyVc: PropertyCompanyViewController = {
        let companyVc = PropertyCompanyViewController()
        return companyVc
    }()
    
    lazy var peopleVc: PropertyPeopleViewController = {
        let peopleVc = PropertyPeopleViewController()
        return peopleVc
    }()
    
    var selectIndex: Int = 0
    
    var isShowKeyboard: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //添加
        addSegmentedView()
        
        //获取城市数据
        getAllRegionInfo()
        
        //获取行业数据
        getAllIndustryInfo()
        
        //获取热搜数据
        getHotsInfo()
        
        // 监听 UITextField 的文本变化
        self.headView.searchHeadView.searchTx
            .rx.text.orEmpty
            .debounce(.milliseconds(600), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if self.containsOnlyChinese(text) == true {
                    print("自动打印中文：\(text)")
                    if !text.isEmpty {
                        self.oneView.isHidden = true
                        if selectIndex == 0 {
                            companyVc.searchWordsRelay.accept(text)
                        }else {
                            peopleVc.searchWordsRelay.accept(text)
                        }
                    }else {
                        self.oneView.isHidden = false
                    }
                }
                else if self.containsPinyin(text) == true {
                    // 拼音不打印，什么都不做
                }
            })
            .disposed(by: disposeBag)
        
        self.headView.searchHeadView.searchTx
            .rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(self.headView.searchHeadView.searchTx.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if selectIndex == 0 {
                    companyVc.searchWordsRelay.accept(text)
                }else {
                    companyVc.searchWordsRelay.accept(text)
                }
            })
            .disposed(by: disposeBag)
        
        view.addSubview(oneView)
        oneView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.headView.snp.bottom)
        }
        
    }
    
}

extension PropertyOneViewController: JXPagingViewDelegate, JXSegmentedViewDelegate {
    
    private func addSegmentedView() {
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.titleSelectedColor = UIColor.init(cssStr: "#333333")!
        segmentedViewDataSource.titleNormalColor = UIColor.init(cssStr: "#9FA4AD")!
        segmentedViewDataSource.titleNormalFont = .regularFontOfSize(size: 15)
        segmentedViewDataSource.titleSelectedFont = .mediumFontOfSize(size: 15)
        
        //指示器和指示器颜色
        segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 100, width: SCREEN_WIDTH, height: CGFloat(JXheightForHeaderInSection)))
        segmentedView.backgroundColor = UIColor.white
        segmentedView.delegate = self
        segmentedView.dataSource = segmentedViewDataSource
        segmentedView.defaultSelectedIndex = selectIndex
        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = UIColor.init(cssStr: "#547AFF")!
        lineView.indicatorWidth = 18
        lineView.indicatorHeight = 3
        segmentedView.indicators = [lineView]
        
        view.addSubview(pagingView)
        pagingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        segmentedView.listContainer = pagingView.listContainerView
        //距离高度禁止
        pagingView.pinSectionHeaderVerticalOffset = JXTableHeaderViewHeight
    }
    
    //一定要加上这句代码,否则不会下拉刷新
    func preferredPagingView() -> JXPagingView {
        return JXPagingListRefreshView(delegate: self)
    }
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return JXTableHeaderViewHeight
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return headView
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
            companyVc.blockModel = { [weak self] model in
                guard let self = self else { return }
                let peopleCount = model.personPage?.total ?? 0
                let companyCount = model.companyPage?.total ?? 0
                let titles = ["企业\(companyCount)", "自然人\(peopleCount)"]
                self.segmentedViewDataSource.titles = titles
                self.segmentedView.reloadData()
            }
            return companyVc
        }else{
            return peopleVc
        }
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        selectIndex = index
        if index == 0 {
            self.companyVc.searchWordsRelay.accept(self.headView.searchHeadView.searchTx
                .text ?? "")
        }else {
            self.peopleVc.searchWordsRelay.accept(self.headView.searchHeadView.searchTx
                .text ?? "")
        }
    }
    
}

extension PropertyOneViewController {
    
    //获取所有城市数据
    func getAllRegionInfo() {
        let modelArray = RegionDataManager.shared.getData()
        if modelArray.count > 0 {
            self.companyVc.regionModelArray.accept(modelArray)
            self.peopleVc.regionModelArray.accept(modelArray)
        }else {
            getReginInfo { modelArray in
                self.companyVc.regionModelArray.accept(modelArray)
                self.peopleVc.regionModelArray.accept(modelArray)
            }
        }
    }
    
    //获取行业数据
    func getAllIndustryInfo() {
        let modelArray = IndustruDataManager.shared.getData()
        if modelArray.count > 0 {
            self.companyVc.industryModelArray.accept(modelArray)
            self.peopleVc.industryModelArray.accept(modelArray)
        }else {
            getIndustryInfo { modelArray in
                self.companyVc.industryModelArray.accept(modelArray)
                self.peopleVc.industryModelArray.accept(modelArray)
            }
        }
    }
    
    //获取热搜数据
    func getHotsInfo() {
        let man = RequestManager()
        let dict = [String :String]()
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/property/clues/search/hot-search",
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let modelArray = success.datass {
                        self?.oneView.modelArray = modelArray
                        self?.oneView.tableView.reloadData()
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
