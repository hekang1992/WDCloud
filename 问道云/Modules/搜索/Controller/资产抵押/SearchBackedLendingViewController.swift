//
//  SearchBackedLendingViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/10.
//

import UIKit
import RxRelay
import RxSwift
import JXPagingView
import JXSegmentedView

class SearchBackedLendingViewController: WDBaseViewController {
    
    private let man = RequestManager()
    
    var backBlock: (() -> Void)?
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    
    var segmentedView: JXSegmentedView!
    
    let titles = ["企业", "人员"]
    
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
        headView.headView.titlelabel.text = "资产抵押"
        return headView
    }()
    
    lazy var oneView: CommonHotsView = {
        let oneView = CommonHotsView()
        oneView.backgroundColor = .white
        return oneView
    }()
    
    lazy var companyVc: SearchCompanyBackedLendingViewController = {
        let companyVc = SearchCompanyBackedLendingViewController()
        return companyVc
    }()
    
    lazy var peopleVc: SearchPeopleBackedLendingViewController = {
        let peopleVc = SearchPeopleBackedLendingViewController()
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextField.textDidChangeNotification,
            object: self.headView.searchHeadView.searchTx
        )
        
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
                    self?.companyVc.searchWords.accept(keywords)
                }else {
                    self?.peopleVc.searchWords.accept(keywords)
                }
                self?.getNumInfo(from: keywords)
            }else {
                self?.oneView.isHidden = false
            }
        }
        
        self.oneView.cellBlock = { [weak self] index, model in
            let pageUrl = model.h5Url ?? ""
            let webVc = WebPageViewController()
            let webUrl = base_url + pageUrl
            webVc.pageUrl.accept(webUrl)
            self?.navigationController?.pushViewController(webVc, animated: true)
        }
        
        //删除最近搜索
        oneView.deleteBlock = {
            ShowAlertManager.showAlert(title: "删除", message: "是否确定删除最近搜索?", confirmAction: {
                ViewHud.addLoadView()
                let man = RequestManager()
                let dict = ["moduleId": "24"]
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
                let dict = ["moduleId": "24"]
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
        
        //获取城市数据
        getAllRegionInfo()
        
        //获取行业数据
        getAllIndustryInfo()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //获取热搜数据
        getHotsSearchInfo()
    }
  
}

extension SearchBackedLendingViewController: UITextFieldDelegate {
    
    @objc private func textDidChange() {
        let isComposing = self.headView.searchHeadView.searchTx.markedTextRange != nil
        if !isComposing {
            let searchStr = self.headView.searchHeadView.searchTx.text ?? ""
            
            // Check for special characters
            let filteredText = filterAllSpecialCharacters(searchStr)
            if filteredText != searchStr {
                ToastViewConfig.showToast(message: "禁止输入特殊字符")
                self.headView.searchHeadView.searchTx.text = filteredText
                return
            }
            
            if searchStr.count < 2 && !searchStr.isEmpty {
                ToastViewConfig.showToast(message: "至少输入2个关键词")
                self.oneView.isHidden = false
                //获取热搜数据
                getHotsSearchInfo()
                return
            } else if searchStr.count > 100 {
                self.headView.searchHeadView.searchTx.text = String(searchStr.prefix(100))
                ToastViewConfig.showToast(message: "最多输入100个关键词")
            } else if searchStr.isEmpty {
                self.oneView.isHidden = false
                //获取热搜数据
                getHotsSearchInfo()
                return
            }
            self.oneView.isHidden = true
            if selectIndex == 0 {
                companyVc.searchWords.accept(self.headView.searchHeadView.searchTx.text ?? "")
            }else {
                peopleVc.searchWords.accept(self.headView.searchHeadView.searchTx.text ?? "")
            }
            self.getNumInfo(from: self.headView.searchHeadView.searchTx.text ?? "")
        }
    }
}

extension SearchBackedLendingViewController: JXPagingViewDelegate, JXSegmentedViewDelegate {
    
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
            return companyVc
        }else{
            return peopleVc
        }
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        selectIndex = index
        if index == 0 {
            self.companyVc.searchWords.accept(self.headView.searchHeadView.searchTx
                .text ?? "")
        }else {
            self.peopleVc.searchWords.accept(self.headView.searchHeadView.searchTx
                .text ?? "")
        }
    }
    
}

/** 网络数据请求 */
extension SearchBackedLendingViewController {
    
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
                self.companyVc.regionModelArray.accept(modelArray)
                self.peopleVc.regionModelArray.accept(modelArray)
            }
        }
    }
    
    private func getNumInfo(from keywords: String){
        let dict = ["keyword": keywords, "riskType": "ASSET_MORTGAGE_COUNT"]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/v2/home-page/risk-correlation/table-count",
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    guard let self = self else { return }
                    let companyCount = success.data?.orgCount ?? 0
                    let peopleCount = success.data?.personCount ?? 0
                    let titles = ["企业\(companyCount)", "人员\(peopleCount)"]
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
        getLastSearchInfo(from: "24") { [weak self] modelArray in
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
        getLastHistroyInfo(from: "24") { [weak self] modelArray in
            self?.historyArray = modelArray
            group.leave()
        }
        
        group.enter()
        getLastHotsInfo(from: "24") { [weak self] modelArray in
            self?.hotsArray = modelArray
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.modelArray = [self.historyArray, self.hotsArray]
            self.oneView.modelArray = self.modelArray
            DispatchQueue.main.asyncAfter(delay: 0.25) {
                self.headView.searchHeadView.searchTx.becomeFirstResponder()
            }
        }
        
    }
    
}
