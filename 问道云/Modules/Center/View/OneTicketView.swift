//
//  OneTicketView.swift
//  问道云
//
//  Created by Andrew on 2024/12/17.
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
    
    lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.textColor = .init(cssStr: "#F55B5B")
        priceLabel.font = .mediumFontOfSize(size: 14)
        priceLabel.textAlignment = .right
        return priceLabel
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
        whiteView.addSubview(priceLabel)
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
        priceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(17)
            make.size.equalTo(CGSize(width: 80, height: 20))
        }
        rowsModel.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            nameLabel.text = model.comboname ?? ""
            oneLabel.text = "订单编号:\(model.ordernumber ?? "")"
            twoLabel.text = "购买时间:\(model.ordertime ?? "")"
            let price = String(format: "%.2f", model.pirce ?? 0.00)
            priceLabel.text = "¥\(price)"
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
    
    var model = BehaviorRelay<rowsModel?>(value: nil)
    
    var modelArray = BehaviorRelay<[rowsModel]>(value: [])
    
    var selectedCount = BehaviorRelay<Int>(value: 0)
    
    var backBlock: ((rowsModel) -> Void)?
    
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
        tableView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(SCREEN_HEIGHT - StatusHeightManager.navigationBarHeight - 144)
        }
        sureBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(45)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
            make.top.equalTo(tableView.snp.bottom).offset(18)
        }
        modelArray.asObservable().bind(to: tableView.rx.items(cellIdentifier: "OneTicketCell", cellType: OneTicketCell.self)) { row, model, cell in
            cell.rowsModel.accept(model)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            let models = self.modelArray.value
            for i in 0..<models.count {
                models[i].isChecked = (i == indexPath.row)
            }
            self.selectedCount.accept(1)
            self.modelArray.accept(models)
            self.model.accept(models[indexPath.row])
        }).disposed(by: disposeBag)
        
        sureBtn.rx.tap.subscribe(onNext: { [weak self] in
            if let self = self, let model = model.value {
                self.backBlock?(model)
            }else {
                ToastViewConfig.showToast(message: "请选择需要开具发票的订单")
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
            label.text = "共计\(num)个订单，由问道云为您开具电子发票。"
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


