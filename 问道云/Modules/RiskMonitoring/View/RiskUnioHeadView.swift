//
//  RiskUnioHeadView.swift
//  问道云
//
//  Created by Andrew on 2025/2/5.
//

import UIKit

class RiskUnioHeadView: BaseView {
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = .regularFontOfSize(size: 13)
        descLabel.backgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.05)
        descLabel.layer.cornerRadius = 2
        descLabel.layer.borderWidth = 1
        descLabel.textAlignment = .center
        descLabel.layer.masksToBounds = true
        descLabel.textColor = UIColor.init(cssStr: "#333333")
        descLabel.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        return descLabel
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.init(cssStr: "#F8F9FB")
        bgView.layer.cornerRadius = 2
        return bgView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    lazy var oneView: RiskNumView = {
        let oneView = RiskNumView()
        oneView.nameLabel.text = "母公司/子分公司"
        return oneView
    }()
    
    lazy var twoView: RiskNumView = {
        let twoView = RiskNumView()
        twoView.nameLabel.text = "对外投资"
        return twoView
    }()
    
    lazy var threeView: RiskNumView = {
        let threeView = RiskNumView()
        threeView.nameLabel.text = "董监高投资"
        return threeView
    }()
    
    lazy var fourView: RiskNumView = {
        let fourView = RiskNumView()
        fourView.nameLabel.text = "股东"
        return fourView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(descLabel)
        addSubview(bgView)
        bgView.addSubview(stackView)
        stackView.addArrangedSubview(oneView)
        stackView.addArrangedSubview(twoView)
        stackView.addArrangedSubview(threeView)
        stackView.addArrangedSubview(fourView)
        descLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(30)
        }
        bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descLabel.snp.bottom).offset(12)
            make.left.equalToSuperview()
            make.height.equalTo(63)
        }
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.bottom.top.equalToSuperview()
        }
        oneView.numLabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        twoView.numLabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        threeView.numLabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        fourView.numLabel.textColor = UIColor.init(cssStr: "#9FA4AD")
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
