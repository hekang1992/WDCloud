//
//  PropertyPeopleViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/20.
//

import UIKit
import RxRelay
import RxSwift
import DropMenuBar
import JXPagingView

class PropertyPeopleViewController: WDBaseViewController {
    
    private let man = RequestManager()
    
    //城市数据
    var regionModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    var industryModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    //被搜索的关键词
    var searchWordsRelay = BehaviorRelay<String>(value: "")
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()
    
    //搜索参数
    var pageIndex: Int = 1
    var entityArea: String = ""//地区
    var entityIndustry: String = ""//行业
    var allArray: [pageDataModel] = []//加载更多
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.searchWordsRelay
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if !text.isEmpty {
                    self.pageIndex = 1
                    self.searchListInfo()
                }else {
                    self.pageIndex = 1
                    self.allArray.removeAll()
                    self.tableView.reloadData()
                }
            }).disposed(by: disposeBag)
        
        //添加下拉筛选
        let regionMenu = MenuAction(title: "全国", style: .typeList)!
        self.regionModelArray.asObservable().asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            let regionArray = getThreeRegionInfo(from: modelArray ?? [])
            regionMenu.listDataSource = regionArray
        }).disposed(by: disposeBag)
        
        regionMenu.didSelectedMenuResult = { [weak self] index, model, grand in
            guard let self = self else { return }
            self.entityArea = model?.currentID ?? ""
            self.pageIndex = 1
            self.searchListInfo()
        }
        
        let industryMenu = MenuAction(title: "行业", style: .typeList)!
        self.industryModelArray.asObservable().asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            let regionArray = getThreeIndustryInfo(from: modelArray ?? [])
            industryMenu.listDataSource = regionArray
        }).disposed(by: disposeBag)
        
        industryMenu.didSelectedMenuResult = { [weak self] index, model, grand in
            guard let self = self else { return }
            self.entityIndustry = model?.currentID ?? ""
            self.pageIndex = 1
            self.searchListInfo()
        }
        
        let menuView = DropMenuBar(action: [regionMenu, industryMenu])!
        menuView.backgroundColor = .white
        view.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(1)
            make.height.equalTo(30)
        }
        
        
    }
    
}

/** 网络数据请求 */
extension PropertyPeopleViewController {
    
    //财产线索列表
    private func searchListInfo() {
        let dict = ["keyWords": self.searchWordsRelay.value,
                    "searchType": "2",
                    "industryCode": entityIndustry,
                    "areaCode": entityArea,
                    "pageNum": pageIndex,
                    "pageSize": 20] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/property/clues/search/findPropertySearchList",
                       method: .post) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self, let model = success.data {
                        
                    }
                }
                break
            case .failure(let failure):
                break
            }
        }
        
    }
    
}

extension PropertyPeopleViewController: JXPagingViewListViewDelegate {
    
    func listView() -> UIView {
        return view
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }
    
    func listScrollView() -> UIScrollView { tableView }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
    
}
