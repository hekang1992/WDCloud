//
//  PopRateMoneyView.swift
//  问道云
//
//  Created by Andrew on 2025/1/15.
//  弹窗员工人数

import UIKit
import RxRelay

class PopRateMoneyView: BaseView {
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    var block: ((DataModel) -> Void)?
    
    lazy var bgViwe: UIView = {
        let bgViwe = UIView()
        bgViwe.backgroundColor = .white
        bgViwe.layer.cornerRadius = 10
        return bgViwe
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.isUserInteractionEnabled = true
        return ctImageView
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.1)
        cancelBtn.setTitle("关闭", for: .normal)
        cancelBtn.setTitleColor(.init(cssStr: "#547AFF"), for: .normal)
        cancelBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        cancelBtn.layer.cornerRadius = 3
        return cancelBtn
    }()
    
    lazy var moreBtn: UIButton = {
        let moreBtn = UIButton(type: .custom)
        moreBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")
        moreBtn.setTitle("更多财务数据", for: .normal)
        moreBtn.setTitleColor(.init(cssStr: "#FFFFFF"), for: .normal)
        moreBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        moreBtn.layer.cornerRadius = 3
        return moreBtn
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(EmployeeMoneyNumViewCell.self, forCellReuseIdentifier: "EmployeeMoneyNumViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    init(frame: CGRect, type: String) {
        super.init(frame: frame)
        addSubview(bgViwe)
        bgViwe.addSubview(ctImageView)
        bgViwe.addSubview(tableView)
        bgViwe.addSubview(cancelBtn)
        bgViwe.addSubview(moreBtn)
        
        bgViwe.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.height.equalTo(350)
        }
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 86, height: 23))
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(ctImageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(230)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.size.equalTo(CGSize(width: 135.pix(), height: 37))
        }
        moreBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
            make.size.equalTo(CGSize(width: 135.pix(), height: 37))
        }
        
        moreBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self, let model = model.value else { return }
            self.block?(model)
        }).disposed(by: disposeBag)
        
        if type == "0" {
            model.compactMap { $0?.incomeInfo?.annualReports ?? [] }.bind(to: tableView.rx.items(cellIdentifier: "EmployeeMoneyNumViewCell", cellType: EmployeeMoneyNumViewCell.self)) { row, model, cell in
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.timeLabel.text = model.reportYear ?? ""
                cell.numLabel.text = String(model.amount ?? 0)
            }.disposed(by: disposeBag)
        }else if type == "1" {
            model.compactMap { $0?.profitInfo?.annualReports ?? [] }.bind(to: tableView.rx.items(cellIdentifier: "EmployeeMoneyNumViewCell", cellType: EmployeeMoneyNumViewCell.self)) { row, model, cell in
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.timeLabel.text = model.reportYear ?? ""
                cell.numLabel.text = String(model.amount ?? 0)
            }.disposed(by: disposeBag)
        }else if type == "2" {
            model.compactMap { $0?.assetInfo?.annualReports ?? [] }.bind(to: tableView.rx.items(cellIdentifier: "EmployeeMoneyNumViewCell", cellType: EmployeeMoneyNumViewCell.self)) { row, model, cell in
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.timeLabel.text = model.reportYear ?? ""
                cell.numLabel.text = String(model.amount ?? 0)
            }.disposed(by: disposeBag)
        }else {
            
        }
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PopRateMoneyView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 27
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        let plabel = UILabel()
        plabel.text = "年份"
        plabel.textAlignment = .left
        plabel.font = .regularFontOfSize(size: 15)
        plabel.textColor = .init(cssStr: "#999999")
        
        let tlabel = UILabel()
        tlabel.text = "金额"
        tlabel.textAlignment = .right
        tlabel.font = .regularFontOfSize(size: 15)
        tlabel.textColor = .init(cssStr: "#999999")
        
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5F")
        
        headView.addSubview(plabel)
        headView.addSubview(tlabel)
        headView.addSubview(lineView)
        
        plabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(27)
            make.height.equalTo(18.5)
        }
        tlabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(plabel.snp.right).offset(127)
            make.height.equalTo(18.5)
        }
        lineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        headView.backgroundColor = .white
        return headView
    }
    
}

class EmployeeMoneyNumViewCell: BaseViewCell {
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textAlignment = .left
        timeLabel.font = .regularFontOfSize(size: 13)
        timeLabel.textColor = .init(cssStr: "#333333")
        return timeLabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textAlignment = .left
        numLabel.font = .regularFontOfSize(size: 13)
        numLabel.textColor = .init(cssStr: "#333333")
        return numLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .right
        descLabel.text = "（合并报表）"
        descLabel.font = .regularFontOfSize(size: 13)
        descLabel.textColor = .init(cssStr: "#999999")
        return descLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(timeLabel)
        contentView.addSubview(numLabel)
        contentView.addSubview(descLabel)
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(18.5)
        }
        numLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel.snp.centerY)
            make.left.equalToSuperview().offset(150)
            make.height.equalTo(18.5)
        }
        descLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel.snp.centerY)
            make.left.equalTo(numLabel.snp.right).offset(5.5)
            make.height.equalTo(18.5)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
