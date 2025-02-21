//
//  MyTwoSettingViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/20.
//

import UIKit
import SevenSwitch
import RxRelay

class MyTwoSettingViewController: WDBaseViewController {
    
    var modelArray: [propertyTypeSettingModel]?
    var modelpArray: [propertyTypeSettingModel]?
    
    var selectArray = BehaviorRelay<[propertyTypeSettingModel]?>(value: nil)
    var selectpArray = BehaviorRelay<[propertyTypeSettingModel]?>(value: nil)
    
    //记录被点击的cell
    var selectOneIndex: Int = 0
    var selectTwoIndex: Int = 0
    var selectThreeIndex: Int = 0
    
    var selectFourIndex: Int = 0
    var selectFiveIndex: Int = 0
    var selectSixIndex: Int = 0
    
    lazy var onelabel: UILabel = {
        let onelabel = UILabel()
        onelabel.text = "定制企业关联方"
        onelabel.textColor = UIColor.init(cssStr: "#333333")
        onelabel.textAlignment = .left
        onelabel.font = .mediumFontOfSize(size: 15)
        return onelabel
    }()
    
    lazy var twolabel: UILabel = {
        let twolabel = UILabel()
        twolabel.text = "定制人员关联方"
        twolabel.textColor = UIColor.init(cssStr: "#333333")
        twolabel.textAlignment = .left
        twolabel.font = .mediumFontOfSize(size: 15)
        return twolabel
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
    
    lazy var tableView4: UITableView = {
        let tableView4 = UITableView(frame: .zero, style: .plain)
        tableView4.separatorStyle = .none
        tableView4.backgroundColor = .clear
        tableView4.register(MyPropertySettingCell.self,
                            forCellReuseIdentifier: "MyPropertySettingCell")
        tableView4.estimatedRowHeight = 80
        tableView4.showsVerticalScrollIndicator = false
        tableView4.contentInsetAdjustmentBehavior = .never
        tableView4.rowHeight = UITableView.automaticDimension
        tableView4.delegate = self
        tableView4.dataSource = self
        if #available(iOS 15.0, *) {
            tableView4.sectionHeaderTopPadding = 0
        }
        return tableView4
    }()
    
    lazy var tableView5: UITableView = {
        let tableView5 = UITableView(frame: .zero, style: .plain)
        tableView5.separatorStyle = .none
        tableView5.backgroundColor = .clear
        tableView5.register(MyPropertySettingCell.self,
                            forCellReuseIdentifier: "MyPropertySettingCell")
        tableView5.estimatedRowHeight = 80
        tableView5.showsVerticalScrollIndicator = false
        tableView5.contentInsetAdjustmentBehavior = .never
        tableView5.rowHeight = UITableView.automaticDimension
        tableView5.delegate = self
        tableView5.dataSource = self
        if #available(iOS 15.0, *) {
            tableView5.sectionHeaderTopPadding = 0
        }
        return tableView5
    }()
    
    lazy var tableView6: UITableView = {
        let tableView6 = UITableView(frame: .zero, style: .plain)
        tableView6.separatorStyle = .none
        tableView6.backgroundColor = .clear
        tableView6.register(MyPropertySettingCell.self,
                            forCellReuseIdentifier: "MyPropertySettingCell")
        tableView6.estimatedRowHeight = 80
        tableView6.showsVerticalScrollIndicator = false
        tableView6.contentInsetAdjustmentBehavior = .never
        tableView6.rowHeight = UITableView.automaticDimension
        tableView6.delegate = self
        tableView6.dataSource = self
        if #available(iOS 15.0, *) {
            tableView6.sectionHeaderTopPadding = 0
        }
        return tableView6
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(onelabel)
        view.addSubview(twolabel)
        view.addSubview(tableView1)
        view.addSubview(tableView2)
        view.addSubview(tableView3)
        view.addSubview(tableView4)
        view.addSubview(tableView5)
        view.addSubview(tableView6)
        view.addSubview(oneBtn)
        view.addSubview(twoBtn)
        onelabel.snp.makeConstraints { make in
            make.height.equalTo(21)
            make.top.equalToSuperview().offset(9)
            make.left.equalToSuperview().offset(15)
        }
        
        tableView1.snp.makeConstraints { make in
            make.top.equalTo(onelabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalToSuperview().dividedBy(3)
        }
        
        tableView2.snp.makeConstraints { make in
            make.top.equalTo(tableView1.snp.top)
            make.leading.equalTo(tableView1.snp.trailing)
            make.height.equalTo(200)
            make.width.equalToSuperview().dividedBy(3)
        }
        
        tableView3.snp.makeConstraints { make in
            make.top.equalTo(tableView1.snp.top)
            make.leading.equalTo(tableView2.snp.trailing)
            make.height.equalTo(200)
            make.width.equalToSuperview().dividedBy(3)
        }
        
        twolabel.snp.makeConstraints { make in
            make.top.equalTo(tableView1.snp.bottom).offset(10)
            make.height.equalTo(21)
            make.left.equalToSuperview().offset(15)
        }
        tableView4.snp.makeConstraints { make in
            make.top.equalTo(twolabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalToSuperview().dividedBy(3)
        }
        
        tableView5.snp.makeConstraints { make in
            make.top.equalTo(tableView4.snp.top)
            make.leading.equalTo(tableView4.snp.trailing)
            make.height.equalTo(200)
            make.width.equalToSuperview().dividedBy(3)
        }
        
        tableView6.snp.makeConstraints { make in
            make.top.equalTo(tableView4.snp.top)
            make.leading.equalTo(tableView5.snp.trailing)
            make.height.equalTo(200)
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
            
            if let modelArray = modelpArray {
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
            
            self.tableView4.reloadData()
            self.tableView5.reloadData()
            self.tableView6.reloadData()
        }).disposed(by: disposeBag)
        
        twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.selectArray.accept(modelArray)
            self.selectpArray.accept(modelpArray)
        }).disposed(by: disposeBag)
        
        //确定
        self.selectArray.asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self, let modelArray = modelArray else { return }
            let add = modelArray
            print("=============")
        }).disposed(by: disposeBag)
        
        self.selectpArray.asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self, let modelArray = modelArray else { return }
            let add = modelArray
            print("=============")
        }).disposed(by: disposeBag)
        
        //获取用户监控设置
        getUserSettingInfo()
    }

}

