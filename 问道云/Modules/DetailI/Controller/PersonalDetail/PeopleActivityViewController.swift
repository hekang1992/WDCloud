//
//  PeopleActivityViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/12.
//  个人动态详情

import UIKit
import MJRefresh

class PeopleActivityViewController: WDBaseViewController {
    
    var personId: String = ""
    
    var pageIndex: Int = 1
    
    var allArray: [itemsModel] = []//加载更多数据
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false        
        tableView.register(CompanyActivityViewCell.self, forCellReuseIdentifier: "CompanyActivityViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
        }
        
        //添加下拉刷新
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.pageIndex = 1
            self.getActivityInfo()
        })
        
        //添加上拉加载更多
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.getActivityInfo()
        })
        
        //获取动态数据
        getActivityInfo()
    }
    
}

extension PeopleActivityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 63
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !self.allArray.isEmpty {
            let nameStr = self.allArray[0].firmname ?? ""
            let headView = UIView()
            headView.backgroundColor = .white
            let icon = UIImageView()
            let lineView = UIView()
            lineView.backgroundColor = UIColor.init(cssStr: "#D4D4D4")?.withAlphaComponent(0.5)
            let label = UILabel()
            label.font = .mediumFontOfSize(size: 16)
            label.textColor = .init(cssStr: "#111111")
            label.textAlignment = .left
            headView.addSubview(icon)
            headView.addSubview(label)
            headView.addSubview(lineView)
            icon.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize(width: 35, height: 35))
                make.left.equalToSuperview().offset(12)
            }
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(icon.snp.right).offset(6)
                make.height.equalTo(22.5)
            }
            lineView.snp.makeConstraints { make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(0.5)
            }
            label.text = nameStr
            icon.image = UIImage.imageOfText(nameStr, size: (35, 35))
            return headView
        }else {
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyActivityViewCell", for: indexPath) as? CompanyActivityViewCell {
            cell.selectionStyle = .none
            let model = self.allArray[indexPath.row]
            cell.model.accept(model)
            if indexPath.row == 0 {
                cell.lineView1.isHidden = true
                cell.cycleView.backgroundColor = UIColor.init(cssStr: "#3849F7")
                cell.cycleView.layer.borderWidth = 4
                cell.cycleView.layer.borderColor = UIColor.init(cssStr: "#3849F7")?.withAlphaComponent(0.3).cgColor
            }else {
                cell.lineView1.isHidden = false
                cell.cycleView.backgroundColor = UIColor.init(cssStr: "#D8D8D8")
                cell.cycleView.layer.borderWidth = 0
                cell.cycleView.layer.borderColor = UIColor.clear.cgColor
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.allArray[indexPath.row]
        let pageUrl = model.riskDetailPath ?? ""
        self.pushWebPage(from: pageUrl)
    }
    
}

extension PeopleActivityViewController {
    
    private func getActivityInfo() {
        let man = RequestManager()
        let dict = ["personNumber": personId,
                    "pageNum": pageIndex,
                    "pageSize": "20"] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/riskmonitor/generate/dynamicRiskData",
                       method: .get) { [weak self] result in
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let self = self,
                   let model = success.data,
                   let code = success.code,
                   code == 200, let total = model.total {
                    if pageIndex == 1 {
                        pageIndex = 1
                        self.allArray.removeAll()
                    }
                    pageIndex += 1
                    let pageData = model.items ?? []
                    self.allArray.append(contentsOf: pageData)
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
                        self.noNetView.removeFromSuperview()
                    }else {
                        self.addNodataView(from: self.view)
                    }
                    if self.allArray.count != total {
                        self.tableView.mj_footer?.isHidden = false
                    }else {
                        self.tableView.mj_footer?.isHidden = true
                    }
                    self.tableView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
