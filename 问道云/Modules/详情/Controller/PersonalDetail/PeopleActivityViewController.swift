//
//  PeopleActivityViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/12.
//  企业动态详情

import UIKit
import MJRefresh

class PeopleActivityViewController: WDBaseViewController {
    
    var personId: String = ""
    
    var personName: String = ""
    
    var pageIndex: Int = 1
    
    var allArray: [rowsModel] = []//加载更多数据
    
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
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        return ctImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .mediumFontOfSize(size: 16)
        nameLabel.textColor = .init(cssStr: "#111111")
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(ctImageView)
        view.addSubview(nameLabel)
        view.addSubview(lineView)
        
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.left.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.height.equalTo(30)
            make.left.equalTo(ctImageView.snp.right).offset(6)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(ctImageView.snp.bottom).offset(11)
        }
        
        nameLabel.text = personName
        ctImageView.image = UIImage.imageOfText(personName, size: (40, 40))
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
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
        self.tableView.mj_footer?.isHidden = true
        
        //获取动态数据
        getActivityInfo()
    }
    
}

extension PeopleActivityViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.allArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArray[section].data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyActivityViewCell", for: indexPath) as? CompanyActivityViewCell {
            cell.selectionStyle = .none
            let model = self.allArray[indexPath.section].data?[indexPath.row]
            cell.model.accept(model)
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    cell.lineView1.isHidden = true
                    cell.cycleViewImage.image = UIImage(named: "dontaiimgeblue")
                    cell.cycleViewImage.snp.updateConstraints { make in
                        make.size.equalTo(CGSize(width: 9, height: 9))
                        make.left.equalToSuperview().offset(14)
                    }
                }
            }else {
                cell.lineView1.isHidden = false
                cell.cycleViewImage.image = UIImage(named: "dontaiimgegray")
                cell.cycleViewImage.snp.updateConstraints { make in
                    make.size.equalTo(CGSize(width: 5, height: 5))
                    make.left.equalToSuperview().offset(16)
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.allArray[indexPath.section].data?[indexPath.row]
        let pageUrl = base_url + "\(model?.h5Path ?? "")"
        self.pushWebPage(from: pageUrl)
    }
    
}

extension PeopleActivityViewController {
    
    private func getActivityInfo() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["personId": personId,
                    "pageNum": pageIndex,
                    "pageSize": "20"] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/risk/queryPersonRiskDynamics",
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
                    let pageData = model.rows ?? []
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
                ViewHud.hideLoadView()
                break
            case .failure(_):
                ViewHud.hideLoadView()
                break
            }
        }
    }
    
}
