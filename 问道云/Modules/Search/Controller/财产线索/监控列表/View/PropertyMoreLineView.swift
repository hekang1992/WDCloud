//
//  PropertyMoreLineView.swift
//  问道云
//
//  Created by 何康 on 2025/3/22.
//

import UIKit

class PropertyMoreLineView: BaseView {
    
    var buttons: [UIButton] = []
    
    var selectIndex: Int = 0
    
    var selectBtn: UIButton?
    
    var sureBlock: ((UIButton ,Int) -> Void)?

    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.text = "注册资本"
        descLabel.textColor = .init(cssStr: "#333333")
        descLabel.font = .boldFontOfSize(size: 13)
        descLabel.textAlignment = .left
        return descLabel
    }()
    
    lazy var bothBtn: UIButton = {
        let bothBtn = UIButton(type: .custom)
        bothBtn.setTitle("全部", for: .normal)
        bothBtn.setTitleColor(.init(cssStr: "#666666"), for: .normal)
        bothBtn.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.3)
        bothBtn.titleLabel?.font = .regularFontOfSize(size: 13)
        bothBtn.layer.cornerRadius = 2
        bothBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        bothBtn.tag = 100
        return bothBtn
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setTitle("500-1000万", for: .normal)
        oneBtn.setTitleColor(.init(cssStr: "#666666"), for: .normal)
        oneBtn.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.3)
        oneBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        oneBtn.layer.cornerRadius = 2
        oneBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        oneBtn.tag = 101
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setTitle("1000-3000万", for: .normal)
        twoBtn.setTitleColor(.init(cssStr: "#666666"), for: .normal)
        twoBtn.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.3)
        twoBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        twoBtn.layer.cornerRadius = 2
        twoBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        twoBtn.tag = 102
        return twoBtn
    }()
    
    lazy var threeBtn: UIButton = {
        let threeBtn = UIButton(type: .custom)
        threeBtn.setTitle("5000万以上", for: .normal)
        threeBtn.setTitleColor(.init(cssStr: "#666666"), for: .normal)
        threeBtn.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.3)
        threeBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        threeBtn.layer.cornerRadius = 2
        threeBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        threeBtn.tag = 103
        return threeBtn
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setTitle("重置", for: .normal)
        cancelBtn.backgroundColor = .init(cssStr: "#EEF2FF")
        cancelBtn.layer.cornerRadius = 4
        cancelBtn.setTitleColor(.init(cssStr: "#547AFF"), for: .normal)
        cancelBtn.titleLabel?.font = .mediumFontOfSize(size: 15)
        return cancelBtn
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.backgroundColor = .init(cssStr: "#547AFF")
        sureBtn.layer.cornerRadius = 4
        sureBtn.setTitleColor(.init(cssStr: "#FFFFFF"), for: .normal)
        sureBtn.titleLabel?.font = .mediumFontOfSize(size: 15)
        return sureBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(descLabel)
        bgView.addSubview(bothBtn)
        bgView.addSubview(oneBtn)
        bgView.addSubview(twoBtn)
        bgView.addSubview(threeBtn)
        bgView.addSubview(cancelBtn)
        bgView.addSubview(sureBtn)
        bgView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(150)
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(15)
        }
        bothBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(descLabel.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width: 50, height: 32))
        }
        oneBtn.snp.makeConstraints { make in
            make.left.equalTo(bothBtn.snp.right).offset(5)
            make.centerY.equalTo(bothBtn.snp.centerY)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        twoBtn.snp.makeConstraints { make in
            make.left.equalTo(oneBtn.snp.right).offset(5)
            make.centerY.equalTo(bothBtn.snp.centerY)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        threeBtn.snp.makeConstraints { make in
            make.left.equalTo(twoBtn.snp.right).offset(5)
            make.centerY.equalTo(bothBtn.snp.centerY)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        buttons = [bothBtn, oneBtn, twoBtn, threeBtn]
        
        cancelBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-13.5)
            make.left.equalToSuperview().offset(11.5)
            make.size.equalTo(CGSize(width: 173.pix(), height: 42))
        }
        
        sureBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-13.5)
            make.right.equalToSuperview().offset(-11.5)
            make.size.equalTo(CGSize(width: 173.pix(), height: 42))
        }
        
        cancelBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.resetBtnInfo()
        }).disposed(by: disposeBag)
        
        sureBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.sureBlock?(self?.selectBtn ?? UIButton(), self?.selectIndex ?? 0)
        }).disposed(by: disposeBag)
        
        buttonTapped(self.selectBtn ?? UIButton())
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PropertyMoreLineView {
    
    @objc func buttonTapped(_ sender: UIButton) {
        resetBtnInfo()
        sender.backgroundColor = .init(cssStr: "#547AFF")
        sender.setTitleColor(.white, for: .normal)
        let index = sender.tag
        self.selectIndex = index - 100
        self.selectBtn = sender
    }
    
    private func resetBtnInfo() {
        for button in buttons {
            button.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.2)
            button.setTitleColor(.init(cssStr: "#666666"), for: .normal)
        }
        self.selectIndex = 0
        self.selectBtn = bothBtn
    }
    
}
