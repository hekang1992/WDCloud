//
//  SearchAllViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/7.
//  所有搜索页面

import UIKit
import RxRelay
import RxSwift
import JXPagingView
import JXSegmentedView

class SearchAllViewController: WDBaseViewController {
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    
    var segmentedView: JXSegmentedView!
    
    let titles = ["企业", "人员", "风险"]
    
    var JXTableHeaderViewHeight: Int = 104
    
    var JXheightForHeaderInSection: Int = 40
    
    lazy var pagingView: JXPagingView = preferredPagingView()
    
    var model = BehaviorRelay<rowsModel?>(value: nil)
    
    let segmentedDataSource = JXSegmentedTitleDataSource()
    
    lazy var searchHeadView: SearchHeadView = {
        let searchHeadView = SearchHeadView()
        searchHeadView.searchTx.placeholder = model.value?.entityName ?? ""
        return searchHeadView
    }()
    
    lazy var enterpriseVc: SearchEnterpriseViewController = {
        let enterpriseVc = SearchEnterpriseViewController()
        return enterpriseVc
    }()

    lazy var peopleVc: SearchPeopleViewController = {
        let peopleVc = SearchPeopleViewController()
        return peopleVc
    }()
    
    lazy var riskVc: SearchRiskViewController = {
        let riskVc = SearchRiskViewController()
        return riskVc
    }()
    
    var selectIndex: Int = 0
    
    var isShowKeyboard: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(searchHeadView)
        searchHeadView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(104)
        }
        searchHeadView.clickBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }).disposed(by: disposeBag)
        
        //添加
        addSegmentedView()
        
        //获取城市数据
        getAllRegionInfo()
        
        //获取行业数据
        getAllIndustryInfo()
        
        // 监听 UITextField 的文本变化
        self.searchHeadView.searchTx
            .rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if self.containsOnlyChinese(text) == true {
                    print("自动打印中文：\(text)")
                    if selectIndex == 0 {
                        enterpriseVc.searchWords.accept(text)
                    }else if selectIndex == 1 {
                        peopleVc.searchWords = text
                    }else if selectIndex == 2 {
                        riskVc.searchWords = text
                    }else {
                        
                    }
                }else if self.containsPinyin(text) == true {
                    // 拼音不打印，什么都不做
                }
            })
            .disposed(by: disposeBag)
        
        self.searchHeadView.searchTx
            .rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(self.searchHeadView.searchTx.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if selectIndex == 0 {
                    if text.isEmpty {
                        self.searchHeadView.searchTx.text = self.searchHeadView.searchTx.placeholder
                        enterpriseVc.searchWords.accept(self.searchHeadView.searchTx.placeholder)
                    }else {self.searchHeadView.searchTx.text = text
                        enterpriseVc.searchWords.accept(text)
                    }
                }else if selectIndex == 1 {
                    peopleVc.searchWords = text
                }else if selectIndex == 2 {
                    riskVc.searchWords = text
                }else {
                    
                }
            }).disposed(by: disposeBag)
    }
    
}

extension SearchAllViewController: JXPagingViewDelegate, JXSegmentedViewDelegate {
    
