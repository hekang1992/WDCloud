//
//  SearchBeneficialOwnerViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/10.
//

import UIKit
import RxRelay
import RxSwift
import JXPagingView
import JXSegmentedView

class SearchBeneficialOwnerViewController: WDBaseViewController {
    
    var backBlock: (() -> Void)?
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    
    var segmentedView: JXSegmentedView!
    
    let titles = ["自然人", "企业"]
    
    var JXTableHeaderViewHeight: Int = Int(StatusHeightManager.navigationBarHeight + 50)
    
    var JXheightForHeaderInSection: Int = 40
    
    lazy var pagingView: JXPagingView = preferredPagingView()
    
    var model = BehaviorRelay<rowsModel?>(value: nil)
    
    let segmentedDataSource = JXSegmentedTitleDataSource()
    
    //热搜
    var hotWordsArray = BehaviorRelay<[rowsModel]?>(value: nil)
    
    lazy var headView: PropertyHeadView = {
        let headView = PropertyHeadView()
        headView.headView.titlelabel.text = "最终受益人"
        return headView
    }()
    
    lazy var oneView: OneCompanyView = {
        let oneView = OneCompanyView()
        oneView.backgroundColor = .white
        return oneView
    }()
    
    lazy var peopleVc: SearchPeopleBeneficialOwnerViewController = {
        let peopleVc = SearchPeopleBeneficialOwnerViewController()
        return peopleVc
    }()
    
    lazy var companyVc: SearchCompanyBeneficialOwnerViewController = {
        let companyVc = SearchCompanyBeneficialOwnerViewController()
        return companyVc
    }()
    
    var selectIndex: Int = 0
    
    var isShowKeyboard: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //添加
        addSegmentedView()
    
        //最近搜索
        self.getlastSearch()
        
        //浏览历史
        self.getBrowsingHistory()
        
        //热搜
        self.getHotWords()
        
        // 监听 UITextField 的文本变化
        self.headView.searchHeadView.searchTx
            .rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(600), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if self.containsOnlyChinese(text) == true {
                    print("自动打印中文：\(text)")
                    if !text.isEmpty {
                        self.oneView.isHidden = true
                        if selectIndex == 0 {
                            peopleVc.searchWordsRelay.accept(text)
                        }else {
                            companyVc.searchWordsRelay.accept(text)
                        }
                        //最近搜索
                        self.getlastSearch()
                        //浏览历史
                        self.getBrowsingHistory()
                        //热搜
                        self.getHotWords()
                        getNumInfo(from: text)
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
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if selectIndex == 0 {
                    peopleVc.searchWordsRelay.accept(text)
                }else {
                    companyVc.searchWordsRelay.accept(text)
                }
                getNumInfo(from: text)
            })
            .disposed(by: disposeBag)
        
        view.addSubview(oneView)
        oneView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.headView.snp.bottom)
        }
        
        //删除最近搜索
        self.oneView.searchView.deleteBtn
            .rx
            .tap.subscribe(onNext: { [weak self] in
                self?.deleteSearchInfo()
            }).disposed(by: disposeBag)
        
        //删除浏览历史
        self.oneView.historyView.deleteBtn
            .rx
            .tap.subscribe(onNext: { [weak self] in
                self?.deleteHistoryInfo()
            }).disposed(by: disposeBag)
        
        //点击最近搜索
        self.oneView.lastSearchTextBlock = { [weak self] keywords in
            self?.headView.searchHeadView.searchTx.text = keywords
            if !keywords.isEmpty {
                self?.oneView.isHidden = true
                if self?.selectIndex == 0 {
                    self?.peopleVc.searchWordsRelay.accept(keywords)
                }else {
                    self?.companyVc.searchWordsRelay.accept(keywords)
                }
                self?.getNumInfo(from: keywords)
            }else {
                self?.oneView.isHidden = false
            }
        }
        
    }
    
}

extension SearchBeneficialOwnerViewController: JXPagingViewDelegate, JXSegmentedViewDelegate {
    
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
            return peopleVc
        }else{
            return companyVc
        }
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        selectIndex = index
        if index == 0 {
            self.peopleVc.searchWordsRelay.accept(self.headView.searchHeadView.searchTx
                .text ?? "")
        }else {
            self.companyVc.searchWordsRelay.accept(self.headView.searchHeadView.searchTx
                .text ?? "")
        }
    }
    
}

/** 网络数据请求 */
extension SearchBeneficialOwnerViewController {
    
