//
//  CompanyLawListView.swift
//  问道云
//
//  Created by 何康 on 2025/2/5.
//

import UIKit
import RxRelay

class CompanyLawListView: BaseView {
    
    var modelArray = BehaviorRelay<[itemsModel]?>(value: [])
    var oneModelArray = BehaviorRelay<[itemsModel]?>(value: [])
    var twoModelArray = BehaviorRelay<[itemsModel]?>(value: [])
    
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
        tableView.register(RiskDetailViewCell.self, forCellReuseIdentifier: "RiskDetailViewCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
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
            modelArray.accept(self.oneModelArray.value)
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
            modelArray.accept(self.twoModelArray.value)
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension CompanyLawListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = .random()
        return headView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.modelArray.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RiskDetailViewCell", for: indexPath) as! RiskDetailViewCell
        cell.namelabel.text = "fadfad"
        return cell
    }
    
}
