//
//  ContorlDetailViewViewController.swift
//  问道云
//
//  Created by 何康 on 2025/3/15.
//  实际控制人详情

import UIKit
import MJRefresh

class ContorlDetailViewViewController: WDBaseViewController {
    
    var entityId: String = ""
    var entityCategory: String = "1"
    var pageNum: Int = 1
    var allArray: [rowsModel] = []
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "作为实际控制人企业"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setBackgroundImage(UIImage(named: "headrightoneicon"), for: .normal)
        return headView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(ContorlDetailViewCell.self, forCellReuseIdentifier: "ContorlDetailViewCell")
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headView.snp.bottom)
        }
        
        //下拉刷新
        tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            self?.pageNum = 1
            self?.getListInfo()
        })
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            self?.getListInfo()
        })
        
        getListInfo()
    }

}

/** 网络数据请求 */
extension ContorlDetailViewViewController {
    
    //获取列表
    private func getListInfo() {
        let man = RequestManager()
        let dict = ["entityId": entityId,
                    "entityCategory": entityCategory,
                    "pageNum": pageNum,
                    "pageSize": 10] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/v2/home-page/actual/org-page",
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let model = success.data,
                   let code = success.code,
                   code == 200, let total = model.total {
                    if pageNum == 1 {
                        self.pageNum = 1
                        self.allArray.removeAll()
                    }
                    self.pageNum += 1
                    let rows = model.rows ?? []
                    self.allArray.append(contentsOf: rows)
                    if self.allArray.count != total {
                        self.tableView.mj_footer?.isHidden = false
                    }else {
                        self.tableView.mj_footer?.isHidden = true
                    }
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
                    }else {
                        self.addNodataView(from: self.tableView)
                    }
                    self.tableView.reloadData()
                }else {
                    self.addNodataView(from: self.tableView)
                }
                break
            case .failure(_):
                self.addNodataView(from: self.tableView)
                break
            }
        }
    }
    
}

extension ContorlDetailViewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.allArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContorlDetailViewCell", for: indexPath) as! ContorlDetailViewCell
        cell.selectionStyle = .none
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.allArray[indexPath.row]
        let comanyDetailVc = CompanyBothViewController()
        let enityId = model.orgId ?? ""
        let companyName = model.orgName ?? ""
        comanyDetailVc.enityId.accept(enityId)
        comanyDetailVc.companyName.accept(companyName)
        self.navigationController?.pushViewController(comanyDetailVc, animated: true)
    }
    
}
