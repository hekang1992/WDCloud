//
//  AddInvoiceView.swift
//  问道云
//
//  Created by Andrew on 2024/12/16.
//

import UIKit
import RxRelay

class AddInvoiceView: BaseView {
    
    var block: ((Int, DescModel, AddInvoiceViewCell) -> Void)?
    
    var modelArray = BehaviorRelay<[DescModel]>(value: [])
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(AddInvoiceViewCell.self, forCellReuseIdentifier: "AddInvoiceViewCell")
        return tableView
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")
        nextBtn.setTitle("保存", for: .normal)
        nextBtn.titleLabel?.font = .mediumFontOfSize(size: 15)
        nextBtn.layer.cornerRadius = 3
        return nextBtn
    }()
    
    lazy var checkButton: UIButton = {
        let checkButton = UIButton(type: .custom)
        checkButton.setTitle("设为默认开票信息", for: .normal)
        checkButton.titleLabel?.font = .regularFontOfSize(size: 12)
        checkButton.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        checkButton.setImage(.init(named: "selnor"), for: .normal)
        checkButton.setImage(.init(named: "selsel"), for: .selected)
        checkButton.adjustsImageWhenDisabled = true
        checkButton.layoutButtonEdgeInsets(style: .left, space: 5)
        return checkButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        addSubview(nextBtn)
        addSubview(checkButton)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(27.5)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-43)
        }
        checkButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-13.5)
            make.size.equalTo(CGSize(width: 120, height: 16.5))
        }
        
        modelArray.asObservable().bind(to: tableView.rx.items) { [weak self] tableView, index, model in
            if let self = self, let cell = tableView.dequeueReusableCell(withIdentifier: "AddInvoiceViewCell", for: IndexPath(row: index, section: 0)) as? AddInvoiceViewCell  {
                cell.backgroundColor = .clear
                cell.selectionStyle = .none
                cell.model.accept(model)
                self.block?(index, model, cell)
                model.text.subscribe(onNext: { text in
                    cell.enterTx.text = text
                }).disposed(by: disposeBag)
                return cell
            }
            return UITableViewCell()
        }.disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddInvoiceView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footView = UIView()
        footView.backgroundColor = UIColor.init(cssStr: "#FFF9E9")
        
        let icon = UIImageView()
        icon.image = UIImage(named: "search_tip")
        footView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 12, height: 12))
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(17.5)
        }
        
        let mlabel = UILabel()
        mlabel.text = "请填写完整信息，以便开具增值税发票，下次开票您只要出示上述信息即可，我们不会把您的信息用作其他用途。"
        mlabel.numberOfLines = 0
        mlabel.textColor = UIColor.init(cssStr: "#E3AC28")
        mlabel.textAlignment = .left
        mlabel.font = .regularFontOfSize(size: 12)
        footView.addSubview(mlabel)
        mlabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.left.equalTo(icon.snp.right).offset(2)
        }
        return footView
    }
    
}

