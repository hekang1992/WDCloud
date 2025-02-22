//
//  RiskMonitoringView.swift
//  问道云
//
//  Created by 何康 on 2025/2/22.
//

import UIKit

class RiskMonitoringView: BaseView {
    
    var companyBlock: ((UIButton) -> Void)?
    
    var peopleBlock: ((UIButton) -> Void)?
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = .white
        return coverView
    }()
    
    lazy var companyBtn: UIButton = {
        let companyBtn = UIButton(type: .custom)
        companyBtn.setTitle("企业", for: .normal)
        companyBtn.titleLabel?.font = .mediumFontOfSize(size: 14)
        companyBtn.setTitleColor(UIColor.init(cssStr: "#547AFF "), for: .normal)
        return companyBtn
    }()
    
    lazy var peopleBtn: UIButton = {
        let peopleBtn = UIButton(type: .custom)
        peopleBtn.setTitle("个人", for: .normal)
        peopleBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        peopleBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        return peopleBtn
    }()
    
    lazy var oneLineView: UIView = {
        let oneLineView = UIView()
        oneLineView.backgroundColor = .init(cssStr: "#547AFF")
        return oneLineView
    }()
    
    lazy var twoLineView: UIView = {
        let twoLineView = UIView()
        twoLineView.backgroundColor = .init(cssStr: "#547AFF")
        twoLineView.isHidden = true
        return twoLineView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(MonitoringCell.self, forCellReuseIdentifier: "MonitoringCell")
        tableView.estimatedRowHeight = 80
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverView)
        coverView.addSubview(companyBtn)
        coverView.addSubview(peopleBtn)
        coverView.addSubview(oneLineView)
        coverView.addSubview(twoLineView)
        addSubview(tableView)
        
        coverView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(32)
        }
        companyBtn.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH * 0.5)
        }
        peopleBtn.snp.makeConstraints { make in
            make.left.equalTo(companyBtn.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH * 0.5)
        }
        oneLineView.snp.makeConstraints { make in
            make.centerX.equalTo(companyBtn.snp.centerX)
            make.size.equalTo(CGSize(width: 15, height: 2))
            make.bottom.equalToSuperview()
        }
        twoLineView.snp.makeConstraints { make in
            make.centerX.equalTo(peopleBtn.snp.centerX)
            make.size.equalTo(CGSize(width: 15, height: 2))
            make.bottom.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.bottom.equalToSuperview()
            make.top.equalTo(coverView.snp.bottom)
        }
        
        companyBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.companyBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
            self.companyBtn.titleLabel?.font = .mediumFontOfSize(size: 14)
            self.peopleBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
            self.peopleBtn.titleLabel?.font = .regularFontOfSize(size: 14)
            self.oneLineView.isHidden = false
            self.twoLineView.isHidden = true
            self.companyBlock?(companyBtn)
        }).disposed(by: disposeBag)
        
        peopleBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.peopleBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
            self.peopleBtn.titleLabel?.font = .mediumFontOfSize(size: 14)
            self.companyBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
            self.companyBtn.titleLabel?.font = .regularFontOfSize(size: 14)
            self.oneLineView.isHidden = true
            self.twoLineView.isHidden = false
            self.peopleBlock?(peopleBtn)
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
