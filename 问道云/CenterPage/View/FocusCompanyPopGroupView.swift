//
//  FocusCompanyPopGroupView.swift
//  问道云
//
//  Created by 何康 on 2024/12/26.
//

import UIKit
import RxRelay

class FocusCompanyPopGroupView: BaseView {

    var cblock: (() -> Void)?
    
    var sblock: ((rowsModel) -> Void)?
    
    var model = BehaviorRelay<[rowsModel]>(value: [])
    
    var selectedIndex: Int? // 用于记录选中项的索引
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 10
        return bgView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "选择分组"
        nameLabel.textColor = .init(cssStr: "#27344C")
        nameLabel.font = .mediumFontOfSize(size: 18)
        return nameLabel
    }()
    
    lazy var canBtn: UIButton = {
        let canBtn = UIButton(type: .custom)
        canBtn.setTitle("取消", for: .normal)
        canBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
        canBtn.titleLabel?.font = .regularFontOfSize(size: 15)
        return canBtn
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(UIColor.init(cssStr: "#307CFF"), for: .normal)
        sureBtn.titleLabel?.font = .regularFontOfSize(size: 15)
        return sureBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var lineView1: UIView = {
        let lineView1 = UIView()
        lineView1.backgroundColor = .init(cssStr: "#EEEEEE")
        return lineView1
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(FenzuCell.self, forCellReuseIdentifier: "FenzuCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(lineView)
        bgView.addSubview(tableView)
        bgView.addSubview(lineView1)
        bgView.addSubview(canBtn)
        bgView.addSubview(sureBtn)
        bgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(35)
            make.height.equalTo(330)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(18)
            make.height.equalTo(22)
        }
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
            make.height.equalTo(0.5)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(13)
            make.bottom.equalTo(lineView.snp.top)
        }
        lineView1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-14.5)
            make.width.equalTo(0.5)
        }
        canBtn.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom)
            make.right.equalTo(lineView1.snp.left)
        }
        sureBtn.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom)
            make.left.equalTo(lineView1.snp.right)
        }

        model.bind(to: tableView.rx.items(cellIdentifier: "FenzuCell", cellType: FenzuCell.self)) { index, model, cell in
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.model.accept(model)
            if index == self.selectedIndex {
                cell.icon.image = UIImage(named: "Checkb_sel")
            } else {
                cell.icon.image = UIImage(named: "Check_nor")
            }
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            print("indexPath>>>>>\(indexPath.row)")
            guard let self = self else { return }
            self.selectedIndex = indexPath.row
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        canBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.cblock?()
        }).disposed(by: disposeBag)
        sureBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let models = self.model.value[self.selectedIndex ?? 0]
            self.sblock?(models)
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class FenzuCell: BaseViewCell {
    
    var model = BehaviorRelay<rowsModel?>(value: nil)
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "默认分组"
        nameLabel.textColor = .init(cssStr: "#27344B")
        nameLabel.font = .mediumFontOfSize(size: 14)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textColor = .init(cssStr: "#27344B")
        numLabel.font = .mediumFontOfSize(size: 14)
        numLabel.textAlignment = .center
        return numLabel
    }()
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "Check_nor")
        return icon
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(numLabel)
        contentView.addSubview(icon)
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(20)
        }
        
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(nameLabel.snp.right).offset(8)
            make.height.equalTo(20)
        }
        
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            self.nameLabel.text = model.groupname ?? ""
            self.numLabel.text = "(\(model.customerFollowList?.count ?? 0))"
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
