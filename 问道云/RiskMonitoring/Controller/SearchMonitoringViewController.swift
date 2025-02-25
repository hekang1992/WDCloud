//
//  SearchMonitoringViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/6.
//  搜索监控列表

import UIKit
import SnapKit
import MJRefresh
import TYAlertController

class SearchMonitoringViewController: WDBaseViewController {
    
    var pageNum: Int = 1
    var allArray: [rowsModel] = []
    //企业分组group
    var groupArray: [rowsModel]?
    //企业分组ID
    var groupnumber: String?
    var groupName: String?
    //个人数组
    var persons: [String] = []
    
    lazy var groupView: PopMonitoringGroupView = {
        let groupView = PopMonitoringGroupView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 300))
        return groupView
    }()
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "搜索监控企业"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .clear
        headView.oneBtn.setImage(UIImage(named: "headrightoneicon"), for: .normal)
        return headView
    }()
    
    lazy var cycleView: UIView = {
        let cycleView = UIView()
        cycleView.layer.cornerRadius = 4
        cycleView.layer.borderWidth = 1
        cycleView.layer.borderColor = UIColor.init(cssStr: "#DCDCDC")?.cgColor
        return cycleView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "searchiconf")
        return ctImageView
    }()
    
    lazy var descImageView: UIImageView = {
        let descImageView = UIImageView()
        descImageView.image = UIImage(named: "miaoshiuriskomn")
        return descImageView
    }()
    
    lazy var searchTx: UITextField = {
        let searchTx = UITextField()
        let attrString = NSMutableAttributedString(string: "请输入你需要监控的企业名称", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#DCDCDC") as Any,
            .font: UIFont.mediumFontOfSize(size: 14)
        ])
        searchTx.attributedPlaceholder = attrString
        searchTx.font = UIFont.mediumFontOfSize(size: 14)
        searchTx.textColor = UIColor.init(cssStr: "#333333")
        searchTx.clearButtonMode = .whileEditing
        searchTx.delegate = self
        return searchTx
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(SearchMonitoringViewCell.self, forCellReuseIdentifier: "SearchMonitoringViewCell")
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
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        addHeadView(from: headView)
        view.addSubview(cycleView)
        cycleView.addSubview(ctImageView)
        cycleView.addSubview(searchTx)
        view.addSubview(descImageView)
        view.addSubview(tableView)
        cycleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(headView.snp.bottom).offset(4)
            make.height.equalTo(40)
        }
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 17, height: 17))
            make.left.equalToSuperview().offset(10)
        }
        searchTx.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.right.equalToSuperview().offset(-4)
            make.left.equalTo(ctImageView.snp.right).offset(10)
        }
        descImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-17)
            make.size.equalTo(CGSize(width: 337, height: 79))
        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(cycleView.snp.bottom).offset(2)
            make.bottom.equalTo(descImageView.snp.top).offset(-2)
        }
        
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            pageNum = 1
            getSearchListInfo(from: self.searchTx.text ?? "")
        })
        
        //添加上拉加载更多
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getSearchListInfo(from: self.searchTx.text ?? "")
        })
        //查询监控分组
        getMonitoringGroupInfo()
    }
    
}

extension SearchMonitoringViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("搜索文字:\(textField.text ?? "")")
        textField.resignFirstResponder()
        self.pageNum = 1
        getSearchListInfo(from: textField.text ?? "")
        return true
    }
    
    //搜索监控列表
    private func getSearchListInfo(from targetStr: String) {
        let dict = ["entityName": targetStr,
                    "pageNum": pageNum,
                    "pageSize": 20] as [String : Any]
        let man = RequestManager()
        ViewHud.addLoadView()
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitortarget/riskInquiryEntity",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let self = self,
                   let model = success.data,
                   let code = success.code,
                   code == 200,
                   let total = model.total {
                    if pageNum == 1 {
                        pageNum = 1
                        self.allArray.removeAll()
                    }
                    pageNum += 1
                    let pageData = model.rows ?? []
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
            case .failure(_):
                break
            }
        }
    }
    
    //查询监控分组
    func getMonitoringGroupInfo() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitorgroup/selectMonitorGroup",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if let model = success.data {
                    self?.groupArray = model.rows ?? []
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}

extension SearchMonitoringViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = .init(cssStr: "#F6F6F6")
        return headView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.allArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.allArray[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMonitoringViewCell", for: indexPath) as! SearchMonitoringViewCell
        cell.selectionStyle = .none
        //默认选择第一个分组
        if let groupArray = self.groupArray, let rowsModel = groupArray.first {
            let name = model.groupName ?? ""
            let groupId = model.groupId ?? ""
            if name.isEmpty {
                cell.menuBtn.setTitle(rowsModel.groupName ?? "", for: .normal)
                self.groupnumber = rowsModel.eid ?? ""
            }else {
                self.groupnumber = groupId
                cell.menuBtn.setTitle(name, for: .normal)
            }
        }
        cell.menuBlock = { [weak self] menuBtn in
            guard let self = self else { return }
            self.popGroupView(from: menuBtn)
        }
        //添加监控企业
        cell.addBlock = { [weak self] addBtn in
            guard let self = self else { return }
            self.addMonitoringCompanyInfo(from: model)
        }
        cell.model = model
        return cell
    }
    
    private func popGroupView(from menuBtn: UIButton) {
        let alertVc = TYAlertController(alert: groupView, preferredStyle: .actionSheet)!
        groupView.groupArray = self.groupArray ?? []
        groupView.cancelBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
        groupView.block = { [weak self] model in
            self?.dismiss(animated: true, completion: {
                self?.groupnumber = model.eid ?? ""
                self?.groupName = model.groupName ?? ""
                menuBtn.setTitle(model.groupName ?? "", for: .normal)
                menuBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
            })
        }
        self.present(alertVc, animated: true)
    }
    
    //添加监控企业
    private func addMonitoringCompanyInfo(from model: rowsModel) {
        //        let persons = (model.riskMonitorPersonDtoList?.filter { !$0.isClickMonitoring }.compactMap { $0.name } ?? []) +
        //        (model.positions?.filter { !$0.isClickMonitoring }.compactMap { $0.name } ?? [])
        let entityid = model.orgId ?? ""
        let firmname = model.orgName ?? ""
        let groupnumber = self.groupnumber ?? ""
        let dict = ["orgId": entityid,
                    "groupId": groupnumber,
                    "firmname": firmname] as [String : Any]
        let man = RequestManager()
        ViewHud.addLoadView()
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitor-org/addRiskMonitorOrg",
                       method: .post) { [weak self] result in
            ViewHud.hideLoadView()
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if success.code == 200 {
                    model.monitorFlag = "1"
                    model.groupName = self.groupName ?? ""
                    self.tableView.reloadData()
                    ToastViewConfig.showToast(message: "监控成功")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}

