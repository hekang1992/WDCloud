//
//  GroupListView.swift
//  问道云
//
//  Created by 何康 on 2025/1/2.
//

import UIKit
import RxRelay

class GroupListView: BaseView {
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    var changeBlock: ((rowsModel) -> Void)?
    
    var deleteBlock: ((rowsModel) -> Void)?
    
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .init(cssStr: "#F5F7F9")
        bgView.layer.cornerRadius = 3
        return bgView
    }()
    
    lazy var vipBtn: UIButton = {
        let vipBtn = UIButton(type: .custom)
        vipBtn.setTitle("续费", for: .normal)
        vipBtn.titleLabel?.font = .semiboldFontOfSize(size: 10)
        vipBtn.setTitleColor(.init(cssStr: "#333333"), for: .normal)
        vipBtn.setImage(UIImage(named: "huiyuanimgeteam"), for: .normal)
        vipBtn.layer.cornerRadius = 10
        vipBtn.layer.borderWidth = 1
        vipBtn.layer.borderColor = UIColor.init(cssStr: "#FFD528")?.cgColor
        return vipBtn
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .mediumFontOfSize(size: 15)
        return nameLabel
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .left
        oneLabel.textColor = .init(cssStr: "#666666")
        oneLabel.font = .regularFontOfSize(size: 14)
        oneLabel.text = "当前套餐"
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textAlignment = .left
        twoLabel.textColor = .init(cssStr: "#666666")
        twoLabel.font = .regularFontOfSize(size: 14)
        twoLabel.text = "到期时间"
        return twoLabel
    }()
    
    lazy var threeLabel: UILabel = {
        let threeLabel = UILabel()
        threeLabel.textAlignment = .left
        threeLabel.textColor = .init(cssStr: "#666666")
        threeLabel.font = .regularFontOfSize(size: 14)
        threeLabel.text = "套餐人数"
        return threeLabel
    }()
    
    lazy var fourLabel: UILabel = {
        let fourLabel = UILabel()
        fourLabel.textAlignment = .right
        fourLabel.textColor = .init(cssStr: "#333333")
        fourLabel.font = .mediumFontOfSize(size: 14)
        return fourLabel
    }()
    
    lazy var fiveLabel: UILabel = {
        let fiveLabel = UILabel()
        fiveLabel.textAlignment = .right
        fiveLabel.textColor = .init(cssStr: "#547AFF")
        fiveLabel.font = .mediumFontOfSize(size: 14)
        return fiveLabel
    }()
    
    lazy var sixLabel: UILabel = {
        let sixLabel = UILabel()
        sixLabel.textAlignment = .right
        sixLabel.textColor = .init(cssStr: "#333333")
        sixLabel.font = .regularFontOfSize(size: 14)
        return sixLabel
    }()
    
    lazy var grayView: UIView = {
        let grayView = UIView()
        grayView.backgroundColor = .init(cssStr: "#F6F6F6")
        return grayView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(GroupListViewCell.self, forCellReuseIdentifier: "GroupListViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")
        nextBtn.setTitle("添加成员", for: .normal)
        nextBtn.titleLabel?.font = .mediumFontOfSize(size: 15)
        nextBtn.layer.cornerRadius = 4
        return nextBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(grayView)
        addSubview(nextBtn)
        addSubview(tableView)
        
        bgView.addSubview(nameLabel)
        bgView.addSubview(oneLabel)
        bgView.addSubview(twoLabel)
        bgView.addSubview(threeLabel)
        
        bgView.addSubview(fourLabel)
        bgView.addSubview(fiveLabel)
        bgView.addSubview(sixLabel)
        
        bgView.addSubview(vipBtn)
        
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(12.5)
            make.height.equalTo(137)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(13)
            make.height.equalTo(21)
        }
        
        vipBtn.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.right.equalToSuperview().offset(-12.5)
            make.width.equalTo(47)
            make.height.equalTo(20)
        }
        
        oneLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.height.equalTo(20)
        }
        twoLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(oneLabel.snp.bottom).offset(7)
            make.height.equalTo(20)
        }
        threeLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(twoLabel.snp.bottom).offset(7)
            make.height.equalTo(20)
        }
        fourLabel.snp.makeConstraints { make in
            make.centerY.equalTo(oneLabel.snp.centerY)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(20)
        }
        fiveLabel.snp.makeConstraints { make in
            make.centerY.equalTo(twoLabel.snp.centerY)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(20)
        }
        sixLabel.snp.makeConstraints { make in
            make.centerY.equalTo(threeLabel.snp.centerY)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(20)
        }
        grayView.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(5)
        }
        
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(27.5)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-23)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(grayView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-2)
        }

        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            let oneModel = model.rows?.first
            nameLabel.text = oneModel?.firmname ?? ""
            fourLabel.text = oneModel?.comboname ?? ""
            fiveLabel.text = oneModel?.endtime ?? ""
            sixLabel.text = String("\(model.rows?.count ?? 0)/\(oneModel?.accountcount ?? 0)")
        }).disposed(by: disposeBag)
        
        
        model.compactMap{ $0?.rows }
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "GroupListViewCell", cellType: GroupListViewCell.self)) { row, model, cell in
                cell.model.accept(model)
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.changeBlock = { [weak self] model in
                    self?.changeBlock?(model)
                }
                cell.deleteBlock = { [weak self] model in
                    self?.deleteBlock?(model)
                }
        }.disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GroupListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        let numLabel = UILabel()
        numLabel.textColor = .init(cssStr: "#333333")
        numLabel.textAlignment = .left
        numLabel.font = .mediumFontOfSize(size: 15)
        numLabel.text = "套餐成员: \(model.value?.rows?.count ?? 0)人"
        headView.addSubview(numLabel)
        numLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(13)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(21)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F6F6F6")
        headView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
        headView.backgroundColor = .white
        return headView
    }
    
    
    
}
