//
//  PopHistoryNameView.swift
//  问道云
//
//  Created by Andrew on 2025/1/15.
//

import UIKit
import RxRelay

class PopHistoryNameView: BaseView {
    
    var block: ((namesUsedBeforeModel) -> Void)?
    
    var modelArray = BehaviorRelay<[namesUsedBeforeModel]?>(value: nil)

    lazy var bgViwe: UIView = {
        let bgViwe = UIView()
        bgViwe.backgroundColor = .white
        bgViwe.layer.cornerRadius = 10
        return bgViwe
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "曾用名"
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .center
        mlabel.font = .mediumFontOfSize(size: 16)
        return mlabel
    }()
    
    lazy var closeBtn: UIButton = {
        let closeBtn = UIButton(type: .custom)
        closeBtn.setTitle("关闭", for: .normal)
        closeBtn.backgroundColor = UIColor.white
        closeBtn.setTitleColor(UIColor.init(cssStr: "#307CFF"), for: .normal)
        closeBtn.titleLabel?.font = .regularFontOfSize(size: 18)
        return closeBtn
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(HistoryNameCell.self, forCellReuseIdentifier: "HistoryNameCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgViwe)
        bgViwe.addSubview(mlabel)
        bgViwe.addSubview(tableView)
        bgViwe.addSubview(closeBtn)
        
        bgViwe.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(37)
            make.height.equalTo(200)
        }
        mlabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(mlabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(100)
        }
        closeBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(50)
        }
        
        modelArray.compactMap { $0 }.asObservable().bind(to: tableView.rx.items(cellIdentifier: "HistoryNameCell", cellType: HistoryNameCell.self)) { row, model, cell in
            cell.nameLabel.text = model.entityName ?? ""
            let startTime = model.startTime ?? ""
            let endTime = model.endTime ?? ""
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.timeLabel.text = "(\(startTime)-\(endTime))"
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(namesUsedBeforeModel.self)
            .subscribe(onNext: { [weak self] model in
            self?.block?(model)
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PopHistoryNameView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
}

class HistoryNameCell: BaseViewCell {
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .regularFontOfSize(size: 14)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = .init(cssStr: "#9FA4AD")
        timeLabel.font = .regularFontOfSize(size: 14)
        timeLabel.textAlignment = .left
        return timeLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview()
            make.height.equalTo(24)
        }
        timeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.height.equalTo(24)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
