//
//  ComanyRiskMoreDetailViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/5.
//

import UIKit
import RxRelay
import MJRefresh

class ComanyRiskMoreDetailViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        return headView
    }()
    
    lazy var riskHeadView: RiskDetailHeadView = {
        let riskHeadView = RiskDetailHeadView()
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
    
    var allArray: [itemsModel] = []
    
    var model: DataModel?
    
    var entityid: String = ""
    var itemnumber: String = ""
    var itemtype: String = ""
    var dateType: String = ""
    var caseproperty: String = ""
    var casetype: String = ""
    var pageNum: Int = 1
    var pageSize: Int = 20
    
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
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let model = itemsModel.value
        itemnumber = model?.itemnumber ?? ""
        if model?.caseproperty != "" {
            caseproperty = model?.caseproperty ?? ""
        }else {
            caseproperty = listmodel.value?.caseproperty ?? ""
        }
        headView.titlelabel.text = "企业风险信息"
        addHeadView(from: headView)
        view.addSubview(riskHeadView)
        riskHeadView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(-StatusHeightManager.navigationBarHeight + 15.5)
            make.height.equalTo(90)
        }
        
        riskHeadView.iconImageView.kf.setImage(with: URL(string: logo), placeholder: UIImage.imageOfText(name, size: (40, 40)))
        riskHeadView.namelabel.text = name
        riskHeadView.timeLabel.text = "监控周期: 尚未监控"
        
        
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
        
        getDetailInfo()
    }
    
}

extension ComanyRiskMoreDetailViewController {
    
    private func getDetailInfo() {
        let man = RequestManager()
        let dict = ["entityid": entityid,
                    "itemnumber": itemnumber,
                    "itemtype": itemtype,
                    "dateType": dateType,
                    "caseproperty": caseproperty,
                    "casetype": casetype,
                    "pageNum": pageNum,
                    "pageSize": pageSize] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "riskmonitor/riskmonitoring/riskDynamicsberefining",
                       method: .get) { [weak self] result in
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
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
                    let pageData = model.items ?? []
                    self.allArray.append(contentsOf: pageData)
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
                        self.noNetView.removeFromSuperview()
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
            case .failure(let failure):
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
            namelabel.text = oneModel.itemname ?? ""
            numlabel.text = "共\(self.model?.total ?? 0)条"
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
        cell.nameLabel.text = model.itemname ?? ""
        cell.timelabel.text = model.risktime ?? ""
        let riskLevel = model.risklevel ?? ""
        if riskLevel == "3" {
            cell.highLabel.text = "提示"
            cell.highLabel.backgroundColor = UIColor.init(cssStr: "#3F96FF")?.withAlphaComponent(0.05)
            cell.highLabel.textColor = UIColor.init(cssStr: "#3F96FF")
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
        let itemnumber = model.itemnumber ?? "0"
        let riskdynamicid = model.riskdynamicid ?? ""
        let pageUrl = "\(base_url)/risk-detail/\(itemnumber)_\(riskdynamicid)"
        self.pushWebPage(from: pageUrl)
    }
    
}

