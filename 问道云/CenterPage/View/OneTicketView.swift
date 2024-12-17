//
//  OneTicketView.swift
//  问道云
//
//  Created by 何康 on 2024/12/17.
//

import UIKit
import RxRelay

class OneTicketCell: BaseViewCell {
    
    var rowsModel = BehaviorRelay<rowsModel?>(value: nil)
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "Check_nor")
        return icon
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .mediumFontOfSize(size: 16)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textColor = .init(cssStr: "#9FA4AD")
        oneLabel.font = .mediumFontOfSize(size: 13)
        oneLabel.textAlignment = .left
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textColor = .init(cssStr: "#9FA4AD")
        twoLabel.font = .mediumFontOfSize(size: 13)
        twoLabel.textAlignment = .left
        return twoLabel
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 5
        return whiteView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(whiteView)
        contentView.addSubview(icon)
        contentView.addSubview(nameLabel)
        contentView.addSubview(oneLabel)
        contentView.addSubview(twoLabel)
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 22, height: 22))
            make.left.equalToSuperview().offset(10)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(56.5)
            make.height.equalTo(22.5)
        }
        oneLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(14)
            make.height.equalTo(18.5)
        }
        twoLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(oneLabel.snp.bottom).offset(6)
            make.height.equalTo(18.5)
            make.bottom.equalToSuperview().offset(-25)
        }
        whiteView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(42)
            make.top.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH - 51)
            make.bottom.equalToSuperview().offset(-8)
        }
        rowsModel.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            nameLabel.text = model.invoicecontent ?? ""
            oneLabel.text = model.ordernumber ?? ""
            twoLabel.text = model.createTime ?? ""
            if model.isChecked {
                icon.image = UIImage(named: "Checkb_sel")
            }else {
                icon.image = UIImage(named: "Check_nor")
            }
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class OneTicketView: BaseView {
    
    var modelArray = BehaviorRelay<[rowsModel]>(value: [])
    
    var selectedCount = BehaviorRelay<Int>(value: 0)
    
//    // 用于统计当前被选中的项数
//    var selectedCount = 0 {
//        didSet {
//            // 每次选中状态改变时，更新 UI 显示选中的数量
//            print("Selected Count: \(selectedCount)")
//        }
//    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = 80
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .init(cssStr: "#F5F5F5")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(OneTicketCell.self, forCellReuseIdentifier: "OneTicketCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        sureBtn.setTitle("立即开票", for: .normal)
        sureBtn.setTitleColor(.white, for: .normal)
        sureBtn.titleLabel?.font = .regularFontOfSize(size: 15)
        sureBtn.backgroundColor = .init(cssStr: "#547AFF")
        sureBtn.layer.cornerRadius = 3
        return sureBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        addSubview(sureBtn)
        sureBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(45)
            make.size.equalTo(CGSize(width: SCREEN_WIDTH - 90, height: 45))
            make.bottom.equalToSuperview().offset(-34)
        }
        tableView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(sureBtn.snp.top).offset(-10)
        }
        
        modelArray.asObservable().bind(to: tableView.rx.items(cellIdentifier: "OneTicketCell", cellType: OneTicketCell.self)) { row, model, cell in
            cell.rowsModel.accept(model)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            let model = modelArray.value[indexPath.row]
            model.isChecked.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            // 更新选中计数
            var selectedCount = 0
            if model.isChecked {
                selectedCount += 1
                self.selectedCount.accept(selectedCount) // 选中项数加 1
            } else {
                selectedCount -= 1  // 选中项数减 1
                self.selectedCount.accept(selectedCount)
            }
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension OneTicketView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = .init(cssStr: "#F5F5F5")
        let label = UILabel()
        selectedCount.asObservable().subscribe(onNext: { num in
            label.text = "共计\(num)个订单，由阿拉丁为您开具电子发票。"
        }).disposed(by: disposeBag)
        label.font = .regularFontOfSize(size: 12)
        label.textColor = .init(cssStr: "#9FA4AD")
        label.textAlignment = .left
        headView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(11)
            make.top.bottom.right.equalToSuperview()
        }
        return headView
    }
    
}


