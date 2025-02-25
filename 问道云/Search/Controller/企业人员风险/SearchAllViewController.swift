//
//  SearchAllViewController.swift
//  问道云
//
//  Created by 何康 on 2025/1/7.
//  所有搜索页面

import UIKit
import RxRelay
import JXPagingView
import JXSegmentedView
import RxSwift

class SearchAllViewController: WDBaseViewController {
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    
    var segmentedView: JXSegmentedView!
    
    let titles = ["企业", "人员", "风险"]
    
    var JXTableHeaderViewHeight: Int = 104
    
    var JXheightForHeaderInSection: Int = 36
    
    lazy var pagingView: JXPagingView = preferredPagingView()
    
    var model = BehaviorRelay<rowsModel?>(value: nil)
    
    let segmentedDataSource = JXSegmentedTitleDataSource()
    
    lazy var searchHeadView: SearchHeadView = {
        let searchHeadView = SearchHeadView()
        searchHeadView.searchTx.placeholder = model.value?.name ?? ""
        searchHeadView.searchTx.delegate = self
        return searchHeadView
    }()
    
    lazy var companyVc: SearchCompanyViewController = {
        let companyVc = SearchCompanyViewController()
        companyVc.completeBlock = { [weak self] in
            self?.searchHeadView.searchTx.becomeFirstResponder()
        }
        return companyVc
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
        
        self.searchHeadView.searchTx
            .rx.controlEvent(.editingChanged)
            .withLatestFrom(self.searchHeadView.searchTx.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if selectIndex == 0 {
                    companyVc.searchWords = text
                }else if selectIndex == 1 {
                    peopleVc.searchWords = text
                }else if selectIndex == 2 {
                    riskVc.searchWords = text
                }else {
                    
                }
            })
            .disposed(by: disposeBag)
        
    }
    
}

extension SearchAllViewController: JXPagingViewDelegate, JXSegmentedViewDelegate {
    
    private func addSegmentedView() {
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
        segmentedView.delegate = self
        segmentedView.dataSource = segmentedViewDataSource
        segmentedView.defaultSelectedIndex = selectIndex
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
            companyVc.lastSearchTextBlock = { [weak self] searchStr in
                guard let self = self else { return }
                searchHeadView.searchTx.text = searchStr
                companyVc.searchWords = searchStr
            }
            return companyVc
        }else if index == 1 {
            peopleVc.lastSearchTextBlock = { [weak self] searchStr in
                guard let self = self else { return }
                searchHeadView.searchTx.text = searchStr
                peopleVc.searchWords = searchStr
            }
            return peopleVc
        }else {
            riskVc.lastSearchTextBlock = { [weak self] searchStr in
                guard let self = self else { return }
                searchHeadView.searchTx.text = searchStr
                riskVc.searchWords = searchStr
            }
            return riskVc
        }
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        selectIndex = index
        if index == 0 {
            self.companyVc.searchWords = self.searchHeadView.searchTx
                .text ?? ""
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

extension SearchAllViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let searchText = textField.text ?? ""
        if searchText.isEmpty {
            textField.text = textField.placeholder
        }
        if selectIndex == 0 {
            companyVc.searchWords = textField.text
        }else if selectIndex == 1 {
            peopleVc.searchWords = textField.text
        }else if selectIndex == 2 {
            riskVc.searchWords = textField.text
        }else {
            
        }
        textField.resignFirstResponder()
        return true
    }
    
}

extension SearchAllViewController {
    
    //获取所有城市数据
    func getAllRegionInfo() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let emptyDict = [String: Any]()
        man.requestAPI(params: emptyDict,
                       pageUrl: "/operation/ajax/areaTree",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if let self = self, let modelArray = success.data?.data {
                    self.companyVc.regionModelArray.accept(modelArray)
                    self.peopleVc.regionModelArray.accept(modelArray)
                    self.riskVc.regionModelArray.accept(modelArray)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取行业数据
    func getAllIndustryInfo() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let emptyDict = [String: Any]()
        man.requestAPI(params: emptyDict,
                       pageUrl: "/operation/ajax/industryTree",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if let self = self, let modelArray = success.data?.data {
                    self.companyVc.industryModelArray.accept(modelArray)
                    self.peopleVc.industryModelArray.accept(modelArray)
                    self.riskVc.industryModelArray.accept(modelArray)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
