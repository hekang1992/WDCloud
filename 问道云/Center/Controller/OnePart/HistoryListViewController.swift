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
            let viewrecordtype = model.viewrecordtype ?? ""
            if viewrecordtype == "1" {//企业
                let companyDetailVc = CompanyBothViewController()
                companyDetailVc.enityId.accept(model.firmnumber ?? "")
                companyDetailVc.companyName.accept(model.firmname ?? "")
                navController?.navigationController?.pushViewController(companyDetailVc, animated: true)
            }else {//个人
                let peopleDetailVc = PeopleBothViewController()
                peopleDetailVc.enityId.accept(String(model.personnumber ?? ""))
                peopleDetailVc.peopleName.accept(model.personname ?? "")
                navController?.navigationController?.pushViewController(peopleDetailVc, animated: true)
            }
        }
        
    }


}


extension HistoryListViewController {
    
    //获取浏览历史列表
    func getHistroyListInfo(from viewType: String, pageNum: Int) {
        self.viewType = viewType
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["viewrecordtype": viewType,
                    "pageNum": pageNum,
                    "pageSize": 20] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/clientbrowsecb/selectBrowserecord",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            guard let self = self else { return }
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
