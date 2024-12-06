//
//  OrderListViewCell.swift
//  问道云
//
//  Created by 何康 on 2024/12/5.
//

import UIKit
import RxRelay
import RxSwift

class OrderListViewCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    var model = BehaviorRelay<rowsModel?>(value: nil)

    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .mediumFontOfSize(size: 16)
        return nameLabel
    }()
    
    lazy var descLabel1: UILabel = {
        let descLabel1 = UILabel()
        descLabel1.textAlignment = .left
        descLabel1.text = "订单编号:"
        descLabel1.textColor = .init(cssStr: "#999999")
        descLabel1.font = .mediumFontOfSize(size: 13)
        return descLabel1
    }()
    
    lazy var descLabel2: UILabel = {
        let descLabel2 = UILabel()
        descLabel2.textAlignment = .left
        descLabel2.text = "下单时间:"
        descLabel2.textColor = .init(cssStr: "#999999")
        descLabel2.font = .mediumFontOfSize(size: 13)
        return descLabel2
    }()
    
    lazy var descLabel3: UILabel = {
        let descLabel3 = UILabel()
        descLabel3.textAlignment = .left
        descLabel3.text = "支付方式:"
        descLabel3.textColor = .init(cssStr: "#999999")
        descLabel3.font = .mediumFontOfSize(size: 13)
        return descLabel3
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descLabel1)
        contentView.addSubview(descLabel2)
        contentView.addSubview(descLabel3)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(22.5)
        }
        descLabel1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.height.equalTo(18.5)
        }
        descLabel2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(descLabel1.snp.bottom).offset(4)
            make.height.equalTo(18.5)
        }
        descLabel3.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(descLabel2.snp.bottom).offset(4)
            make.height.equalTo(18.5)
            make.bottom.equalToSuperview().offset(-46.5)
        }
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            nameLabel.text = model.comboname ?? ""
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
