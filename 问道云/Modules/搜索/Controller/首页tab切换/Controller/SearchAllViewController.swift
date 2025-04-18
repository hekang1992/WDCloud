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
    
    var isonePopKeybord: Bool = false
    var istwoPopKeybord: Bool = false
    var isthreePopKeybord: Bool = false
    var isVoice: Bool = false
    
    var segmentedViewDataSource: JXSegmentedTitleDataSource!
    
    var segmentedView: JXSegmentedView!
    
    let titles = ["企业", "人员", "风险"]
    
    var JXTableHeaderViewHeight: Int = 104
    
    var JXheightForHeaderInSection: Int = 40
    
    lazy var pagingView: JXPagingView = preferredPagingView()
        
    var name: String = ""
    
    let segmentedDataSource = JXSegmentedTitleDataSource()
    
    lazy var searchHeadView: SearchHeadView = {
        let searchHeadView = SearchHeadView()
        searchHeadView.searchTx.placeholder = name
        searchHeadView.backBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }).disposed(by: disposeBag)
        return searchHeadView
    }()
    
    lazy var enterpriseVc: SearchEnterpriseViewController = {
        let enterpriseVc = SearchEnterpriseViewController()
        enterpriseVc.completeBlock = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(delay: 0.5) {
                if self.isonePopKeybord == false {
                    self.isonePopKeybord = true
                    self.searchHeadView.searchTx.becomeFirstResponder()
                }
            }
        }
        return enterpriseVc
    }()
    
    lazy var peopleVc: SearchBossViewController = {
        let peopleVc = SearchBossViewController()
        peopleVc.completeBlock = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(delay: 0.5) {
                if self.istwoPopKeybord == false {
                    self.istwoPopKeybord = true
                    self.searchHeadView.searchTx.becomeFirstResponder()
                }
            }
        }
        return peopleVc
    }()
    
    lazy var riskVc: SearchRiskViewController = {
        let riskVc = SearchRiskViewController()
        riskVc.completeBlock = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(delay: 0.5) {
                if self.isthreePopKeybord == false {
                    self.isthreePopKeybord = true
                    self.searchHeadView.searchTx.becomeFirstResponder()
                }
            }
        }
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
        self.searchHeadView.searchTx.delegate = self
        
        // 监听文本变化（包括拼音输入确认）
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChange),
            name: UITextField.textDidChangeNotification,
            object: self.searchHeadView.searchTx
        )
        
        if selectIndex == 0 {
            enterpriseVc.searchWords.accept("")
        }else if selectIndex == 1 {
            peopleVc.searchWords.accept("")
        }else {
            riskVc.searchWords.accept("")
        }
        
        let nameStr = self.searchHeadView.searchTx.text ?? ""
        if !nameStr.isEmpty {
            self.searchHeadView.backBtn.isHidden = false
            self.searchHeadView.clickBtn.isHidden = true
            self.searchHeadView.searchView.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(45)
                make.right.equalToSuperview().offset(-10)
            }
            UIView.animate(withDuration: 0.25) {
                self.searchHeadView.layoutIfNeeded()
            }
        }
        
        if isVoice {
            textDidChange()
        }
        
    }
    
}

