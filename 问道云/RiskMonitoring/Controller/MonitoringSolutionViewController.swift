//
//  MonitoringSolutionViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/20.
//

import UIKit
import RxRelay
import SwiftyJSON

class MonitoringSolutionViewController: WDBaseViewController {
    
    var modelArray: [propertyTypeSettingModel]?
    
    var selectArray = BehaviorRelay<[propertyTypeSettingModel]?>(value: nil)
    
    //记录被点击的cell
    var selectOneIndex: Int = 0
    var selectTwoIndex: Int = 0
    
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
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "监控方案"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        return headView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addHeadView(from: headView)
        view.addSubview(tableView1)
        view.addSubview(tableView2)
        view.addSubview(oneBtn)
        view.addSubview(twoBtn)
        tableView1.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().offset(-120)
            make.width.equalToSuperview().dividedBy(2)
        }
        tableView2.snp.makeConstraints { make in
            make.top.equalTo(tableView1.snp.top)
            make.leading.equalTo(tableView1.snp.trailing)
            make.bottom.equalToSuperview().offset(-120)
            make.width.equalToSuperview().dividedBy(2)
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
        }).disposed(by: disposeBag)
        
        twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.selectArray.accept(modelArray)
        }).disposed(by: disposeBag)
        //确定
        self.selectArray.asObservable().subscribe(onNext: { [weak self] modelArray in
            var listArray: [String] = []
            guard let self = self, let modelArray = modelArray else { return }
            for model in modelArray {
                for model in model.items ?? [] {
                    let select = model.select ?? ""
                    listArray.append(select)
                }
            }
            updateInfo(from: listArray)
        }).disposed(by: disposeBag)
        
        //获取用户监控设置
        getUserSettingInfo()
    }
    
    //更新监控方案
    private func updateInfo(from listArray: [String]) {
        let liststr = listArray.joined()
        let man = RequestManager()
        let dict = ["pushOffset": liststr]
        ViewHud.addLoadView()
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitor-config/updateRiskMonitorConfig",
                       method: .post) { result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    ToastViewConfig.showToast(message: "更新监控方案成功")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}

extension MonitoringSolutionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1 {
            return self.modelArray?.count ?? 0
        } else {
            let count = self.modelArray?[selectOneIndex].items?.count ?? 0
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
            }
            return cell
        } else {
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
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableView1 {
            selectOneIndex = indexPath.row
            tableView2.reloadData()
            self.tableView2.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
        } else if tableView == tableView2 {
            selectTwoIndex = indexPath.row
        } else {
            
        }
    }
    
}

extension MonitoringSolutionViewController {
    
    private func getUserSettingInfo() {
        let dict = [String: Any]()
        let man = RequestManager()
        ViewHud.addLoadView()
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitor-config/getRiskMonitorConfig",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    guard let self = self, let model = success.data else { return }
                    let pushOffset = model.pushOffset ?? ""
                    let numberArray = pushOffset.compactMap { String($0) }
                    let itemJson1: JSON = [["name": "高风险", "select": numberArray[0]],
                                           ["name": "低风险", "select": numberArray[1]],
                                           ["name": "提示", "select": numberArray[2]]]
                    var select1 = "0"
                    if numberArray[0] == "0" ||
                        numberArray[1] == "0" ||
                        numberArray[2] == "0"{
                        select1 = "0"
                    }else {
                        select1 = "1"
                    }
                    let json1: JSON = ["name": "经营风险",
                                       "select": select1,
                                       "items": itemJson1]
                    let propertyTypeSettingModel1 = propertyTypeSettingModel(json: json1)
                    
                    var select2 = "0"
                    if numberArray[3] == "0" ||
                        numberArray[4] == "0" ||
                        numberArray[5] == "0"{
                        select2 = "0"
                    }else {
                        select2 = "1"
                    }
                    let itemJson2: JSON = [["name": "高风险", "select": numberArray[3]],
                                           ["name": "低风险", "select": numberArray[4]],
                                           ["name": "提示", "select": numberArray[5]]]
                    let json2: JSON = ["name": "法律风险",
                                       "select": select2,
                                       "items": itemJson2]
                    let propertyTypeSettingModel2 = propertyTypeSettingModel(json: json2)
                    
                    var select3 = "0"
                    if numberArray[6] == "0" ||
                        numberArray[7] == "0" ||
                        numberArray[8] == "0"{
                        select3 = "0"
                    }else {
                        select3 = "1"
                    }
                    let itemJson3: JSON = [["name": "高风险", "select": numberArray[6]],
                                           ["name": "低风险", "select": numberArray[7]],
                                           ["name": "提示", "select": numberArray[8]]]
                    let json3: JSON = ["name": "财务风险",
                                       "select": select3,
                                       "items": itemJson3]
                    let propertyTypeSettingModel3 = propertyTypeSettingModel(json: json3)
                    
                    var select4 = "0"
                    if numberArray[9] == "0" ||
                        numberArray[10] == "0" ||
                        numberArray[11] == "0"{
                        select4 = "0"
                    }else {
                        select4 = "1"
                    }
                    let itemJson4: JSON = [["name": "高风险", "select": numberArray[9]],
                                           ["name": "低风险", "select": numberArray[10]],
                                           ["name": "提示", "select": numberArray[11]]]
                    let json4: JSON = ["name": "舆情风险",
                                       "select": select4,
                                       "items": itemJson4]
                    let propertyTypeSettingModel4 = propertyTypeSettingModel(json: json4)
                    
                    self.modelArray = [propertyTypeSettingModel1,
                                       propertyTypeSettingModel2,
                                       propertyTypeSettingModel3,
                                       propertyTypeSettingModel4]
                    self.tableView1.reloadData()
                    self.tableView2.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
