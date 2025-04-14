//
//  RiskTipsCenterViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/19.
//

import UIKit
import MJRefresh

class RiskTipsCenterViewController: WDBaseViewController {
    
    var pageNum: Int = 1
    let pulishstate = "1"
    
    var allArray: [rowsModel] = []
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "风控秘笈"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setImage(UIImage(named: "rightHeadLogo"), for: .normal)
        return headView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(HomeNewsListViewCell.self, forCellReuseIdentifier: "HomeNewsListViewCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        addHeadView(from: headView)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom)
        }
        getListInfo()
        //下拉刷新
        tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.pageNum = 1
            getListInfo()
        })
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getListInfo()
        })
        
    }
    
}

extension RiskTipsCenterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.allArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNewsListViewCell", for: indexPath) as! HomeNewsListViewCell
        cell.selectionStyle = .none
        cell.model.accept(model)
        cell.block = { [weak self] model in
            let type = model.type ?? ""
            if type == "1" {//企业
                let companyDetailVc = CompanyBothViewController()
                companyDetailVc.enityId.accept(model.tag ?? "")
                companyDetailVc.companyName.accept(model.name ?? "")
                self?.navigationController?.pushViewController(companyDetailVc, animated: true)
            }else if type == "2" {//法典
                let pageUrl = model.value ?? ""
                if !pageUrl.isEmpty {
                    self?.pushWebPage(from: pageUrl)
                }
            }else {
                
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.allArray[indexPath.row]
        let itemId = model.itemId ?? ""
        let pageUrl = "/news-information?itemId=\(itemId)"
        self.pushWebPage(from: base_url + pageUrl)
    }
    
}

/** 网络数据请求 */
extension RiskTipsCenterViewController {
    
    private func getListInfo() {
        let dict = ["pageNum": pageNum,
                    "type": 2,
                    "pulishstate": pulishstate,
                    "pageSize": 10] as [String : Any]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/operation/webnews/list",
                       method: .get) { [weak self] result in
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let self = self, let code = success.code, code == 200 {
                    if let rows = success.rows, let total = success.total {
                        if pageNum == 1 {
                            pageNum = 1
                            self.allArray.removeAll()
                        }
                        pageNum += 1
                        let pageData = rows
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
                        self.tableView.reloadData()
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