extension SearchAllViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let text = textField.text ?? ""
        if selectIndex == 0 {
            if text.isEmpty {
                self.searchHeadView.searchTx.text = self.searchHeadView.searchTx.placeholder
                enterpriseVc.searchWords.accept(self.searchHeadView.searchTx.placeholder)
            }else {
                self.searchHeadView.searchTx.text = text
                enterpriseVc.searchWords.accept(text)
            }
        }else if selectIndex == 1 {
            if text.isEmpty {
                self.searchHeadView.searchTx.text = self.searchHeadView.searchTx.placeholder
                peopleVc.searchWords.accept(self.searchHeadView.searchTx.placeholder)
            }else {
                self.searchHeadView.searchTx.text = text
                peopleVc.searchWords.accept(text)
            }
        } else {
            if text.isEmpty {
                self.searchHeadView.searchTx.text = self.searchHeadView.searchTx.placeholder
                riskVc.searchWords.accept(self.searchHeadView.searchTx.placeholder)
            }else {
                self.searchHeadView.searchTx.text = text
                riskVc.searchWords.accept(text)
            }
        }
        let name = self.searchHeadView.searchTx.text ?? ""
        if name.count >= 2 {
            self.searchHeadView.backBtn.isHidden = false
            self.searchHeadView.clickBtn.isHidden = true
            self.searchHeadView.searchView.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(45)
                make.right.equalToSuperview().offset(-10)
            }
            UIView.animate(withDuration: 0.25) {
                self.searchHeadView.layoutIfNeeded()
            }
        }
        return true
    }
    
    @objc private func textDidChange() {
        let isComposing = self.searchHeadView.searchTx.markedTextRange != nil
        if !isComposing {
            let searchStr = self.searchHeadView.searchTx.text ?? ""
            
            // Check for special characters
            let filteredText = filterAllSpecialCharacters(searchStr)
            if filteredText != searchStr {
                ToastViewConfig.showToast(message: "禁止输入特殊字符")
                searchHeadView.searchTx.text = filteredText
                return
            }
            
            if searchStr.count < 2 && !searchStr.isEmpty {
                ToastViewConfig.showToast(message: "至少输入2个关键词")
                self.searchHeadView.backBtn.isHidden = true
                self.searchHeadView.clickBtn.isHidden = false
                self.searchHeadView.searchView.snp.updateConstraints { make in
                    make.left.equalToSuperview().offset(10)
                    make.right.equalToSuperview().offset(-50)
                }
                UIView.animate(withDuration: 0.25) {
                    self.searchHeadView.layoutIfNeeded()
                }
            } else if searchStr.count > 100 {
                searchHeadView.searchTx.text = String(searchStr.prefix(100))
                ToastViewConfig.showToast(message: "最多输入100个关键词")
            } else if searchStr.count >= 2 {
                self.searchHeadView.backBtn.isHidden = false
                self.searchHeadView.clickBtn.isHidden = true
                self.searchHeadView.searchView.snp.updateConstraints { make in
                    make.left.equalToSuperview().offset(45)
                    make.right.equalToSuperview().offset(-10)
                }
                UIView.animate(withDuration: 0.25) {
                    self.searchHeadView.layoutIfNeeded()
                }
            }
            self.searchHeadView.searchTx.placeholder = searchHeadView.searchTx.text ?? ""
            if selectIndex == 0 {
                enterpriseVc.searchWords.accept(searchHeadView.searchTx.text ?? "")
            }else if selectIndex == 1 {
                peopleVc.searchWords.accept(searchHeadView.searchTx.text ?? "")
            }else {
                riskVc.searchWords.accept(searchHeadView.searchTx.text ?? "")
            }
        }
        
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
                enterpriseVc.searchWords.accept(self.searchHeadView.searchTx
                    .text ?? "")
                self.searchHeadView.backBtn.isHidden = false
                self.searchHeadView.clickBtn.isHidden = true
                self.searchHeadView.searchView.snp.updateConstraints { make in
                    make.left.equalToSuperview().offset(45)
                    make.right.equalToSuperview().offset(-10)
                }
                UIView.animate(withDuration: 0.25) {
                    self.searchHeadView.layoutIfNeeded()
                }
                DispatchQueue.main.asyncAfter(delay: 0.5) {
                    self.searchHeadView.searchTx.resignFirstResponder()
                }
            }
            enterpriseVc.moreBtnBlock = { [weak self] in
                guard let self = self else { return }
                segmentedView.selectItemAt(index: 1)
                searchHeadView.searchTx.placeholder = self.searchHeadView.searchTx.text ?? ""
                searchHeadView.searchTx.text = self.searchHeadView.searchTx.text ?? ""
                peopleVc.searchWords.accept(self.searchHeadView.searchTx
                    .text ?? "")
            }
            return enterpriseVc
        }else if index == 1 {
            peopleVc.lastSearchTextBlock = { [weak self] searchStr in
                guard let self = self else { return }
                searchHeadView.searchTx.placeholder = searchStr
                searchHeadView.searchTx.text = searchStr
                peopleVc.searchWords.accept(self.searchHeadView.searchTx
                    .text ?? "")
                self.searchHeadView.backBtn.isHidden = false
                self.searchHeadView.clickBtn.isHidden = true
                self.searchHeadView.searchView.snp.updateConstraints { make in
                    make.left.equalToSuperview().offset(45)
                    make.right.equalToSuperview().offset(-10)
                }
                UIView.animate(withDuration: 0.25) {
                    self.searchHeadView.layoutIfNeeded()
                }
                DispatchQueue.main.asyncAfter(delay: 0.5) {
                    self.searchHeadView.searchTx.resignFirstResponder()
                }
            }
            return peopleVc
        }else {
            riskVc.lastSearchTextBlock = { [weak self] searchStr in
                guard let self = self else { return }
                searchHeadView.searchTx.text = searchStr
                searchHeadView.searchTx.placeholder = searchStr
                riskVc.searchWords.accept(self.searchHeadView.searchTx
                    .text ?? "")
                self.searchHeadView.backBtn.isHidden = false
                self.searchHeadView.clickBtn.isHidden = true
                self.searchHeadView.searchView.snp.updateConstraints { make in
                    make.left.equalToSuperview().offset(45)
                    make.right.equalToSuperview().offset(-10)
                }
                UIView.animate(withDuration: 0.25) {
                    self.searchHeadView.layoutIfNeeded()
                }
                DispatchQueue.main.asyncAfter(delay: 0.5) {
                    self.searchHeadView.searchTx.resignFirstResponder()
                }
            }
            return riskVc
        }
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        selectIndex = index
        if index == 0 {
            self.enterpriseVc.searchWords.accept(self.searchHeadView.searchTx
                .text ?? "")
        }else if index == 1 {
            self.peopleVc.searchWords.accept(self.searchHeadView.searchTx
                .text ?? "")
        }else if index == 2 {
            self.riskVc.searchWords.accept(self.searchHeadView.searchTx
                .text ?? "")
        }else {
            
        }
    }
    
}

/** 网络数据请求 */
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

