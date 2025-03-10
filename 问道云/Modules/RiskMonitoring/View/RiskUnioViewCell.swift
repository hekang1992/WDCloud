//
//  RiskUnioViewCell.swift
//  问道云
//
//  Created by Andrew on 2025/1/17.
//

import UIKit
import RxRelay

class RiskUnioViewCell: BaseViewCell {
    
    var model = BehaviorRelay<statisticRiskDtosModel?>(value: nil)

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
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layer.cornerRadius = 2
        stackView.backgroundColor = .init(cssStr: "#F8F9FB")
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    lazy var oneView: RiskNumView = {
        let oneView = RiskNumView()
        return oneView
    }()
    
    lazy var twoView: RiskNumView = {
        let twoView = RiskNumView()
        return twoView
    }()
    
    lazy var threeView: RiskNumView = {
        let threeView = RiskNumView()
        return threeView
    }()
    
    lazy var fourView: RiskNumView = {
        let fourView = RiskNumView()
        return fourView
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
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(oneView)
        stackView.addArrangedSubview(twoView)
        stackView.addArrangedSubview(threeView)
        stackView.addArrangedSubview(fourView)
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
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.height.equalTo(15)
            make.right.equalToSuperview().offset(-18)
        }
        stackView.snp.makeConstraints { make in
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
            nameLabel.text = model.orgName ?? ""
            descLabel.text = model.orgRelaveType?.first ?? ""
            numLabel.text = "累计风险: \(model.totalCnt ?? 0)条"
            oneView.nameLabel.text = "经营风险"
            twoView.nameLabel.text = "法律风险"
            threeView.nameLabel.text = "财务风险"
            fourView.nameLabel.text = "舆情信息"
            
            oneView.numLabel.text = String(model.operationRiskCnt ?? 0)
            twoView.numLabel.text = String(model.lowRiskCnt ?? 0)
            threeView.numLabel.text = String(model.financeRiskCnt ?? 0)
            fourView.numLabel.text = String(model.opinionRiskCnt ?? 0)
            
            oneView.numLabel.textColor = UIColor.init(cssStr: "#333333")
            twoView.numLabel.textColor = UIColor.init(cssStr: "#333333")
            threeView.numLabel.textColor = UIColor.init(cssStr: "#333333")
            fourView.numLabel.textColor = UIColor.init(cssStr: "#333333")
            oneView.numLabel.font = .mediumFontOfSize(size: 14)
            twoView.numLabel.font = .mediumFontOfSize(size: 14)
            threeView.numLabel.font = .mediumFontOfSize(size: 14)
            fourView.numLabel.font = .mediumFontOfSize(size: 14)
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
