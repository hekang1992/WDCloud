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
        oneView.addMonitoringBlock = { [weak self] in
            self?.getHotsMessageInfo()
        }
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
    
    //热门搜索
    var oneArray: [DataModel]?
    //浏览历史
    var twoArray: [DataModel]?
    var allArray: [[DataModel]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //添加
        addSegmentedView()
        
        //获取城市数据
        getAllRegionInfo()
        
        //获取行业数据
        getAllIndustryInfo()
        
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
        
        headView.headView.backBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.backBlock?()
        }).disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //获取热搜浏览历史信息
        getHotsMessageInfo()
    }
    
}

extension PropertyOneViewController: UITextFieldDelegate {
    
    //获取热搜浏览历史信息
    private func getHotsMessageInfo() {
        let group = DispatchGroup()
        ViewHud.addLoadView()
        //获取热搜数据
        group.enter()
        getHotsInfo(complete: { [weak self] modelArray in
            self?.oneArray = modelArray
            group.leave()
        })
        
        //获取浏览历史
        group.enter()
        getHistoryInfo(complete: { [weak self] modelArray in
            self?.twoArray = modelArray
            group.leave()
        })
        
        // 所有任务完成后的通知
        group.notify(queue: .main) { [weak self] in
            let one = self?.oneArray ?? []
            let two = self?.twoArray ?? []
            self?.allArray = [two, one]
            self?.oneView.modelArray = self?.allArray ?? []
            DispatchQueue.main.asyncAfter(delay: 0.25) {
                self?.oneView.tableView.hideSkeleton()
                self?.oneView.tableView.reloadData()
            }
            ViewHud.hideLoadView()
            print("全部执行完成========全部执行完成")
        }
    }
    
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
                return
            } else if searchStr.count > 100 {
                self.headView.searchHeadView.searchTx.text = String(searchStr.prefix(100))
                ToastViewConfig.showToast(message: "最多输入100个关键词")
            } else if searchStr.isEmpty {
                self.oneView.isHidden = false
                return
            }
            self.oneView.isHidden = true
            if selectIndex == 0 {
                companyVc.searchWordsRelay.accept(self.headView.searchHeadView.searchTx.text ?? "")
            }else {
                peopleVc.searchWordsRelay.accept(self.headView.searchHeadView.searchTx.text ?? "")
            }
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

/** 网络数据请求 */
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
    func getHotsInfo(complete: @escaping (([DataModel]) -> Void)) {
        let man = RequestManager()
        let dict = [String :String]()
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/property/clues/search/hot-search",
                       method: .get) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let modelArray = success.datass {
                        complete(modelArray)
                    }
                }else {
                    complete([])
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取浏览历史
    func getHistoryInfo(complete: @escaping (([DataModel]) -> Void)) {
        let man = RequestManager()
        let dict = [String: String]()
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/property/clue/scan/history/list",
                       method: .get) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let modelArray = success.data?.datas {
                        complete(modelArray)
                    } 
                }else {
                    complete([])
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
