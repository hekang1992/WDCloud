//
//  HistoryListViewController.swift
//  问道云
//
//  Created by Andrew on 2024/12/27.
//  个人中心浏览历史

import UIKit
import MJRefresh

class HistoryListViewController: WDBaseViewController {
    
    lazy var historyView: HistoryListView = {
        let historyView = HistoryListView()
        return historyView
    }()
    
    var viewType: String = ""
    
    var allArray: [rowsModel] = []//加载更多
    
    var pageNum: Int = 1
    
    weak var navController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(historyView)
        historyView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
        }
        
        //添加下拉刷新
        self.historyView.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getHistroyListInfo(from: viewType, pageNum: 1)
        })
        //加载更多
        self.historyView.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getHistroyListInfo(from: viewType, pageNum: pageNum)
        })
        
        historyView.modelBlock = { [weak self] model in
            guard let self = self else { return }
            let entityType = model.entityType ?? 0
            if entityType == 1 {
                //企业
                let companyDetailVc = CompanyBothViewController()
                companyDetailVc.enityId.accept(model.entityId ?? "")
                companyDetailVc.companyName.accept(model.entityName ?? "")
                navController?.navigationController?.pushViewController(companyDetailVc, animated: true)
            }else {
                //个人
                let peopleDetailVc = PeopleBothViewController()
                peopleDetailVc.personId.accept(String(model.entityId ?? ""))
                peopleDetailVc.peopleName.accept(model.entityName ?? "")
                navController?.navigationController?.pushViewController(peopleDetailVc, animated: true)
            }
        }
        
    }
    
    
}

/** 网络数据请求 */
extension HistoryListViewController {
    
    //获取浏览历史列表
    func getHistroyListInfo(from viewType: String, pageNum: Int) {
        ViewHud.addLoadView()
        var pageUrl: String = ""
        var dict = [String: Any]()
        var moduleId: String = ""
        self.viewType = viewType
        if viewType == "0" {
            //全部
            pageUrl = "/operation/view-record/query-list"
            dict = ["pageNum": pageNum,
                    "pageSize": 20] as [String : Any]
        }else {
            //企业和人员
            pageUrl = "/operation/view-record/query"
            if viewType == "1" {
                moduleId = "01"
            }else if viewType == "2" {
                moduleId = "02"
            }
            dict = ["moduleId": moduleId,
                    "pageNum": pageNum,
                    "pageSize": 20] as [String : Any]
        }
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: pageUrl,
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            ViewHud.hideLoadView()
            self.historyView.tableView.mj_header?.endRefreshing()
            self.historyView.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let model = success.data, let rows = model.rows, !rows.isEmpty  {
                    self.emptyView.removeFromSuperview()
                    if pageNum == 1 {
                        self.pageNum = 1
                        self.allArray.removeAll()
                    }
                    self.pageNum += 1
                    let rows = model.rows ?? []
                    self.allArray.append(contentsOf: rows)
                    self.historyView.modelArray.accept(self.allArray)
                    if self.allArray.count != model.total {
                        self.historyView.tableView.mj_footer?.isHidden = false
                    }else {
                        self.historyView.tableView.mj_footer?.isHidden = true
                    }
                }else {
                    self.addNodataView(from: self.historyView)
                }
                break
            case .failure(_):
                self.addNodataView(from: self.historyView)
                break
            }
        }
    }
    
}
