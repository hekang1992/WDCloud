//
//  UnioRiskDetailViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/17.
//  关联风险

import UIKit
import JXPagingView

class UnioRiskDetailViewController: WDBaseViewController {
    
    var enityId: String = ""
    
    var name: String = ""
    
    var logo: String = ""
    
    var functionType: String = "2"
    
    var relevaCompType: String = ""
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    //数据模型
    var model: DataModel?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(RiskUnioViewCell.self, forCellReuseIdentifier: "RiskUnioViewCell")
        return tableView
    }()
    
    lazy var headView: RiskUnioHeadView = {
        let headView = RiskUnioHeadView()
        return headView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(120)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(1)
        }
        //获取关联风险
        getUnioRiskInfo()
    }
}

extension UnioRiskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        return headView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model?.statisticRiskDtos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RiskUnioViewCell", for: indexPath) as? RiskUnioViewCell
        cell?.backgroundColor = .clear
        cell?.selectionStyle = .none
        let model = self.model?.statisticRiskDtos?[indexPath.row]
        cell?.model.accept(model)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.model?.statisticRiskDtos?[indexPath.row]
        let entityId = model?.orgId ?? ""
        let entityName = model?.orgName ?? ""
        let companyDetailVc = CompanyBothViewController()
        companyDetailVc.enityId.accept(entityId)
        companyDetailVc.companyName.accept(entityName)
        self.navigationController?.pushViewController(companyDetailVc, animated: true)
    }
    
}

/** 网络数据请求 */
extension UnioRiskDetailViewController {
    
    //获取关联风险
    private func getUnioRiskInfo() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["functionType": functionType,
                    "relevaCompType": relevaCompType,
                    "customernumber": customernumber,
                    "orgId": enityId]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/risk-monitor/statisticOrgRisk",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data,
                    let modelArray = model.statisticRiskDtos,
                    !modelArray.isEmpty {
                    self.model = model
                    self.refreshUI(from: model)
                    self.tableView.reloadData()
                }else {
                    self.addNodataView(from: self.view)
                }
                break
            case .failure(_):
                self.addNodataView(from: self.view)
                break
            }
        }
    }
    
    private func refreshUI(from model: DataModel) {
        let oneCount = model.totalCompanyCnt ?? 0
        let twoCount = model.totalRiskCnt ?? 0
        let descStr = "关联企业总共\(oneCount),累计风险\(twoCount)条"
        let attributedText = NSMutableAttributedString(string: descStr)
        let regex = try! NSRegularExpression(pattern: "\\d+")
        let matches = regex.matches(in: descStr, range: NSRange(descStr.startIndex..., in: descStr))
        for match in matches {
            attributedText.addAttribute(.foregroundColor, value: UIColor.init(cssStr: "#FF0000") as Any, range: match.range)
        }
        headView.descLabel.attributedText = attributedText
        
        headView.oneView.numLabel.attributedText = GetRedStrConfig.getRedStr(from: "\(model.generaCompanyCnt ?? 0)", fullText: "\(model.generaCompanyCnt ?? 0)家", colorStr: "#1677FF")
        
        headView.twoView.numLabel.attributedText = GetRedStrConfig.getRedStr(from: "\(model.investCompanyCnt ?? 0)", fullText: "\(model.investCompanyCnt ?? 0)家", colorStr: "#1677FF")
        
        headView.threeView.numLabel.attributedText = GetRedStrConfig.getRedStr(from: "\(model.directorCompanyCnt ?? 0)", fullText: "\(model.directorCompanyCnt ?? 0)家", colorStr: "#1677FF")
        
        headView.fourView.numLabel.attributedText = GetRedStrConfig.getRedStr(from: "\(model.shCompanyCnt ?? 0)", fullText: "\(model.shCompanyCnt ?? 0)家", colorStr: "#1677FF")
    }
    
}

extension UnioRiskDetailViewController: JXPagingViewListViewDelegate {
    
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