    private func addSegmentedView() {
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedViewDataSource = JXSegmentedTitleDataSource()
        segmentedViewDataSource.titles = titles
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.titleSelectedColor = UIColor.init(cssStr: "#547AFF")!
        segmentedViewDataSource.titleNormalColor = UIColor.init(cssStr: "#666666")!
        segmentedViewDataSource.titleNormalFont = UIFont.mediumFontOfSize(size: 15)
        segmentedViewDataSource.titleSelectedFont = UIFont.mediumFontOfSize(size: 15)
        
        //指示器和指示器颜色
        segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat(JXheightForHeaderInSection)))
        segmentedView.backgroundColor = UIColor.white
        segmentedView.delegate = self
        segmentedView.dataSource = segmentedViewDataSource
        segmentedView.defaultSelectedIndex = selectIndex
        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = UIColor.init(cssStr: "#547AFF ")!
        lineView.indicatorWidth = 18
        lineView.indicatorHeight = 3
        segmentedView.indicators = [lineView]
        
        view.addSubview(pagingView)
        pagingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        segmentedView.listContainer = pagingView.listContainerView
        //距离高度禁止
        pagingView.pinSectionHeaderVerticalOffset = 104
    }
    
    //一定要加上这句代码,否则不会下拉刷新
    func preferredPagingView() -> JXPagingView {
        return JXPagingListRefreshView(delegate: self)
    }
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return JXTableHeaderViewHeight
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return searchHeadView
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
            enterpriseVc.lastSearchTextBlock = { [weak self] searchStr in
                guard let self = self else { return }
                searchHeadView.searchTx.placeholder = searchStr
                searchHeadView.searchTx.text = searchStr
                DispatchQueue.main.asyncAfter(delay: 0.25) {
                    self.searchHeadView.searchTx.becomeFirstResponder()
                }
            }
            enterpriseVc.completeBlock = { [weak self] in
                guard let self = self else { return }
                if self.isShowKeyboard {
                    self.isShowKeyboard = false
                    DispatchQueue.main.asyncAfter(delay: 0.5) {
                        self.searchHeadView.searchTx.becomeFirstResponder()
                    }
                }
            }
            enterpriseVc.moreBtnBlock = { [weak self] in
                guard let self = self else { return }
                self.peopleVc.searchWords = self.searchHeadView.searchTx
                    .text ?? ""
                segmentedView.defaultSelectedIndex = 1
                segmentedView.reloadData()
            }
            return enterpriseVc
        }else if index == 1 {
            peopleVc.lastSearchTextBlock = { [weak self] searchStr in
                guard let self = self else { return }
                searchHeadView.searchTx.text = searchStr
                peopleVc.searchWords = searchStr
            }
            peopleVc.completeBlock = { [weak self] in
                guard let self = self else { return }
                if self.isShowKeyboard {
                    self.isShowKeyboard = false
                    DispatchQueue.main.asyncAfter(delay: 0.5) {
                        self.searchHeadView.searchTx.becomeFirstResponder()
                    }
                }
            }
            return peopleVc
        }else if index == 2 {
            riskVc.lastSearchTextBlock = { [weak self] searchStr in
                guard let self = self else { return }
                searchHeadView.searchTx.text = searchStr
                riskVc.searchWords = searchStr
            }
            riskVc.completeBlock = { [weak self] in
                guard let self = self else { return }
                if self.isShowKeyboard {
                    self.isShowKeyboard = false
                    DispatchQueue.main.asyncAfter(delay: 0.5) {
                        self.searchHeadView.searchTx.becomeFirstResponder()
                    }
                }
            }
            return riskVc
        }else {
            return enterpriseVc
        }
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        selectIndex = index
        if index == 0 {
            self.enterpriseVc.searchWords.accept(self.searchHeadView.searchTx
                .text ?? "")
        }else if index == 1 {
            self.peopleVc.searchWords = self.searchHeadView.searchTx
                .text ?? ""
        }else if index == 2 {
            self.riskVc.searchWords = self.searchHeadView.searchTx
                .text ?? ""
        }else {
            
        }
    }
    
}

extension SearchAllViewController {
    
    //获取所有城市数据
    func getAllRegionInfo() {
        let modelArray = RegionDataManager.shared.getData()
        if modelArray.count > 0 {
            self.enterpriseVc.regionModelArray.accept(modelArray)
            self.peopleVc.regionModelArray.accept(modelArray)
            self.riskVc.regionModelArray.accept(modelArray)
        }else {
            getReginInfo { modelArray in
                self.enterpriseVc.regionModelArray.accept(modelArray)
                self.peopleVc.regionModelArray.accept(modelArray)
                self.riskVc.regionModelArray.accept(modelArray)
            }
        }
    }
    
    //获取行业数据
    func getAllIndustryInfo() {
        let modelArray = IndustruDataManager.shared.getData()
        if modelArray.count > 0 {
            self.enterpriseVc.industryModelArray.accept(modelArray)
            self.peopleVc.industryModelArray.accept(modelArray)
            self.riskVc.industryModelArray.accept(modelArray)
        }else {
            getIndustryInfo { modelArray in
                self.enterpriseVc.regionModelArray.accept(modelArray)
                self.peopleVc.regionModelArray.accept(modelArray)
                self.riskVc.regionModelArray.accept(modelArray)
            }
        }
    }
    
}

