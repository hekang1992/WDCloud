//
//  MyOneSettingViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/20.
//

import UIKit

class MyOneSettingViewController: WDBaseViewController {
    
    var modelArray: [propertyTypeSettingModel]?
    
    //记录被点击的cell
    var selectOneIndex: Int = 0
    var selectTwoIndex: Int = 0
    var selectThreeIndex: Int = 0
    
    lazy var tableView1: UITableView = {
        let tableView1 = UITableView(frame: .zero, style: .plain)
        tableView1.separatorStyle = .none
        tableView1.backgroundColor = .clear
        tableView1.register(MyPropertySettingCell.self,
                            forCellReuseIdentifier: "MyPropertySettingCell")
        tableView1.estimatedRowHeight = 80
        tableView1.showsVerticalScrollIndicator = false
        tableView1.contentInsetAdjustmentBehavior = .never
        tableView1.rowHeight = UITableView.automaticDimension
        tableView1.delegate = self
        tableView1.dataSource = self
        if #available(iOS 15.0, *) {
            tableView1.sectionHeaderTopPadding = 0
        }
        return tableView1
    }()
    
    lazy var tableView2: UITableView = {
        let tableView2 = UITableView(frame: .zero, style: .plain)
        tableView2.separatorStyle = .none
        tableView2.backgroundColor = .clear
        tableView2.register(MyPropertySettingCell.self,
                            forCellReuseIdentifier: "MyPropertySettingCell")
        tableView2.estimatedRowHeight = 80
        tableView2.showsVerticalScrollIndicator = false
        tableView2.contentInsetAdjustmentBehavior = .never
        tableView2.rowHeight = UITableView.automaticDimension
        tableView2.delegate = self
        tableView2.dataSource = self
        if #available(iOS 15.0, *) {
            tableView2.sectionHeaderTopPadding = 0
        }
        return tableView2
    }()
    
    lazy var tableView3: UITableView = {
        let tableView3 = UITableView(frame: .zero, style: .plain)
        tableView3.separatorStyle = .none
        tableView3.backgroundColor = .clear
        tableView3.register(MyPropertySettingCell.self,
                            forCellReuseIdentifier: "MyPropertySettingCell")
        tableView3.estimatedRowHeight = 80
        tableView3.showsVerticalScrollIndicator = false
        tableView3.contentInsetAdjustmentBehavior = .never
        tableView3.rowHeight = UITableView.automaticDimension
        tableView3.delegate = self
        tableView3.dataSource = self
        if #available(iOS 15.0, *) {
            tableView3.sectionHeaderTopPadding = 0
        }
        return tableView3
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView1)
        view.addSubview(tableView2)
        view.addSubview(tableView3)
        
        tableView1.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-120)
            make.width.equalToSuperview().dividedBy(3)
        }
        
        tableView2.snp.makeConstraints { make in
            make.top.equalTo(tableView1.snp.top)
            make.leading.equalTo(tableView1.snp.trailing)
            make.bottom.equalToSuperview().offset(-120)
            make.width.equalToSuperview().dividedBy(3)
        }
        
        tableView3.snp.makeConstraints { make in
            make.top.equalTo(tableView1.snp.top)
            make.leading.equalTo(tableView2.snp.trailing)
            make.bottom.equalToSuperview().offset(-120)
            make.width.equalToSuperview().dividedBy(3)
        }
        
        //获取用户监控设置
        getUserSettingInfo()
    }
    
}

extension MyOneSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1 {
            return self.modelArray?.count ?? 0
        } else if tableView == tableView2 {
            let count = self.modelArray?[selectOneIndex].items?.count ?? 0
            return count
        }else {
            let count = self.modelArray?[selectOneIndex].items?[selectTwoIndex].items?.count ?? 0
            return count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableView1 {
            let model = self.modelArray?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPropertySettingCell", for: indexPath) as! MyPropertySettingCell
            cell.mlabel.text = model?.name ?? ""
            return cell
        } else if tableView == tableView2 {
            let model = self.modelArray?[selectOneIndex].items?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPropertySettingCell", for: indexPath) as! MyPropertySettingCell
            cell.mlabel.text = model?.name ?? ""
            return cell
        }else {
            let model = self.modelArray?[selectOneIndex].items?[selectTwoIndex].items?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPropertySettingCell", for: indexPath) as! MyPropertySettingCell
            cell.mlabel.text = model?.name ?? ""
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableView1 {
            selectOneIndex = indexPath.row
            tableView2.reloadData()
            tableView3.reloadData()
            self.tableView2.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
        } else if tableView == tableView2 {
            selectTwoIndex = indexPath.row
            tableView3.reloadData()
        } else {
            selectThreeIndex = indexPath.row
        }
    }
    
}

extension MyOneSettingViewController {
    
    private func getUserSettingInfo() {
        ViewHud.addLoadView()
        let man = RequestManager()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/monitor_settings/configs",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if success.code == 200 {
                    self.modelArray = success.data?.propertyTypeSetting ?? []
                    self.tableView1.reloadData()
                    tableView(self.tableView1, didSelectRowAt: IndexPath(row: 0, section: 0))
                    tableView(self.tableView2, didSelectRowAt: IndexPath(row: 0, section: 0))
                    self.tableView1.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
                    self.tableView2.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
