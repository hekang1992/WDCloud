//
//  SearchDeadbeatViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/10.
//

import UIKit
import RxRelay
import RxSwift
import JXPagingView
import JXSegmentedView

class SearchDeadbeatViewController: WDBaseViewController {
    
    private let man = RequestManager()
    
    var backBlock: (() -> Void)?
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    
    var segmentedView: JXSegmentedView!
    
    let titles = ["失信自然人", "失信企业"]
    
    var JXTableHeaderViewHeight: Int = Int(StatusHeightManager.navigationBarHeight + 50)
    
    var JXheightForHeaderInSection: Int = 40
    
    lazy var pagingView: JXPagingView = preferredPagingView()
    
    var model = BehaviorRelay<rowsModel?>(value: nil)
    
    let segmentedDataSource = JXSegmentedTitleDataSource()
    
    //浏览历史
    var historyArray: [rowsModel] = []
    //热门搜索
    var hotsArray: [rowsModel] = []
    //总数组
    var modelArray: [[rowsModel]] = []
    
    lazy var headView: PropertyHeadView = {
        let headView = PropertyHeadView()
        headView.headView.titlelabel.text = "查老赖"
        return headView
    }()
    
    lazy var oneView: CommonHotsView = {
        let oneView = CommonHotsView()
        oneView.backgroundColor = .white
        return oneView
    }()
    
    lazy var companyVc: SearchCompanyDeadbeatViewController = {
        let companyVc = SearchCompanyDeadbeatViewController()
        return companyVc
    }()
    
    lazy var peopleVc: SearchPeopleDeadbeatViewController = {
        let peopleVc = SearchPeopleDeadbeatViewController()
        return peopleVc
    }()
    
    var selectIndex: Int = 0
    
    var isShowKeyboard: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //添加
        addSegmentedView()
        
        // 监听 UITextField 的文本变化
        self.headView.searchHeadView.searchTx
            .rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if self.containsOnlyChinese(text) == true {
                    print("自动打印中文：\(text)")
                    if !text.isEmpty {
                        self.oneView.isHidden = true
                        getNumInfo(from: text)
                        if selectIndex == 0 {
                            peopleVc.searchWords.accept(text)
                        }else {
                            companyVc.searchWords.accept(text)
                        }
                    }else {
                        self.oneView.isHidden = false
                    }
                    getHotsSearchInfo()
                }
                else if self.containsPinyin(text) == true {
                    // 拼音不打印，什么都不做
                }
            })
            .disposed(by: disposeBag)
        
        self.headView.searchHeadView.searchTx
            .rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(self.headView.searchHeadView.searchTx.rx.text.orEmpty)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if selectIndex == 0 {
                    peopleVc.searchWords.accept(text)
                }else {
                    companyVc.searchWords.accept(text)
                }
                getNumInfo(from: text)
            })
            .disposed(by: disposeBag)
        
        view.addSubview(oneView)
        oneView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.headView.snp.bottom)
        }
        
        //点击最近搜索
        self.oneView.tagClickBlock = { [weak self] label in
            let keywords = label.text ?? ""
            self?.headView.searchHeadView.searchTx.text = keywords
            if !keywords.isEmpty {
                self?.oneView.isHidden = true
                if self?.selectIndex == 0 {
                    self?.peopleVc.searchWords.accept(keywords)
                }else {
                    self?.companyVc.searchWords.accept(keywords)
                }
                self?.getNumInfo(from: keywords)
            }else {
                self?.oneView.isHidden = false
            }
        }
        
        self.oneView.cellBlock = { [weak self] index, model in
            let detailListVc = ContorlDetailViewViewController()
            detailListVc.entityId = model.entityId ?? ""
            detailListVc.entityCategory = String(model.entityType ?? 1)
            self?.navigationController?.pushViewController(detailListVc, animated: true)
        }
        
        //删除最近搜索
        oneView.deleteBlock = {
            ShowAlertManager.showAlert(title: "删除", message: "是否确定删除最近搜索?", confirmAction: {
                ViewHud.addLoadView()
                let man = RequestManager()
                let dict = ["moduleId": "07"]
                man.requestAPI(params: dict,
                               pageUrl: "/operation/searchRecord/clear",
                               method: .post) { [weak self] result in
                    ViewHud.hideLoadView()
                    switch result {
                    case .success(let success):
                        if success.code == 200 {
                            ToastViewConfig.showToast(message: "删除成功")
                            self?.oneView.bgView.isHidden = true
                            self?.oneView.bgView.snp.remakeConstraints({ make in
                                make.top.equalToSuperview().offset(1)
                                make.left.equalToSuperview()
                                make.width.equalTo(SCREEN_WIDTH)
                                make.height.equalTo(0)
                            })
                        }
                        break
                    case .failure(_):
                        break
                    }
                }
            })
        }
        
        //删除浏览历史
        oneView.deleteHistoryBlock = {
            ShowAlertManager.showAlert(title: "删除", message: "是否确定删除浏览历史?", confirmAction: {
                ViewHud.addLoadView()
                let man = RequestManager()
                let dict = ["moduleId": "07"]
                man.requestAPI(params: dict,
                               pageUrl: "/operation/view-record/del",
                               method: .post) { [weak self] result in
                    ViewHud.hideLoadView()
                    switch result {
                    case .success(let success):
                        if success.code == 200 {
                            ToastViewConfig.showToast(message: "删除成功")
                            self?.historyArray.removeAll()
                            self?.oneView.modelArray = [self?.historyArray ?? [], self?.hotsArray ?? []]
                        }
                        break
                    case .failure(_):
                        break
                    }
                }
            })
        }
        
    }
    
}

