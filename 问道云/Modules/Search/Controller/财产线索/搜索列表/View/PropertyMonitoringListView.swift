//
//  PropertyMonitoringListView.swift
//  问道云
//
//  Created by 何康 on 2025/3/26.
//

import UIKit

class PropertyMonitoringListView: BaseView {
    
    var oneBlock: (() -> Void)?
    var twoBlock: (() -> Void)?
    var threeBlock: (() -> Void)?
    var fourBlock: (() -> Void)?
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        return twoBtn
    }()
    
    lazy var threeBtn: UIButton = {
        let threeBtn = UIButton(type: .custom)
        return threeBtn
    }()
    
    lazy var fourBtn: UIButton = {
        let fourBtn = UIButton(type: .custom)
        return fourBtn
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.isUserInteractionEnabled = true
        ctImageView.image = UIImage(named: "menupropertylineimgae")
        return ctImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ctImageView)
        ctImageView.addSubview(oneBtn)
        ctImageView.addSubview(twoBtn)
        ctImageView.addSubview(threeBtn)
        ctImageView.addSubview(fourBtn)
        ctImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        oneBtn.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(33)
        }
        twoBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(oneBtn.snp.bottom)
            make.height.equalTo(33)
        }
        threeBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(twoBtn.snp.bottom)
            make.height.equalTo(33)
        }
        fourBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(threeBtn.snp.bottom)
            make.height.equalTo(33)
        }
        
        oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.oneBlock?()
        }).disposed(by: disposeBag)
        twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.twoBlock?()
        }).disposed(by: disposeBag)
        threeBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.threeBlock?()
        }).disposed(by: disposeBag)
        fourBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.fourBlock?()
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
