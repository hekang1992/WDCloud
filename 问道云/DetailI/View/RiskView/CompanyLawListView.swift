//
//  CompanyLawListView.swift
//  问道云
//
//  Created by Andrew on 2025/2/5.
//

import UIKit
import RxRelay

class CompanyLawListView: BaseView {
    
    var index: Int = 0
    
    var modelArray = BehaviorRelay<[itemsModel]?>(value: [])
    
    // 保存每个 section 是否展开的状态
    var expandedSections: [Bool] = [false, false]
    
    var block: ((itemsModel) -> Void)?
    
    var oneBlock: ((itemsModel, threelevelitemsModel) -> Void)?
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setTitle("生效判决", for: .normal)
        oneBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
        oneBtn.titleLabel?.font = .mediumFontOfSize(size: 15)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setTitle("在审案件", for: .normal)
        twoBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        twoBtn.titleLabel?.font = .mediumFontOfSize(size: 15)
        return twoBtn
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.font = .regularFontOfSize(size: 15)
        numLabel.textAlignment = .left
        numLabel.textColor = UIColor.init(cssStr: "#333333")
        return numLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#547AFF")
        return lineView
    }()
    
    lazy var rlineView: UIView = {
        let rlineView = UIView()
        rlineView.isHidden = true
        rlineView.backgroundColor = UIColor.init(cssStr: "#547AFF")
        return rlineView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(CompanyLawCell.self, forCellReuseIdentifier: "CompanyLawCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(numLabel)
        addSubview(oneBtn)
        addSubview(twoBtn)
        addSubview(lineView)
        addSubview(rlineView)
        addSubview(tableView)
        numLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(18)
        }
        oneBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(50)
            make.top.equalTo(numLabel.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width: 100, height: 18))
        }
        lineView.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.top.equalTo(oneBtn.snp.bottom).offset(3)
            make.height.equalTo(2)
            make.centerX.equalTo(oneBtn.snp.centerX)
        }
        twoBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-50)
            make.top.equalTo(numLabel.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width: 100, height: 18))
        }
        rlineView.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.top.equalTo(twoBtn.snp.bottom).offset(3)
            make.height.equalTo(2)
            make.centerX.equalTo(twoBtn.snp.centerX)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(4)
        }
        
        oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            oneBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
            twoBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
            lineView.isHidden = false
            rlineView.isHidden = true
            oneBtn.isEnabled = false
            twoBtn.isEnabled = true
            index = 0
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            oneBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
            twoBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
            lineView.isHidden = true
            rlineView.isHidden = false
            oneBtn.isEnabled = true
            twoBtn.isEnabled = false
            index = 1
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension CompanyLawListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = CompanyLawCellHeadView()
        if section == 0 || section == 1 {
            headView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                expandedSections[section].toggle()
                tableView.reloadSections([section], with: .automatic)
            }).disposed(by: disposeBag)
        }
        if section == 0 {
            let model = self.modelArray.value?[index]
            headView.highLabel.isHidden = true
            headView.lowLabel.isHidden = true
            headView.hitLabel.isHidden = true
            headView.namelabel.text = model?.subitems?.first?.subitemname ?? ""
        }else if section == 1 {
            let model = self.modelArray.value?[index]
            headView.highLabel.isHidden = true
            headView.lowLabel.isHidden = true
            headView.hitLabel.isHidden = true
            headView.namelabel.text = model?.subitems?.last?.subitemname ?? ""
        }else {
            let model = self.modelArray.value?[section]
            headView.highLabel.isHidden = false
            headView.lowLabel.isHidden = false
            headView.hitLabel.isHidden = false
            headView.namelabel.text = model?.itemname ?? ""
            headView.numlabel.text = "共\(model?.size ?? 0)条"
            headView.highLabel.text = "高风险(\(model?.highCount ?? 0))"
            headView.lowLabel.text = "低风险(\(model?.lowCount ?? 0))"
            headView.hitLabel.text = "提示(\(model?.hintCount ?? 0))"
            if model?.highCount == 0 {
                headView.highLabel.snp.makeConstraints({ make in
                    make.width.equalTo(0)
                    make.left.equalTo(headView.namelabel.snp.right)
                })
            }
            headView.lowLabel.text = "低风险(\(model?.lowCount ?? 0))"
            if model?.lowCount == 0 {
                headView.lowLabel.snp.makeConstraints({ make in
                    make.width.equalTo(0)
                    make.left.equalTo(headView.highLabel.snp.right)
                })
            }
            headView.hitLabel.text = "提示(\(model?.hintCount ?? 0))"
            if model?.hintCount == 0 {
                headView.hitLabel.snp.makeConstraints({ make in
                    make.width.equalTo(0)
                })
            }
            
            headView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if let model = model {
                    self.block?(model)
                }
            }).disposed(by: disposeBag)
            
        }
        return headView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let count = self.modelArray.value?.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            let model = self.modelArray.value?[section]
            return expandedSections[section] ? (model?.subitems?.first?.threelevelitems?.count ?? 0) : 0
        }else if section == 1 {
            let model = self.modelArray.value?[section]
            return expandedSections[section] ? (model?.subitems?.last?.threelevelitems?.count ?? 0) : 0
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let model = self.modelArray.value?[index]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyLawCell", for: indexPath) as! CompanyLawCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        if section == 0 {
            let model = model?.subitems?.first?.threelevelitems?[indexPath.row]
            let nameStr = model?.threelevelitemname ?? ""
            cell.nameLabel.attributedText = GetRedStrConfig.getRedStr(from: nameStr, fullText: "该公司 \(nameStr) 信息", colorStr: "#547AFF")
            cell.numlabel.text = "共\(model?.size ?? 0)条"
        }else if section == 1 {
            let model = model?.subitems?.last?.threelevelitems?[indexPath.row]
            let nameStr = model?.threelevelitemname ?? ""
            cell.nameLabel.attributedText = GetRedStrConfig.getRedStr(from: nameStr, fullText: "该公司 \(nameStr) 信息", colorStr: "#547AFF")
            cell.numlabel.text = "共\(model?.size ?? 0)条"
        }else {
            
        }
        return cell
    }
    
    //点击cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let model = self.modelArray.value?[index]
        if section == 0 {
            let onemodel = model?.subitems?.first?.threelevelitems?[indexPath.row]
            if let model = model, let onemodel = onemodel {
                self.oneBlock?(model, onemodel)
            }
        }else if section == 1 {
            let twoModel = model?.subitems?.last?.threelevelitems?[indexPath.row]
            if let model = model, let twoModel = twoModel {
                self.oneBlock?(model, twoModel)
            }
        }else {
//            let model = self.modelArray.value?[section]
//            if let model = model {
//                self.block?(model)
//            }
        }
    }
    
}
