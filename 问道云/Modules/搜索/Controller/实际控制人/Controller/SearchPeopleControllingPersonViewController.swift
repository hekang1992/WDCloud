//
//  SearchPeopleControllingPersonViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/20.
//

import UIKit
import RxRelay
import RxSwift
import DropMenuBar
import JXPagingView
import MJRefresh
import SkeletonView

class SearchPeopleControllingPersonViewController: WDBaseViewController {
    
    private let man = RequestManager()
    
    var blockModel: ((DataModel) -> Void)?
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    //被搜索的关键词
    var searchWordsRelay = BehaviorRelay<String>(value: "")

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(SearchContorlPeopleViewCell.self, forCellReuseIdentifier: "SearchContorlPeopleViewCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    //搜索参数
    var pageIndex: Int = 1
    var allArray: [itemsModel] = []//加载更多
    var dataModel: DataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.searchWordsRelay
            .distinctUntilChanged()
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.pageIndex = 1
                if text.count < 2 {
                    self.allArray.removeAll()
                    man.cancelLastRequest()
                }else {
                    self.searchListInfo()
                }
            }).disposed(by: disposeBag)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            pageIndex = 1
            searchListInfo()
        })
        
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            searchListInfo()
        })
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton()
        print("检查骨架屏是否激活========\(tableView.sk.isSkeletonActive)")
        print("检查是否支持骨架屏=========\(tableView.isSkeletonable)")
    }
    
}

extension SearchPeopleControllingPersonViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = .init(cssStr: "#F5F5F5")
        let numLabel = UILabel()
        numLabel.textColor = UIColor.init(cssStr: "#666666")
        numLabel.font = .regularFontOfSize(size: 12)
        numLabel.textAlignment = .left
        let count = String(self.dataModel?.total ?? 0)
        numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "搜索到\(count)位相关人员", font: .regularFontOfSize(size: 12))
        headView.addSubview(numLabel)
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(22)
        }
        return headView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchContorlPeopleViewCell", for: indexPath) as! SearchContorlPeopleViewCell
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        let model = self.allArray[indexPath.row]
        model.searchStr = self.searchWordsRelay.value
        cell.model.accept(model)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.allArray[indexPath.row]
        let detailVc = ContorlDetailViewViewController()
        let entityId = model.personId ?? ""
        detailVc.entityId = entityId
        detailVc.entityCategory = "2"
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
}

extension SearchPeopleControllingPersonViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "SearchContorlPeopleViewCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        let cell = skeletonView.dequeueReusableCell(withIdentifier: "SearchContorlPeopleViewCell", for: indexPath) as! SearchContorlPeopleViewCell
        cell.selectionStyle = .none
        return cell
    }
    
}

/** 网络数据请求 */
extension SearchPeopleControllingPersonViewController {
    
    //实际控制人
    private func searchListInfo() {
        ViewHud.addLoadView()
        let dict = ["keywords": self.searchWordsRelay.value,
                    "pageNum": pageIndex,
                    "pageSize": 20] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/v2/home-page/actual/person",
                       method: .get) { [weak self] result in
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self, let model = success.data, let total = model.total {
                        self.dataModel = model
                        self.blockModel?(model)
                        if pageIndex == 1 {
                            self.allArray.removeAll()
                        }
                        pageIndex += 1
                        let pageData = model.items ?? []
                        self.allArray.append(contentsOf: pageData)
                        if total != 0 {
                            self.emptyView.removeFromSuperview()
                        }else {
                            self.addNodataView(from: self.tableView)
                        }
                        if self.allArray.count != total {
                            self.tableView.mj_footer?.isHidden = false
                        }else {
                            self.tableView.mj_footer?.isHidden = true
                        }
                        DispatchQueue.main.asyncAfter(delay: 0.5) {
                            self.tableView.hideSkeleton()
                            self.tableView.reloadData()
                        }
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}

extension SearchPeopleControllingPersonViewController: JXPagingViewListViewDelegate {
    
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