extension SearchDeadbeatViewController: JXPagingViewDelegate, JXSegmentedViewDelegate {
    
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
        headView.headView.backBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
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
            return peopleVc
        }else{
            return companyVc
        }
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        selectIndex = index
        if index == 0 {
            self.peopleVc.searchWords.accept(self.headView.searchHeadView.searchTx
                .text ?? "")
        }else {
            self.companyVc.searchWords.accept(self.headView.searchHeadView.searchTx
                .text ?? "")
        }
    }
    
}

/** 网络数据请求 */
extension SearchDeadbeatViewController {
    
    private func getNumInfo(from keywords: String){
        ViewHud.addLoadView()
        let dict = ["keyword": keywords, "riskType": "DEP_COUNT"]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/v2/home-page/risk-correlation/table-count",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    guard let self = self else { return }
                    let companyCount = success.data?.orgCount ?? 0
                    let peopleCount = success.data?.personCount ?? 0
                    let titles = ["失信自然人\(peopleCount)", "失信企业\(companyCount)"]
                    self.segmentedViewDataSource.titles = titles
                    self.segmentedView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取最近搜索,浏览历史,热搜
    private func getHotsSearchInfo() {
        let group = DispatchGroup()
        group.enter()
        getLastSearchInfo(from: "07") { [weak self] modelArray in
            if !modelArray.isEmpty {
                self?.oneView.bgView.isHidden = false
                self?.oneView.bgView.snp.remakeConstraints({ make in
                    make.top.equalToSuperview().offset(1)
                    make.left.equalToSuperview()
                    make.width.equalTo(SCREEN_WIDTH)
                })
                self?.oneView.tagArray = modelArray.map { $0.searchContent ?? "" }
                self?.oneView.setupScrollView()
            }else {
                self?.oneView.bgView.isHidden = true
                self?.oneView.bgView.snp.remakeConstraints({ make in
                    make.top.equalToSuperview().offset(1)
                    make.left.equalToSuperview()
                    make.width.equalTo(SCREEN_WIDTH)
                    make.height.equalTo(0)
                })
            }
            group.leave()
        }
        
        group.enter()
        getLastHistroyInfo(from: "07") { [weak self] modelArray in
            self?.historyArray = modelArray
            group.leave()
        }
        
        group.enter()
        getLastHotsInfo(from: "07") { [weak self] modelArray in
            self?.hotsArray = modelArray
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.modelArray = [self.historyArray, self.hotsArray]
            self.oneView.modelArray = self.modelArray
        }
        
    }
    
}

