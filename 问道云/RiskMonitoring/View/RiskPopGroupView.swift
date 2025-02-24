//
//  RiskPopGroupView.swift
//  问道云
//
//  Created by 何康 on 2025/2/14.
//

import UIKit

class RiskPopGroupView: BaseView {
    
    var cmmBlock: (() -> Void)?
    var deleteBlock: (() -> Void)?
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "管理监控分组"
        nameLabel.textAlignment = .center
        nameLabel.textColor = .init(cssStr: "#27344B")
        nameLabel.font = .regularFontOfSize(size: 18)
        return nameLabel
    }()
    
    lazy var cmmBtn: UIButton = {
        let cmmBtn = UIButton(type: .custom)
        cmmBtn.setTitle("重命名", for: .normal)
        cmmBtn.setTitleColor(.init(cssStr: "#27344B"), for: .normal)
        cmmBtn.titleLabel?.font = .regularFontOfSize(size: 18)
        return cmmBtn
    }()
    
    lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton(type: .custom)
        deleteBtn.setTitle("删除", for: .normal)
        deleteBtn.setTitleColor(.init(cssStr: "#FF3B30"), for: .normal)
        deleteBtn.titleLabel?.font = .regularFontOfSize(size: 18)
        return deleteBtn
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.titleLabel?.font = .mediumFontOfSize(size: 18)
        cancelBtn.backgroundColor = .white
        return cancelBtn
    }()
    
    lazy var onelineView: UIView = {
        let onelineView = UIView()
        onelineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return onelineView
    }()
    
    lazy var twolineView: UIView = {
        let twolineView = UIView()
        twolineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return twolineView
    }()
    
    lazy var threelineView: UIView = {
        let threelineView = UIView()
        threelineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return threelineView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(cmmBtn)
        bgView.addSubview(deleteBtn)
        bgView.addSubview(cancelBtn)
        bgView.addSubview(onelineView)
        bgView.addSubview(twolineView)
        bgView.addSubview(threelineView)
        bgView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(205)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        cmmBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom)
            make.height.equalTo(50)
        }
        deleteBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(cmmBtn.snp.bottom)
            make.height.equalTo(50)
        }
        cancelBtn.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(50)
        }
        onelineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(nameLabel.snp.bottom)
        }
        twolineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(cmmBtn.snp.bottom)
        }
        threelineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(5)
            make.top.equalTo(cancelBtn.snp.bottom)
        }
        
        cmmBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.cmmBlock?()
        }).disposed(by: disposeBag)
        
        deleteBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.deleteBlock?()
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RiskPopGroupView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.setTopCorners(radius: 5)
    }
    
}
