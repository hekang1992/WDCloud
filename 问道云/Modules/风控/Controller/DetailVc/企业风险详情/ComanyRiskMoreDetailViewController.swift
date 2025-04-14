//
//  ComanyRiskMoreDetailViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/5.
//

import UIKit
import RxRelay
import MJRefresh
import SwiftyJSON

class ComanyRiskMoreDetailViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        return headView
    }()
    
    lazy var riskHeadView: CompanyRiskDetailHeadView = {
        let riskHeadView = CompanyRiskDetailHeadView()
        riskHeadView.reportBtn.isHidden = true
        return riskHeadView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .mediumFontOfSize(size: 13)
        return namelabel
    }()
    
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "downconimage")
        return rightImageView
    }()
    
    lazy var numlabel: UILabel = {
        let numlabel = UILabel()
        numlabel.textColor = UIColor.init(cssStr: "#999999")
        numlabel.textAlignment = .right
        numlabel.font = .regularFontOfSize(size: 11)
        return numlabel
    }()

    var name: String = ""
    
    var logo: String = ""
    
    var itemsModel = BehaviorRelay<itemsModel?>(value: nil)
    var listmodel = BehaviorRelay<threelevelitemsModel?>(value: nil)
    
    var allArray: [rowsModel] = []
    
    var model: DataModel?
    
    var orgId: String = ""
    var itemId: String = ""
    var historyFlag: String = ""
    var dateType: String = ""
    var pageNum: Int = 1
    
    var monitoringTime: String = ""
    var groupName: String = ""
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        return whiteView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(CompanyLawDetailCell.self, forCellReuseIdentifier: "CompanyLawDetailCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        headView.titlelabel.text = "企业风险信息"
        view.addSubview(riskHeadView)
        addHeadView(from: headView)
        riskHeadView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(90)
        }
        
        riskHeadView.iconImageView.kf.setImage(with: URL(string: logo), placeholder: UIImage.imageOfText(name, size: (40, 40)))
        riskHeadView.namelabel.text = name
         
        if monitoringTime.isEmpty {
            riskHeadView.timeLabel.text = "监控周期:未监控"
        }else {
            riskHeadView.timeLabel.text = "\(monitoringTime)"
        }
        
        if groupName.isEmpty {
            riskHeadView.tagLabel.text = ""
            riskHeadView.tagLabel.isHidden = true
        }else {
            riskHeadView.tagLabel.text = groupName
            riskHeadView.tagLabel.isHidden = false
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(riskHeadView.snp.bottom).offset(StatusHeightManager.navigationBarHeight)
        }
        
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            pageNum = 1
            getDetailInfo()
        })
        
        //添加上拉加载更多
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.getDetailInfo()
        })
        
        //跳转一键报告
        riskHeadView.reportBtnBlock = { [weak self] in
            guard let self = self else { return }
            let oneRpVc = OneReportViewController()
            let json: JSON = ["orgId": orgId,
                              "orgName": name]
            let orgInfo = orgInfoModel(json: json)
            oneRpVc.orgInfo = orgInfo
            self.navigationController?.pushViewController(oneRpVc, animated: true)
        }
        
        riskHeadView.nameClickBlock = { [weak self] in
            guard let self = self else { return }
            let detailVc = CompanyBothViewController()
            let entityid = orgId
            let firmname = name
            detailVc.enityId.accept(entityid)
            detailVc.companyName.accept(firmname)
            self.navigationController?.pushViewController(detailVc, animated: true)
        }
        
        getDetailInfo()
    }
    
}

/** 网络数据请求 */
extension ComanyRiskMoreDetailViewController {
    
    private func getDetailInfo() {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["orgId": orgId,
                    "itemId": itemId,
                    "historyFlag": historyFlag,
                    "pageNum": pageNum,
                    "pageSize": 20] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/risk/queryOrgRiskList",
                       method: .get) { [weak self] result in
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if let self = self,
                   let model = success.data,
                   let code = success.code,
                   code == 200, let total = model.total {
                    self.model = model
                    if pageNum == 1 {
                        pageNum = 1
                        self.allArray.removeAll()
                    }
                    pageNum += 1
                    let pageData = model.rows ?? []
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
                break
            case .failure(_):
                break
            }
        }
    }
    
}

extension ComanyRiskMoreDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.allArray.count > 0 {
            let oneModel = self.allArray[0]
            let headView = UIView()
            headView.addSubview(namelabel)
            headView.addSubview(numlabel)
            headView.addSubview(rightImageView)
            namelabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(12)
                make.height.equalTo(18.5)
            }
            rightImageView.snp.makeConstraints { make in
                make.centerY.equalTo(namelabel.snp.centerY)
                make.right.equalToSuperview().offset(-17)
                make.size.equalTo(CGSize(width: 10, height: 10))
            }
            numlabel.snp.makeConstraints { make in
                make.centerY.equalTo(namelabel.snp.centerY)
                make.right.equalTo(rightImageView.snp.left).offset(-4)
                make.height.equalTo(15)
            }
            namelabel.text = oneModel.riskName ?? ""
            let total = String(self.model?.total ?? 0)
            numlabel.attributedText = GetRedStrConfig.getRedStr(from: total, fullText: "共\(total)条", font: UIFont.regularFontOfSize(size: 11))
            return headView
        }else {
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.allArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyLawDetailCell", for: indexPath) as! CompanyLawDetailCell
        cell.nameLabel.text = model.riskName ?? ""
        cell.timelabel.text = model.riskTime ?? ""
        let riskLevel = model.riskLevel ?? ""
        if riskLevel == "3" {
            cell.highLabel.text = "提示"
            cell.highLabel.backgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.05)
            cell.highLabel.textColor = UIColor.init(cssStr: "#547AFF")
        } else if riskLevel == "2" {
            cell.highLabel.text = "低风险"
            cell.highLabel.backgroundColor = UIColor.init(cssStr: "#FFEEDE")
            cell.highLabel.textColor = UIColor.init(cssStr: "#FF7D00")
        } else {
            cell.highLabel.text = "高风险"
            cell.highLabel.backgroundColor = UIColor.init(cssStr: "#FEF0EF")
            cell.highLabel.textColor = UIColor.init(cssStr: "#F55B5B")
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.allArray[indexPath.row]
        let h5Path = model.h5Path ?? ""
        let pageUrl = "\(base_url)\(h5Path)"
        self.pushWebPage(from: pageUrl)
    }
    
}

