//
//  RiskAddRiskGroupViewViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/14.
//

import UIKit
import TYAlertController

class RiskAddRiskGroupViewViewController: WDBaseViewController {
    
    var groupArray: [rowsModel]?
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "监控分组"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        return headView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()

    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "Addimagerisk")
        return ctImageView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.text = "新建分组"
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .mediumFontOfSize(size: 14)
        return namelabel
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    //重命名
    lazy var cmmView: CMMView = {
        let cmmView = CMMView(frame: self.view.bounds)
        return cmmView
    }()
    
    //
    lazy var groupView: RiskPopGroupView = {
        let groupView = RiskPopGroupView(frame: self.view.bounds)
        return groupView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        addHeadView(from: headView)
        view.addSubview(lineView)
        view.addSubview(whiteView)
        whiteView.addSubview(ctImageView)
        whiteView.addSubview(namelabel)
        view.addSubview(tableView)
        
        whiteView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom)
            make.height.equalTo(60)
        }
        
        ctImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 34, height: 34))
        }
        
        namelabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(ctImageView.snp.right).offset(9)
            make.height.equalTo(20)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(whiteView.snp.bottom)
            make.height.equalTo(5)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom)
        }
        //查询监控分组
        getMonitoringGroupInfo()
        //新增
        whiteView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.AddMonitoringInfo()
        }).disposed(by: disposeBag)
    }
}

extension RiskAddRiskGroupViewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.groupArray?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.textLabel?.text = model?.groupname ?? ""
        cell.textLabel?.font = .regularFontOfSize(size: 15)
        cell.textLabel?.textColor = .init(cssStr: "15")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.groupArray?[indexPath.row]
        let alertVc = TYAlertController(alert: self.groupView, preferredStyle: .actionSheet)!
        self.present(alertVc, animated: true)
        self.groupView.cancelBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        self.groupView.cmmBlock = { [weak self] in
            guard let self = self, let model = model else { return }
            self.dismiss(animated: true, completion: {
                self.cmmInfo(form: model)
            })
        }
        
        self.groupView.deleteBlock = { [weak self] in
            guard let self = self, let model = model else { return }
            self.dismiss(animated: true) {
                self.deleteInfo(form: model)
            }
        }
        
    }
}

extension RiskAddRiskGroupViewViewController {
    
    //查询监控分组
    func getMonitoringGroupInfo() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber]
        man.requestAPI(params: dict,
                       pageUrl: "/riskmonitor/monitorgroup/selectmonitorgroup",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if let model = success.data {
                    self?.groupArray = model.rows ?? []
                    self?.tableView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func AddMonitoringInfo() {
        let alertVc = TYAlertController(alert: self.cmmView, preferredStyle: .actionSheet)!
        self.cmmView.nameLabel.text = "添加分组"
        self.cmmView.tf.placeholder = "请输入分组名称"
        self.present(alertVc, animated: true)
        self.cmmView.cblock = { [weak self] in
            self?.dismiss(animated: true)
        }
        self.cmmView.sblock = { [weak self] in
            self?.addNewInfo()
        }
    }
    
    private func addNewInfo() {
        ViewHud.addLoadView()
        let man = RequestManager()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["groupname": self.cmmView.tf.text ?? "",
                    "customernumber": customernumber]
        man.requestAPI(params: dict, pageUrl: "/riskmonitor/monitorgroup/addmonitorgroup", method: .post) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(_):
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    self.getMonitoringGroupInfo()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func deleteInfo(form model: rowsModel) {
        let groupnumber = model.groupnumber ?? ""
        ShowAlertManager.showAlert(title: "删除提醒", message: "删除该监控方案后，采用该监控方案的对象将使用默认监控方案监控", confirmAction:  {
            let man = RequestManager()
            let dict = ["groupnumber": groupnumber]
            man.requestAPI(params: dict, pageUrl: "/riskmonitor/monitorgroup/delectmonitorgroup", method: .post) { [weak self] result in
                switch result {
                case .success(_):
                    if let self = self {
                        self.dismiss(animated: true) {
                            self.getMonitoringGroupInfo()
                        }
                    }
                    break
                case .failure(_):
                    break
                }
            }
        })
    }
    
    func cmmInfo(form model: rowsModel) {
        let alertVc = TYAlertController(alert: self.cmmView, preferredStyle: .actionSheet)!
        self.cmmView.nameLabel.text = "重命名"
        self.cmmView.tf.placeholder = "请输入分组名称"
        self.present(alertVc, animated: true)
        self.cmmView.cblock = { [weak self] in
            self?.dismiss(animated: true)
        }
        self.cmmView.sblock = { [weak self] in
            self?.cmmNewInfo(from: model)
        }
    }
    
    func cmmNewInfo(from model: rowsModel) {
        ViewHud.addLoadView()
        let man = RequestManager()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["groupname": self.cmmView.tf.text ?? "",
                    "groupnumber": model.groupnumber ?? ""]
        man.requestAPI(params: dict, pageUrl: "/riskmonitor/monitorgroup/updatemonitorgroup", method: .post) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(_):
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    self.getMonitoringGroupInfo()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
