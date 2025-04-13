//
//  PopBuyVipView.swift
//  问道云
//
//  Created by Andrew on 2025/2/28.
//

import UIKit

class PopBuyVipView: BaseView {
    
    var buyOneBlock: (() -> Void)?
    var buyVipBlock: (() -> Void)?
    var cancelBlock: (() -> Void)?

    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.isUserInteractionEnabled = true
        bgImageView.image = UIImage(named: "buyvipimage")
        return bgImageView
    }()
    
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        bgImageView.addSubview(oneBtn)
        bgImageView.addSubview(twoBtn)
        bgImageView.addSubview(threeBtn)
        bgImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 261.pix(), height: 257.pix()))
        }
        threeBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(40.pix())
        }
        twoBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(threeBtn.snp.top)
            make.left.equalToSuperview()
            make.height.equalTo(40.pix())
        }
        oneBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(twoBtn.snp.top)
            make.left.equalToSuperview()
            make.height.equalTo(40.pix())
        }
        threeBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.cancelBlock?()
        }).disposed(by: disposeBag)
        
        twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.buyOneBlock?()
        }).disposed(by: disposeBag)
        
        oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.buyVipBlock?()
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