extension MyTwoSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        }else if tableView == tableView3 {
            let count = self.modelArray?[selectOneIndex].items?[selectTwoIndex].items?.count ?? 0
            return count
        }else if tableView == tableView4 {
            return self.modelpArray?.count ?? 0
        }else if tableView == tableView5 {
            let count = self.modelpArray?[selectFourIndex].items?.count ?? 0
            return count
        }else {
            if let modelpArray = self.modelpArray?[selectFourIndex].items, modelpArray.count > 0 {
                let count = modelpArray[selectFiveIndex].items?.count ?? 0
                return count
            }else {
                return 0
            }
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
        }else if tableView == tableView3 {
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
        } else if tableView == tableView4 {
            let model = self.modelpArray?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyPropertySettingCell", for: indexPath) as! MyPropertySettingCell
            cell.mlabel.text = model?.name ?? ""
            cell.backgroundColor = .init(cssStr: "#EEEEEE")
            cell.model1.accept(model)
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
                self.tableView(self.tableView4, didSelectRowAt: indexPath)
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
                self.tableView4.reloadData()
                self.tableView5.reloadData()
                self.tableView6.reloadData()
            }
            return cell
        } else if tableView == tableView5 {
            let model = self.modelpArray?[selectFourIndex].items?[indexPath.row]
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
                self.tableView(self.tableView4, didSelectRowAt: indexPath)
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
                self.tableView4.reloadData()
                self.tableView5.reloadData()
                self.tableView6.reloadData()
            }
            return cell
        } else {
            let model = self.modelpArray?[selectFourIndex].items?[selectFiveIndex].items?[indexPath.row]
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
                self.tableView4.reloadData()
                self.tableView5.reloadData()
                self.tableView6.reloadData()
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
        } else if tableView == tableView3 {
            selectThreeIndex = indexPath.row
        } else if tableView == tableView4 {
            selectFourIndex = indexPath.row
            tableView5.reloadData()
            tableView6.reloadData()
            self.tableView5.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
        } else if tableView == tableView5 {
            selectFiveIndex = indexPath.row
            tableView6.reloadData()
        } else  {
            selectSixIndex = indexPath.row
        }
    }
    
}

extension MyTwoSettingViewController {
    
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
                    self.modelArray = success.data?.propertyEntityRelatedSetting ?? []
                    self.tableView1.reloadData()
                    tableView(self.tableView1, didSelectRowAt: IndexPath(row: 0, section: 0))
                    tableView(self.tableView2, didSelectRowAt: IndexPath(row: 0, section: 0))
                    self.tableView1.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
                    self.tableView2.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
                    
                    self.modelpArray = success.data?.propertyPersonRelatedSetting ?? []
                    self.tableView4.reloadData()
                    tableView(self.tableView4, didSelectRowAt: IndexPath(row: 0, section: 0))
                    tableView(self.tableView5, didSelectRowAt: IndexPath(row: 0, section: 0))
                    self.tableView4.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
                    self.tableView5.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
                    
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
