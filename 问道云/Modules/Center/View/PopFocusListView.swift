//
//  PopFocusListView.swift
//  问道云
//
//  Created by 何康 on 2025/3/26.
//

import UIKit

class PopFocusListView: BaseView {
    
    var oneBlock: (() -> Void)?
    var twoBlock: (() -> Void)?
    var threeBlock: (() -> Void)?
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .black.withAlphaComponent(0.45)
        return bgView
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
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.isUserInteractionEnabled = true
        ctImageView.image = UIImage(named: "fafdkiofocns")
        return ctImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(ctImageView)
        ctImageView.addSubview(oneBtn)
        ctImageView.addSubview(twoBtn)
        ctImageView.addSubview(threeBtn)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(1)
            make.right.equalToSuperview().offset(-5)
            make.size.equalTo(CGSize(width: 70.pix(), height: 104.pix()))
        }
        oneBtn.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(35)
        }
        twoBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(oneBtn.snp.bottom)
            make.height.equalTo(35)
        }
        threeBtn.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(twoBtn.snp.bottom)
            make.height.equalTo(35)
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
        
        bgView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            self?.removeFromSuperview()
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
