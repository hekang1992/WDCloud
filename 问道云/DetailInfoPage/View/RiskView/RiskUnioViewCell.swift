//
//  RiskUnioViewCell.swift
//  问道云
//
//  Created by 何康 on 2025/1/17.
//

import UIKit
import RxRelay

class RiskUnioViewCell: BaseViewCell {
    
    var model = BehaviorRelay<rimRiskModel?>(value: nil)

    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .mediumFontOfSize(size: 15)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var descLabel: PaddedLabel = {
        let descLabel = PaddedLabel()
        descLabel.padding = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
        descLabel.textColor = .init(cssStr: "#FF7D00")
        descLabel.font = .mediumFontOfSize(size: 10)
        descLabel.textAlignment = .center
        descLabel.layer.cornerRadius = 2
        descLabel.backgroundColor = .init(cssStr: "#FFEEDE")
        return descLabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textColor = .init(cssStr: "#999999")
        numLabel.font = .mediumFontOfSize(size: 11)
        numLabel.textAlignment = .right
        return numLabel
    }()
    
    lazy var grayView: UIView = {
        let grayView = UIView()
        grayView.layer.cornerRadius = 2
        grayView.backgroundColor = .init(cssStr: "#F8F9FB")
        return grayView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(numLabel)
        contentView.addSubview(grayView)
        contentView.addSubview(lineView)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15.5)
            make.height.equalTo(21)
            make.bottom.equalToSuperview().offset(-109)
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.height.equalTo(14)
        }
        numLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.height.equalTo(15)
            make.right.equalToSuperview().offset(-18)
        }
        grayView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(63)
            make.top.equalToSuperview().offset(63.5)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            nameLabel.text = model.entityname ?? ""
            descLabel.text = model.relate ?? ""
            numLabel.text = "累计风险: \(model.relatedEntitySize ?? 0)条"
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