    //最近搜索
    private func getlastSearch() {
        let man = RequestManager()
        let dict = ["searchType": "",
                    "moduleId": "41"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/searchRecord/query",
                       method: .post) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let rows = success.data?.data {
                    reloadSearchUI(data: rows)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //最近搜索UI刷新
    func reloadSearchUI(data: [rowsModel]) {
        var strArray: [String] = []
        if data.count > 0 {
            for model in data {
                strArray.append(model.searchContent ?? "")
            }
            self.oneView.searchView.tagListView.removeAllTags()
            self.oneView.searchView.tagListView.addTags(strArray)
            self.oneView.searchView.isHidden = false
            self.oneView.layoutIfNeeded()
            let height = self.oneView.searchView.tagListView.frame.height
            self.oneView.searchView.snp.updateConstraints { make in
                make.height.equalTo(30 + height + 20)
            }
        } else {
            self.oneView.searchView.isHidden = true
            self.oneView.searchView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        self.oneView.layoutIfNeeded()
    }
    
    //浏览历史
    private func getBrowsingHistory() {
        let man = RequestManager()
        
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber,
                    "viewrecordtype": "",
                    "moduleId": "41",
                    "pageNum": "1",
                    "pageSize": "20"]
        man.requestAPI(params: dict, pageUrl: "/operation/clientbrowsecb/selectBrowserecord", method: .get) { [weak self] result in
            
            switch result {
            case .success(let success):
                guard let self = self else { return }
                if let rows = success.data?.rows {
                    readHistoryUI(data: rows)
                }
                break
            case .failure(_):
                
                break
            }
        }
    }
    
    //UI刷新
    func readHistoryUI(data: [rowsModel]) {
        for (index, model) in data.enumerated() {
            let listView = CommonSearchListView()
            let type = model.viewrecordtype ?? ""
            listView.block = { [weak self] in
                guard let self = self else { return }
//                let pageUrl = "\(base_url)/personal-information/shareholder-situation"
//                var dict: [String: String]
//                if type == "1" {
//                    dict = ["firmname": model.firmname ?? "",
//                            "entityId": model.firmnumber ?? "",
//                            "isPerson": "0"]
//                }else {
//                    dict = ["personName": model.name ?? "",
//                            "personNumber": model.eid ?? "",
//                            "isPerson": "1"]
//                }
//                let webUrl = URLQueryAppender.appendQueryParameters(to: pageUrl, parameters: dict) ?? ""
//                self.pushWebPage(from: webUrl)
            }
            var name: String = ""
            if type == "1" {
                name = model.firmname ?? ""
            }else {
                name = model.personname ?? ""
            }
            listView.nameLabel.text = name
            listView.timeLabel.text = model.createhourtime ?? ""
            listView.icon.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(name, size: (22, 22)))
            self.oneView.historyView.addSubview(listView)
            listView.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(SCREEN_WIDTH)
                make.left.equalToSuperview()
                make.top.equalTo(self.oneView.historyView.lineView.snp.bottom).offset(40 * index)
            }
        }
        
        self.oneView.historyView.snp.updateConstraints { make in
            if data.count != 0 {
                self.oneView.historyView.isHidden = false
                make.height.equalTo((data.count) * 40 + 30)
            } else {
                self.oneView.historyView.isHidden = true
                make.height.equalTo(0)
            }
        }
        self.oneView.layoutIfNeeded()
    }
    
    //热搜
    private func getHotWords() {
        let man = RequestManager()
        
        let dict = ["moduleId": "41"]
        man.requestAPI(params: dict,
                       pageUrl: browser_hotwords,
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    self.hotWordsArray.accept(model.data ?? [])
                    hotsWordsUI(data: model.data ?? [])
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //UI刷新
    func hotsWordsUI(data: [rowsModel]) {
        for (index, model) in data.enumerated() {
            let listView = CommonSearchListView()
            listView.block = { [weak self] in
                guard let self = self else { return }
                let pageUrl = "\(base_url)/personal-information/shareholder-situation"
                var dict: [String: String]
                let type = model.type ?? ""
                if type == "1" {
                    dict = ["firmname": model.name ?? "",
                            "entityId": model.eid ?? "",
                            "isPerson": "0"]
                }else {
                    dict = ["personName": model.name ?? "",
                            "personNumber": model.eid ?? "",
                            "isPerson": "1"]
                }
                let webUrl = URLQueryAppender.appendQueryParameters(to: pageUrl, parameters: dict) ?? ""
                self.pushWebPage(from: webUrl)
            }
            listView.nameLabel.text = model.name ?? ""
            listView.icon.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.name ?? "", size: (22, 22)))
            self.oneView.hotWordsView.addSubview(listView)
            listView.snp.updateConstraints { make in
                make.height.equalTo(40)
                make.left.right.equalToSuperview()
                make.top.equalTo(self.oneView.hotWordsView.lineView.snp.bottom).offset(40 * index)
            }
        }
        
        self.oneView.hotWordsView.snp.updateConstraints { make in
            if data.count != 0 {
                self.oneView.hotWordsView.isHidden = false
                make.height.equalTo((data.count) * 40 + 30)
            } else {
                self.oneView.hotWordsView.isHidden = true
                make.height.equalTo(0)
            }
        }
        self.oneView.layoutIfNeeded()
    }
    
    //删除最近搜索
    private func deleteSearchInfo() {
        ShowAlertManager.showAlert(title: "删除", message: "是否需要删除最近搜索?", confirmAction: {
            let man = RequestManager()
            
            let dict = ["searchType": "",
                        "moduleId": "41"]
            man.requestAPI(params: dict,
                           pageUrl: "/operation/searchRecord/clear",
                           method: .post) { result in
                
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        ToastViewConfig.showToast(message: "删除成功")
                        self.oneView.searchView.isHidden = true
                        self.oneView.searchView.snp.updateConstraints({ make in
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
    private func deleteHistoryInfo() {
        ShowAlertManager.showAlert(title: "删除", message: "是否需要删除浏览历史?", confirmAction: {
            let man = RequestManager()
            
            let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
            let dict = ["customernumber": customernumber,
                        "moduleId": "41",
                        "viewrecordtype": ""]
            man.requestAPI(params: dict,
                           pageUrl: "/operation/clientbrowsecb/deleteBrowseRecord",
                           method: .get) { result in
                
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        ToastViewConfig.showToast(message: "删除成功")
                        self.oneView.historyView.isHidden = true
                        self.oneView.historyView.snp.updateConstraints({ make in
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
    
    private func getNumInfo(from keywords: String){
        let dict = ["keywords": keywords]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/v2/home-page/ubo/table-count",
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    guard let self = self else { return }
                    let peopleCount = success.data?.personCount ?? 0
                    let companyCount = success.data?.orgCount ?? 0
                    let titles = ["自然人\(peopleCount)", "企业\(companyCount)"]
                    self.segmentedViewDataSource.titles = titles
                    self.segmentedView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
