//
//  PopOnlyBuyVipView.swift
//  问道云
//
//  Created by 何康 on 2025/4/10.
//

import UIKit

class PopOnlyBuyVipView: BaseView {
    
    var cancelBlock: (() -> Void)?
    var sureBlock: (() -> Void)?

    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.isUserInteractionEnabled = true
        ctImageView.image = UIImage(named: "onlybuymeis")
        return ctImageView
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        return cancelBtn
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        return sureBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ctImageView)
        ctImageView.addSubview(cancelBtn)
        ctImageView.addSubview(sureBtn)
        ctImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 265.pix(), height: 246.pix()))
        }
        cancelBtn.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 88.pix(), height: 60.pix()))
        }
        sureBtn.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 155.pix(), height: 60.pix()))
        }
        cancelBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.cancelBlock?()
        }).disposed(by: disposeBag)
        sureBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.sureBlock?()
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
