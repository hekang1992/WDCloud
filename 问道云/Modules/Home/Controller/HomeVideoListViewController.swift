//
//  HomeVideoListViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/5.
//

import UIKit
import JXPagingView
import JXSegmentedView
import RxRelay
import MJRefresh

class HomeVideoListViewController: WDBaseViewController {
    
    var pageNum = 1
    
    var allArray: [rowsModel] = []//加载更多
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    var modelArray = BehaviorRelay<[rowsModel]?>(value: nil)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(HomeVideoListViewCell.self, forCellReuseIdentifier: "HomeVideoListViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        //下拉刷新
        tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            self?.getHomeVieoListInfo(from: 1)
        })
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            self?.getHomeVieoListInfo(from: self?.pageNum ?? 1)
        })
        //获取讲堂数据
        getHomeVieoListInfo(from: 1)
        
        modelArray.asObservable().compactMap { $0 }.bind(to: tableView.rx.items(cellIdentifier: "HomeVideoListViewCell", cellType: HomeVideoListViewCell.self)) { row, model, cell in
            cell.model.accept(model)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.block = { [weak self] model in
                let type = model.type ?? ""
                if type == "1" {//企业
                    
                }else if type == "2" {//法典
                    let pageUrl = model.value ?? ""
                    if !pageUrl.isEmpty {
                        self?.pushWebPage(from: base_url + pageUrl)
                    }
                }else {
                    
                }
            }
        }.disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(rowsModel.self)
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                let videofile = model.videofile ?? ""
                self.pushWebPage(from: videofile)
            }).disposed(by: disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("将要显示========讲堂")
    }
    
}

extension HomeVideoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
}

/** 网络数据请求 */
extension HomeVideoListViewController {
    
    func getHomeVieoListInfo(from pageNum: Int) {
        let dict = ["pageNum": pageNum,
                    "pageSize": 10,
                    "pulishstate": 1,
                    "type": "1"] as [String : Any]
        let man = RequestManager()
        ViewHud.addLoadView()
        man.requestAPI(params: dict,
                       pageUrl: "/operation/webvideo/list",
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if pageNum == 1 {
                        self.pageNum = 1
                        self.allArray.removeAll()
                    }
                    self.pageNum += 1
                    let rows = success.rows ?? []
                    self.allArray.append(contentsOf: rows)
                    self.modelArray.accept(self.allArray)
                    if self.allArray.count != success.total {
                        self.tableView.mj_footer?.isHidden = false
                    }else {
                        self.tableView.mj_footer?.isHidden = true
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}

extension HomeVideoListViewController: JXPagingViewListViewDelegate {
    
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
