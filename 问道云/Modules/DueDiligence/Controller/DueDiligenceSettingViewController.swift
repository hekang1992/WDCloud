//
//  DueDiligenceSettingViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/18.
//

import UIKit
import TYAlertController

class DueDiligenceSettingViewController: WDBaseViewController {
    
    var groupArray: [itemsModel]?
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "尽调设置"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        return headView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "centericon")
        return ctImageView
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.textAlignment = .left
        phoneLabel.textColor = .init(cssStr: "#333333")
        phoneLabel.font = .mediumFontOfSize(size: 14)
        let phone = GetSaveLoginInfoConfig.getPhoneNumber()
        phoneLabel.text = PhoneNumberFormatter.formatPhoneNumber(phoneNumber: phone)
        return phoneLabel
    }()
    
    lazy var vipImageView: UIImageView = {
        let vipImageView = UIImageView()
        return vipImageView
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textAlignment = .left
        timeLabel.textColor = .init(cssStr: "#9FA4AD")
        timeLabel.font = .mediumFontOfSize(size: 12)
        return timeLabel
    }()
    
    lazy var vipBtn: UIButton = {
        let vipBtn = UIButton(type: .custom)
        vipBtn.setTitle("续费会员", for: .normal)
        vipBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        vipBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
        return vipBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var addImageView: UIImageView = {
        let addImageView = UIImageView()
        addImageView.image = UIImage(named: "Addimagerisk")
        return addImageView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.text = "新建分组"
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .mediumFontOfSize(size: 14)
        namelabel.isUserInteractionEnabled = true
        return namelabel
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
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
    
    //重命名
    lazy var cmmView: CMMView = {
        let cmmView = CMMView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 200))
        return cmmView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        addHeadView(from: headView)
        
        view.addSubview(ctImageView)
        view.addSubview(phoneLabel)
        view.addSubview(vipImageView)
        view.addSubview(timeLabel)
        view.addSubview(vipBtn)
        view.addSubview(lineView)
        view.addSubview(addImageView)
        view.addSubview(namelabel)
        view.addSubview(tableView)
        ctImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.equalTo(headView.snp.bottom).offset(12)
            make.size.equalTo(CGSize(width: 51, height: 51))
        }
        phoneLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.left.equalTo(ctImageView.snp.right).offset(14)
            make.top.equalTo(ctImageView.snp.top).offset(4)
        }
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(phoneLabel.snp.left)
            make.top.equalTo(phoneLabel.snp.bottom).offset(9)
            make.height.equalTo(16.5)
        }
        vipImageView.snp.makeConstraints { make in
            make.left.equalTo(phoneLabel.snp.right).offset(10)
            make.height.equalTo(13)
            make.centerY.equalTo(phoneLabel.snp.centerY)
        }
        vipBtn.snp.makeConstraints { make in
            make.width.equalTo(52)
            make.height.equalTo(16.5)
            make.centerY.equalTo(phoneLabel.snp.centerY)
            make.right.equalToSuperview().offset(-17.5)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(5)
            make.top.equalTo(ctImageView.snp.bottom).offset(12)
        }
        
        addImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.equalTo(lineView.snp.bottom).offset(11)
            make.size.equalTo(CGSize(width: 34, height: 34))
        }
        
        namelabel.snp.makeConstraints { make in
            make.centerY.equalTo(addImageView.snp.centerY)
            make.left.equalTo(ctImageView.snp.right).offset(9)
            make.height.equalTo(20)
            make.right.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(addImageView.snp.bottom).offset(13.5)
        }
        
        vipBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let memVc = MembershipCenterViewController()
            self.navigationController?.pushViewController(memVc, animated: true)
        }).disposed(by: disposeBag)
        
        namelabel.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            self?.AddMonitoringInfo()
        }).disposed(by: disposeBag)
        
        getVipInfo()
        getMonitoringGroupInfo()
    }
}

extension DueDiligenceSettingViewController {
    
    //查询监控分组
    func getMonitoringGroupInfo() {
        let man = RequestManager()
        
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber]
        man.requestAPI(params: dict,
                       pageUrl: "/dd/ddGroup/list",
                       method: .get) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    let items = model.items ?? []
                    self.groupArray = items
                    if items.isEmpty {
                        self.addNodataView(from: tableView)
                    }else {
                        self.emptyView.removeFromSuperview()
                    }
                    self.tableView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    private func getVipInfo() {
        
        let man = RequestManager()
        
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/enterpriseclientbm/buymoreinfo",
                       method: .get) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    timeLabel.text = "有效期至\(model.endtime ?? "")"
                    let userIdentity = model.userIdentity ?? ""
                    if userIdentity == "2" {//vip
                        vipImageView.image = UIImage(named: "levelvipimage")
                    } else if userIdentity == "3" {//svip
                        vipImageView.image = UIImage(named: "leveLsvipimage")
                    } else {//normal
                        vipImageView.image = UIImage(named: "levelnormal")
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func AddMonitoringInfo() {
        let alertVc = TYAlertController(alert: self.cmmView, preferredStyle: .alert)!
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
    
    func addNewInfo() {
        
        let man = RequestManager()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["groupname": self.cmmView.tf.text ?? "",
                    "customernumber": customernumber]
        man.requestAPI(params: dict,
                       pageUrl: "/dd/ddGroup/add",
                       method: .post) { [weak self] result in
            
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

extension DueDiligenceSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let count = self.groupArray?.count ?? 0
        let headView = UIView()
        let numLabel = UILabel()
        headView.backgroundColor = .init(cssStr: "#F8F9FB")
        numLabel.textColor = .init(cssStr: "#666666")
        numLabel.text = "已建分组(\(count))"
        numLabel.textAlignment = .left
        numLabel.font = .regularFontOfSize(size: 12)
        headView.addSubview(numLabel)
        numLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12.5)
        }
        return headView
    }
    
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
        if let model = self.groupArray?[indexPath.row] {
            deleteInfo(form: model)
        }
    }
    
    func deleteInfo(form model: itemsModel) {
        let groupnumber = model.groupnumber ?? ""
        ShowAlertManager.showAlert(title: "删除提醒", message: "删除该监控方案后，采用该监控方案的对象将使用默认监控方案监控", confirmAction:  {
            
            let man = RequestManager()
            let dict = ["groupnumber": groupnumber]
            man.requestAPI(params: dict,
                           pageUrl: "/dd/ddGroup/delete",
                           method: .post) { [weak self] result in
                
                switch result {
                case .success(let success):
                    if let self = self, let code = success.code, code == 200 {
                        self.dismiss(animated: true) {
                            self.getMonitoringGroupInfo()
                        }
                        ToastViewConfig.showToast(message: "删除成功")
                    }
                    break
                case .failure(_):
                    break
                }
            }
        })
    }
    
}
