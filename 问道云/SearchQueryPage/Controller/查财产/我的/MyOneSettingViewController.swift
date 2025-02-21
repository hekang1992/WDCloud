//
//  MyOneSettingViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/20.
//

import UIKit
import SevenSwitch
import RxRelay

class MyOneSettingViewController: WDBaseViewController {
    
    var modelArray: [propertyTypeSettingModel]?
    
    var selectArray = BehaviorRelay<[propertyTypeSettingModel]?>(value: nil)
    
    //记录被点击的cell
    var selectOneIndex: Int = 0
    var selectTwoIndex: Int = 0
    var selectThreeIndex: Int = 0
    
    lazy var onelabel: UILabel = {
        let onelabel = UILabel()
        onelabel.text = "财产线索消息"
        onelabel.textColor = UIColor.init(cssStr: "#333333")
        onelabel.textAlignment = .left
        onelabel.font = .mediumFontOfSize(size: 15)
        return onelabel
    }()
    
    lazy var twolabel: UILabel = {
        let twolabel = UILabel()
        twolabel.text = "实时推送财产线索变化，避免错过重要信息"
        twolabel.textColor = UIColor.init(cssStr: "#333333")
        twolabel.textAlignment = .left
        twolabel.font = .regularFontOfSize(size: 12)
        return twolabel
    }()
    
    lazy var oneSwitch: SevenSwitch = {
        let oneSwitch = SevenSwitch()
        oneSwitch.on = true
        oneSwitch.onTintColor = .init(cssStr: "#547AFF")!
        return oneSwitch
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setTitle("重置", for: .normal)
        oneBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
        oneBtn.titleLabel?.font = .mediumFontOfSize(size: 15)
        oneBtn.layer.cornerRadius = 4
        oneBtn.backgroundColor = .init(cssStr: "#547AFF")?.withAlphaComponent(0.1)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setTitle("确定", for: .normal)
        twoBtn.setTitleColor(UIColor.init(cssStr: "#FFFFFF"), for: .normal)
        twoBtn.titleLabel?.font = .mediumFontOfSize(size: 15)
        twoBtn.layer.cornerRadius = 4
        twoBtn.backgroundColor = .init(cssStr: "#547AFF")
        return twoBtn
    }()
    
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
        view.backgroundColor = .white
        view.addSubview(onelabel)
        view.addSubview(twolabel)
        view.addSubview(oneSwitch)
        view.addSubview(tableView1)
        view.addSubview(tableView2)
        view.addSubview(tableView3)
        view.addSubview(oneBtn)
        view.addSubview(twoBtn)
        onelabel.snp.makeConstraints { make in
            make.height.equalTo(21)
            make.top.equalToSuperview().offset(9)
            make.left.equalToSuperview().offset(15)
        }
        
        twolabel.snp.makeConstraints { make in
            make.height.equalTo(21)
            make.top.equalTo(onelabel.snp.bottom).offset(2)
            make.left.equalToSuperview().offset(16.5)
        }
        
