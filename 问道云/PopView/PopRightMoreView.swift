//
//  PopRightMoreView.swift
//  问道云
//
//  Created by 何康 on 2025/3/18.
//

import UIKit

class PopRightMoreView: BaseView {
    
    var cancelBlock: (() -> Void)?
    var oneBlock: (() -> Void)?
    var twoBlock: (() -> Void)?
    var threeBlock: (() -> Void)?
    var fourBlock: (() -> Void)?
    var fiveBlock: (() -> Void)?
    var sixBlock: (() -> Void)?

    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .init(cssStr: "#F5F5F5")
        return bgView
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.titleLabel?.font = .regularFontOfSize(size: 16)
        cancelBtn.setTitleColor(.init(cssStr: "#27344B"), for: .normal)
        cancelBtn.backgroundColor = .white
        return cancelBtn
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setImage(UIImage(named: "moredaochu"), for: .normal)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setImage(UIImage(named: "morexiazai"), for: .normal)
        return twoBtn
    }()
    
    lazy var threeBtn: UIButton = {
        let threeBtn = UIButton(type: .custom)
        threeBtn.setImage(UIImage(named: "moreshujucuo"), for: .normal)
        return threeBtn
    }()
    
    lazy var fourBtn: UIButton = {
        let fourBtn = UIButton(type: .custom)
        fourBtn.setImage(UIImage(named: "morehomebac"), for: .normal)
        return fourBtn
    }()
    
    lazy var fiveBtn: UIButton = {
        let fiveBtn = UIButton(type: .custom)
        fiveBtn.setImage(UIImage(named: "moreweixin"), for: .normal)
        return fiveBtn
    }()
    
    lazy var sixBtn: UIButton = {
        let sixBtn = UIButton(type: .custom)
        sixBtn.setImage(UIImage(named: "moremore"), for: .normal)
        return sixBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(cancelBtn)
        bgView.addSubview(oneBtn)
        bgView.addSubview(twoBtn)
        bgView.addSubview(threeBtn)
        bgView.addSubview(fourBtn)
        bgView.addSubview(fiveBtn)
        bgView.addSubview(sixBtn)
        bgView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(255)
        }
        cancelBtn.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(68)
        }
        
        oneBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 45, height: 67.5))
            make.left.equalToSuperview().offset(18)
            make.bottom.equalTo(cancelBtn.snp.top).offset(-17)
        }
        twoBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 45, height: 67.5))
            make.left.equalTo(oneBtn.snp.right).offset(28.5.pix())
            make.bottom.equalTo(cancelBtn.snp.top).offset(-17)
        }
        threeBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 45, height: 67.5))
            make.left.equalTo(twoBtn.snp.right).offset(28.5.pix())
            make.bottom.equalTo(cancelBtn.snp.top).offset(-17)
        }
        fourBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 45, height: 67.5))
            make.left.equalTo(threeBtn.snp.right).offset(28.5.pix())
            make.bottom.equalTo(cancelBtn.snp.top).offset(-17)
        }
        fiveBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 45, height: 67.5))
            make.left.equalToSuperview().offset(18)
            make.bottom.equalTo(oneBtn.snp.top).offset(-16)
        }
        sixBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 45, height: 67.5))
            make.left.equalTo(fiveBtn.snp.right).offset(28.5.pix())
            make.bottom.equalTo(oneBtn.snp.top).offset(-16)
        }
        cancelBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.cancelBlock?()
        }).disposed(by: disposeBag)
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
        fiveBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.fiveBlock?()
        }).disposed(by: disposeBag)
        sixBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.sixBlock?()
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.setTopCorners(radius: 10)
    }
    
}

