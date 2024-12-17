//
//  InvoiceListView.swift
//  问道云
//
//  Created by 何康 on 2024/12/16.
//  添加发票

import UIKit
import RxRelay

class InvoiceListCell: BaseViewCell {
    
    var model = BehaviorRelay<rowsModel?>(value: nil)
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor.init(cssStr: "#333333")
        nameLabel.font = .mediumFontOfSize(size: 15)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        numLabel.font = .mediumFontOfSize(size: 13)
        numLabel.textAlignment = .left
        return numLabel
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "erweimaimage")
        return ctImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(numLabel)
        contentView.addSubview(ctImageView)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(19)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(21)
        }
        numLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(11.5)
            make.left.equalTo(nameLabel.snp.left)
            make.height.equalTo(18.5)
            make.bottom.equalToSuperview().offset(-22.5)
        }
        bgView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-6)
        }
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalTo(bgView.snp.centerY)
            make.right.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            nameLabel.text = model.companyname ?? ""
            numLabel.text = model.companynumber ?? ""
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class InvoiceListView: BaseView {
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "fapiaowushuju")
        return bgImageView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.font = .regularFontOfSize(size: 15)
        mlabel.textColor = UIColor.init(cssStr: "#999999")
        mlabel.textAlignment = .center
        mlabel.text = "暂无相关数据"
        return mlabel
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")
        nextBtn.setTitle("添加发票抬头", for: .normal)
        nextBtn.titleLabel?.font = .mediumFontOfSize(size: 15)
        nextBtn.layer.cornerRadius = 3
        return nextBtn
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 80
        tableView.isHidden = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .init(cssStr: "#F4F7FB")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(InvoiceListCell.self, forCellReuseIdentifier: "InvoiceListCell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        addSubview(mlabel)
        addSubview(nextBtn)
        addSubview(tableView)
        bgImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(180)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 150, height: 150))
        }
        mlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bgImageView.snp.bottom).offset(8.5)
            make.height.equalTo(21)
        }
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 285, height: 50))
            make.bottom.equalToSuperview().offset(-23)
        }
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(nextBtn.snp.top).offset(-10)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            if model?.total != 0 {
                self?.hideNoDataView()
                self?.tableView.isHidden = false
            }else {
                self?.addNoDataView()
                self?.tableView.isHidden = true
            }
        }).disposed(by: disposeBag)
        
        model.asObservable().compactMap {
            $0?.rows
        }.bind(to: tableView.rx.items(cellIdentifier: "InvoiceListCell", cellType: InvoiceListCell.self)) { row, model ,cell in
            cell.model.accept(model)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
        }.disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension InvoiceListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = .init(cssStr: "#FFF1F1")
        let label = UILabel()
        label.text = "发票抬头仅用于开具发票，请勿用于转账等其他用途，谨防受骗"
        label.font = .regularFontOfSize(size: 12)
        label.textColor = .init(cssStr: "#F55B5B")
        label.textAlignment = .center
        headView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return headView
    }
    
    private func hideNoDataView() {
        self.bgImageView.isHidden = true
        self.mlabel.isHidden = true
        self.nextBtn.isHidden = false
    }
    
    private func addNoDataView() {
        self.bgImageView.isHidden = false
        self.mlabel.isHidden = false
        self.nextBtn.isHidden = false
    }
    
}
