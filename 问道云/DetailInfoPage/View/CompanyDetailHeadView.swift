//
//  CompanyDetailHeadView.swift
//  问道云
//
//  Created by 何康 on 2025/1/13.
//

import UIKit

class CompanyDetailHeadView: BaseView {

    lazy var oneHeadView: CompanyOneHeadView = {
        let oneHeadView = CompanyOneHeadView()
        return oneHeadView
    }()
    
    lazy var twoHeadView: CompanyTwoHeadView = {
        let twoHeadView = CompanyTwoHeadView()
        return twoHeadView
    }()
    
    lazy var threeHeadView: CompanyThreeHeadView = {
        let threeHeadView = CompanyThreeHeadView()
        return threeHeadView
    }()
    
    lazy var fourHeadView: CompanyFourHeadView = {
        let fourHeadView = CompanyFourHeadView()
        return fourHeadView
    }()
    
    lazy var fiveHeadView: CompanyFiveHeadView = {
        let fiveHeadView = CompanyFiveHeadView()
        return fiveHeadView
    }()
    
    lazy var sixHeadView: CompanySixHeadView = {
        let sixHeadView = CompanySixHeadView()
        return sixHeadView
    }()
    
    lazy var stockView: CompanyStockInfoView = {
        let stockView = CompanyStockInfoView()
        return stockView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(oneHeadView)
        addSubview(twoHeadView)
        addSubview(threeHeadView)
        addSubview(fourHeadView)
        addSubview(fiveHeadView)
        addSubview(sixHeadView)
        addSubview(stockView)
        oneHeadView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(210)
        }
        twoHeadView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(oneHeadView.snp.bottom)
            make.height.equalTo(40)
        }
        threeHeadView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(twoHeadView.snp.bottom)
            make.height.equalTo(160)
        }
        fourHeadView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(threeHeadView.snp.bottom)
            make.height.equalTo(76)
        }
        fiveHeadView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(fourHeadView.snp.bottom)
            make.height.equalTo(53)
        }
        sixHeadView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(fiveHeadView.snp.bottom)
            make.height.equalTo(150)
        }
        stockView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(sixHeadView.snp.bottom)
            make.height.equalTo(220)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
