//
//  TimeDownView.swift
//  问道云
//
//  Created by 何康 on 2024/12/13.
//

import UIKit
import DropMenuBar
import RxRelay

class TimeDownView: BaseView, UITableViewDelegate, UITableViewDataSource {
    
    var modelArray: [ItemModel]?
    
    var block: ((ItemModel) -> Void)?
    
    var startTimeBlock: ((UIButton) -> Void)?
    
    var endTimeBlock: ((UIButton) -> Void)?
    
    var sureTimeBlock: ((UIButton) -> Void)?
    
    var btn: UIButton?
    
    var startDateRelay = BehaviorRelay<String?>(value: nil)//开始时间
    
    var endDateRelay = BehaviorRelay<String?>(value: nil)//结束时间
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TimeSelectCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = modelArray?[indexPath.row] else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeSelectCell", for: indexPath)
        cell.textLabel?.font = .regularFontOfSize(size: 12)
        cell.textLabel?.text = model.displayText ?? ""
        cell.selectionStyle = .none
        cell.textLabel?.textColor = model.seleceted ? UIColor.init(cssStr: "#547AFF") : UIColor.init(cssStr: "#666666")
        cell.accessoryType = model.seleceted ? .checkmark : .none;
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView = UIView()
        let label = UILabel()
        let lineView = UIView()
        let btn = UIButton(type: .custom)
        self.btn = btn
        let startBtn = UIButton(type: .custom)
        startBtn.backgroundColor = UIColor.init(cssStr: "#F3F3F3")
        startBtn.layer.cornerRadius = 2
        startBtn.layer.masksToBounds = true
        startBtn.setTitle("开始日期", for: .normal)
        startBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
        startBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        
        let endBtn = UIButton(type: .custom)
        endBtn.backgroundColor = UIColor.init(cssStr: "#F3F3F3")
        endBtn.layer.cornerRadius = 2
        endBtn.layer.masksToBounds = true
        endBtn.setTitle("结束日期", for: .normal)
        endBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
        endBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.init(cssStr: "#9FB5FF")
        btn.layer.cornerRadius = 3
        btn.isEnabled = false
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = .regularFontOfSize(size: 12)
        
        label.text = "自定义时间"
        label.font = .mediumFontOfSize(size: 12)
        label.textColor = UIColor.init(cssStr: "#3F96FF")
        label.textAlignment = .left
        
        lineView.backgroundColor = UIColor.init(cssStr: "#666666")
        
        footView.addSubview(label)
        footView.addSubview(startBtn)
        footView.addSubview(lineView)
        footView.addSubview(endBtn)
        footView.addSubview(btn)
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(16.5)
        }
        startBtn.snp.makeConstraints { make in
            make.left.equalTo(label.snp.left)
            make.top.equalTo(label.snp.bottom).offset(15)
            make.height.equalTo(32)
            make.width.equalTo(134)
        }
        lineView.snp.makeConstraints { make in
            make.left.equalTo(startBtn.snp.right).offset(4.5)
            make.centerY.equalTo(startBtn.snp.centerY)
            make.size.equalTo(CGSize(width: 7.5, height: 0.5))
        }
        endBtn.snp.makeConstraints { make in
            make.left.equalTo(lineView.snp.right).offset(4.5)
            make.top.equalTo(label.snp.bottom).offset(15)
            make.height.equalTo(32)
            make.width.equalTo(134)
        }
        btn.snp.makeConstraints { make in
            make.centerY.equalTo(endBtn.snp.centerY)
            make.top.equalTo(endBtn.snp.top)
            make.right.equalToSuperview().offset(-8.5)
            make.width.equalTo(53)
        }
        
        startBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.startTimeBlock?(startBtn)
        }).disposed(by: disposeBag)
        
        endBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.endTimeBlock?(endBtn)
        }).disposed(by: disposeBag)
        
        btn.rx.tap.subscribe(onNext: { [weak self] in
            self?.sureTimeBlock?(btn)
        }).disposed(by: disposeBag)
        
        startDateRelay.subscribe(onNext: { time in
            if let time = time, !time.isEmpty {
                startBtn.setTitle(time, for: .normal)
                startBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
            }else {
                startBtn.setTitle("开始日期", for: .normal)
                startBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
            }
        }).disposed(by: disposeBag)
        
        endDateRelay.subscribe(onNext: { time in
            if let time = time, !time.isEmpty {
                endBtn.setTitle(time, for: .normal)
                endBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
            }else {
                endBtn.setTitle("结束日期", for: .normal)
                endBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
            }
        }).disposed(by: disposeBag)
        
        return footView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resetOldSelect(with: modelArray!, selectRow: indexPath.row)
        tableView.reloadData()
        if let model = modelArray?[indexPath.row] {
            self.block?(model)
        }
    }
    
    func resetOldSelect(with dataSource: [ItemModel], selectRow row: Int) {
        dataSource.forEach { model in
            model.seleceted = false
        }
        let selectModel = dataSource[row]
        selectModel.seleceted = true
    }

}
