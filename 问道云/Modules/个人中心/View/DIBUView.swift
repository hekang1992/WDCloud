//
//  DIBUView.swift
//  问道云
//
//  Created by Andrew on 2025/3/20.
//

import UIKit

class DIBUView: BaseView {

    var quanxuanblock: (() -> Void)?
    
    var shanchublock: (() -> Void)?
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var quanxianBtn: UIButton = {
        let quanxianBtn = UIButton()
        quanxianBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        quanxianBtn.setTitle(" 全选", for: .normal)
        quanxianBtn.setImage(UIImage(named: "Checkb_sel"), for: .selected)
        quanxianBtn.setImage(UIImage(named: "Check_nor"), for: .normal)
        quanxianBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
        return quanxianBtn
    }()
    
    lazy var delBtn: UIButton = {
        let delBtn = UIButton()
        delBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        delBtn.setTitle("删除", for: .normal)
        delBtn.setTitleColor(UIColor.init(cssStr: "#F55B5B"), for: .normal)
        return delBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(quanxianBtn)
        bgView.addSubview(delBtn)
        bgView.snp.makeConstraints { make in
            make.height.equalTo(66)
            make.left.right.bottom.equalToSuperview()
        }
        quanxianBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 55.pix(), height: 22))
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(13.5)
        }
        delBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 48, height: 22))
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(13.5)
        }
        
        quanxianBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.quanxuanblock?()
        }).disposed(by: disposeBag)
        
        delBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.shanchublock?()
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