        oneSwitch.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(SCREEN_WIDTH - 60)
            make.size.equalTo(CGSize(width: 40, height: 20))
        }
        
        tableView1.snp.makeConstraints { make in
            make.top.equalTo(twolabel.snp.bottom).offset(8)
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
        oneBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 173, height: 48.pix()))
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-25)
        }
        twoBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 173, height: 48.pix()))
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-25)
        }
        oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if let modelArray = modelArray {
                for model in modelArray {
                    model.select = "0"
                    if let modelArray = model.items {
                        for model in modelArray {
                            model.select = "0"
                            if let modelArray = model.items {
                                for model in modelArray {
                                    model.select = "0"
                                }
                            }
                        }
                    }
                }
            }
            self.tableView1.reloadData()
            self.tableView2.reloadData()
            self.tableView3.reloadData()
        }).disposed(by: disposeBag)
        
        twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.selectArray.accept(modelArray)
        }).disposed(by: disposeBag)
        
        //确定
        self.selectArray.asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self, let modelArray = modelArray else { return }
            let add = modelArray
            print("=============")
        }).disposed(by: disposeBag)
        
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
            cell.backgroundColor = .init(cssStr: "#EEEEEE")
            cell.model.accept(model)
            var titles: [String] = []
            if let items = model?.items {
                titles.removeAll()
                for model in items {
                    titles.append(model.select ?? "")
                }
                let containsZero = titles.contains("0")
                let containsOne = titles.contains("1")
                if containsZero && containsOne {
                    model?.select = "0"
                    cell.checkBtn.setImage(UIImage(named: "bottiamgeadd"), for: .normal)
                } else if containsZero {
                    print("只包含 0")
                    model?.select = "0"
                    cell.checkBtn.setImage(UIImage(named: "agreenorimage"), for: .normal)
                } else if containsOne {
                    print("只包含 1")
                    model?.select = "1"
                    cell.checkBtn.setImage(UIImage(named: "agreeselimage"), for: .normal)
                } else {
                    print("既不包含 0 也不包含 1")
                }
            }
            cell.block = { [weak self] btn in
                guard let self = self, let model = model else { return }
                self.tableView(self.tableView1, didSelectRowAt: indexPath)
                if model.select == "0" {
                    model.select = "1"
                    btn.setImage(UIImage(named: "agreeselimage"), for: .normal)
                    if let items = model.items {
                        for model in items {
                            model.select = "1"
                            if let items = model.items {
                                for model in items {
                                    model.select = "1"
                                }
                            }
                        }
                    }
                }else {
                    model.select = "0"
                    btn.setImage(UIImage(named: "agreenorimage"), for: .normal)
                    if let items = model.items {
                        for model in items {
                            model.select = "0"
                            if let items = model.items {
                                for model in items {
                                    model.select = "0"
                                }
                            }
                        }
                    }
                }
                self.tableView1.reloadData()
                self.tableView2.reloadData()
                self.tableView3.reloadData()
            }
            return cell
        } else if tableView == tableView2 {
            let model = self.modelArray?[selectOneIndex].items?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPropertySettingCell", for: indexPath) as! MyPropertySettingCell
            cell.mlabel.text = model?.name ?? ""
            cell.backgroundColor = .init(cssStr: "#EEEEEE")
            let select = model?.select ?? ""
            if select == "1" {
                cell.checkBtn.setImage(UIImage(named: "agreeselimage"), for: .normal)
            }else {
                cell.checkBtn.setImage(UIImage(named: "agreenorimage"), for: .normal)
            }
            var titles: [String] = []
            if let items = model?.items {
                titles.removeAll()
                for model in items {
                    titles.append(model.select ?? "")
                }
                let containsZero = titles.contains("0")
                let containsOne = titles.contains("1")
                if containsZero && containsOne {
                    model?.select = "0"
                    cell.checkBtn.setImage(UIImage(named: "bottiamgeadd"), for: .normal)
                } else if containsZero {
                    print("只包含 0")
                    model?.select = "0"
                    cell.checkBtn.setImage(UIImage(named: "agreenorimage"), for: .normal)
                } else if containsOne {
                    print("只包含 1")
                    model?.select = "1"
                    cell.checkBtn.setImage(UIImage(named: "agreeselimage"), for: .normal)
                } else {
                    
                }
            }
            cell.block = { [weak self] btn in
                guard let self = self, let model = model else { return }
                self.tableView(self.tableView2, didSelectRowAt: indexPath)
                if model.select == "0" {
                    model.select = "1"
                    btn.setImage(UIImage(named: "agreeselimage"), for: .normal)
                    if let items = model.items {
                        for model in items {
                            model.select = "1"
                        }
                    }
                }else {
                    model.select = "0"
                    btn.setImage(UIImage(named: "agreenorimage"), for: .normal)
                    if let items = model.items {
                        for model in items {
                            model.select = "0"
                        }
                    }
                }
                self.tableView1.reloadData()
                self.tableView2.reloadData()
                self.tableView3.reloadData()
            }
            return cell
        }else {
            let model = self.modelArray?[selectOneIndex].items?[selectTwoIndex].items?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPropertySettingCell", for: indexPath) as! MyPropertySettingCell
            cell.mlabel.text = model?.name ?? ""
            cell.backgroundColor = .init(cssStr: "#EEEEEE")
            let select = model?.select ?? ""
            if select == "1" {
                cell.checkBtn.setImage(UIImage(named: "agreeselimage"), for: .normal)
            } else {
                cell.checkBtn.setImage(UIImage(named: "agreenorimage"), for: .normal)
            }
            cell.block = { [weak self] btn in
                guard let self = self, let model = model else { return }
                if select == "1" {
                    model.select = "0"
                    btn.setImage(UIImage(named: "agreenorimage"), for: .normal)
                }else {
                    model.select = "1"
                    btn.setImage(UIImage(named: "agreeselimage"), for: .normal)
                }
                self.tableView1.reloadData()
                self.tableView2.reloadData()
                self.tableView3.reloadData()
            }
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
