//
//  PropertyLineSearchMoreView.swift
//  问道云
//
//  Created by Andrew on 2025/3/23.
//

import UIKit

class PropertyLineSearchMoreView: BaseView {
    
    var buttons: [UIButton] = []
    
    var timebuttons: [UIButton] = []
    
    var selectIndex: Int = 0
    
    var selectBtn: UIButton?
    
    var selectmBtn: UIButton?
    
    var sureBlock: ((String, String, String) -> Void)?
    
    var timeStr: String = ""
    
    var stimeStr: String = ""
    
    var etimeStr: String = ""

    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.text = "预估价值"
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
        oneBtn.setTitle("1万以下", for: .normal)
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
        twoBtn.setTitle("1-10万", for: .normal)
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
        threeBtn.setTitle("10-100万", for: .normal)
        threeBtn.setTitleColor(.init(cssStr: "#666666"), for: .normal)
        threeBtn.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.3)
        threeBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        threeBtn.layer.cornerRadius = 2
        threeBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        threeBtn.tag = 103
        return threeBtn
    }()
    
    lazy var fourBtn: UIButton = {
        let threeBtn = UIButton(type: .custom)
        threeBtn.setTitle("100万以上", for: .normal)
        threeBtn.setTitleColor(.init(cssStr: "#666666"), for: .normal)
        threeBtn.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.3)
        threeBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        threeBtn.layer.cornerRadius = 2
        threeBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        threeBtn.tag = 103
        return threeBtn
    }()
    
    
    lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.text = "更新时间"
        moneyLabel.textColor = .init(cssStr: "#333333")
        moneyLabel.font = .boldFontOfSize(size: 13)
        moneyLabel.textAlignment = .left
        return moneyLabel
    }()
    
    lazy var bothmBtn: UIButton = {
        let bothmBtn = UIButton(type: .custom)
        bothmBtn.setTitle("全部", for: .normal)
        bothmBtn.setTitleColor(.init(cssStr: "#666666"), for: .normal)
        bothmBtn.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.3)
        bothmBtn.titleLabel?.font = .regularFontOfSize(size: 13)
        bothmBtn.layer.cornerRadius = 2
        bothmBtn.addTarget(self, action: #selector(buttonmTapped(_:)), for: .touchUpInside)
        return bothmBtn
    }()
    
    lazy var onemBtn: UIButton = {
        let onemBtn = UIButton(type: .custom)
        onemBtn.setTitle("今天", for: .normal)
        onemBtn.setTitleColor(.init(cssStr: "#666666"), for: .normal)
        onemBtn.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.3)
        onemBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        onemBtn.layer.cornerRadius = 2
        onemBtn.addTarget(self, action: #selector(buttonmTapped(_:)), for: .touchUpInside)
        return onemBtn
    }()
    
    lazy var twomBtn: UIButton = {
        let twomBtn = UIButton(type: .custom)
        twomBtn.setTitle("近一周", for: .normal)
        twomBtn.setTitleColor(.init(cssStr: "#666666"), for: .normal)
        twomBtn.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.3)
        twomBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        twomBtn.layer.cornerRadius = 2
        twomBtn.addTarget(self, action: #selector(buttonmTapped(_:)), for: .touchUpInside)
        return twomBtn
    }()
    
    lazy var threemBtn: UIButton = {
        let threemBtn = UIButton(type: .custom)
        threemBtn.setTitle("近一月", for: .normal)
        threemBtn.setTitleColor(.init(cssStr: "#666666"), for: .normal)
        threemBtn.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.3)
        threemBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        threemBtn.layer.cornerRadius = 2
        threemBtn.addTarget(self, action: #selector(buttonmTapped(_:)), for: .touchUpInside)
        return threemBtn
    }()
    
    lazy var fourmBtn: UIButton = {
        let fourmBtn = UIButton(type: .custom)
        fourmBtn.setTitle("近一年", for: .normal)
        fourmBtn.setTitleColor(.init(cssStr: "#666666"), for: .normal)
        fourmBtn.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.3)
        fourmBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        fourmBtn.layer.cornerRadius = 2
        fourmBtn.addTarget(self, action: #selector(buttonmTapped(_:)), for: .touchUpInside)
        return fourmBtn
    }()
    
    lazy var grayView: UIView = {
        let grayView = UIView()
        grayView.backgroundColor = .init(cssStr: "#F1F1F1")
        return grayView
    }()
    
    lazy var startBtn: UIButton = {
        let startBtn = UIButton(type: .custom)
        startBtn.layer.cornerRadius = 2
        startBtn.layer.masksToBounds = true
        startBtn.setTitle("开始日期", for: .normal)
        startBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
        startBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        return startBtn
    }()
    
    lazy var endBtn: UIButton = {
        let endBtn = UIButton(type: .custom)
        endBtn.layer.cornerRadius = 2
        endBtn.layer.masksToBounds = true
        endBtn.setTitle("结束日期", for: .normal)
        endBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
        endBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        return endBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#9FA4AD")
        return lineView
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
        bgView.addSubview(fourBtn)
        
        bgView.addSubview(moneyLabel)
        bgView.addSubview(bothmBtn)
        bgView.addSubview(onemBtn)
        bgView.addSubview(twomBtn)
        bgView.addSubview(threemBtn)
        bgView.addSubview(fourmBtn)
        
        bgView.addSubview(grayView)
        grayView.addSubview(lineView)
        grayView.addSubview(startBtn)
        grayView.addSubview(endBtn)
        
        bgView.addSubview(cancelBtn)
        bgView.addSubview(sureBtn)
        bgView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(250)
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(15)
        }
        bothBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(descLabel.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width: 50, height: 30))
        }
        oneBtn.snp.makeConstraints { make in
            make.left.equalTo(bothBtn.snp.right).offset(5)
            make.centerY.equalTo(bothBtn.snp.centerY)
            make.size.equalTo(CGSize(width: 60, height: 30))
        }
        twoBtn.snp.makeConstraints { make in
            make.left.equalTo(oneBtn.snp.right).offset(5)
            make.centerY.equalTo(bothBtn.snp.centerY)
            make.size.equalTo(CGSize(width: 60, height: 30))
        }
        threeBtn.snp.makeConstraints { make in
            make.left.equalTo(twoBtn.snp.right).offset(5)
            make.centerY.equalTo(bothBtn.snp.centerY)
            make.size.equalTo(CGSize(width: 70, height: 30))
        }
        fourBtn.snp.makeConstraints { make in
            make.left.equalTo(threeBtn.snp.right).offset(5)
            make.centerY.equalTo(bothBtn.snp.centerY)
            make.size.equalTo(CGSize(width: 70, height: 30))
        }
        
        moneyLabel.snp.makeConstraints { make in
            make.top.equalTo(fourBtn.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(15)
        }
        bothmBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(moneyLabel.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width: 50, height: 30))
        }
        onemBtn.snp.makeConstraints { make in
            make.left.equalTo(bothmBtn.snp.right).offset(5)
            make.centerY.equalTo(bothmBtn.snp.centerY)
            make.size.equalTo(CGSize(width: 60, height: 30))
        }
        twomBtn.snp.makeConstraints { make in
            make.left.equalTo(onemBtn.snp.right).offset(5)
            make.centerY.equalTo(bothmBtn.snp.centerY)
            make.size.equalTo(CGSize(width: 60, height: 30))
        }
        threemBtn.snp.makeConstraints { make in
            make.left.equalTo(twomBtn.snp.right).offset(5)
            make.centerY.equalTo(bothmBtn.snp.centerY)
            make.size.equalTo(CGSize(width: 70, height: 30))
        }
        fourmBtn.snp.makeConstraints { make in
            make.left.equalTo(threemBtn.snp.right).offset(5)
            make.centerY.equalTo(bothmBtn.snp.centerY)
            make.size.equalTo(CGSize(width: 70, height: 30))
        }
        
        grayView.snp.makeConstraints { make in
            make.left.equalTo(bothBtn.snp.left)
            make.top.equalTo(fourmBtn.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width: 195, height: 25))
        }
        lineView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 10, height: 1))
        }
        startBtn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.right.equalTo(lineView.snp.left)
        }
        endBtn.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.left.equalTo(lineView.snp.right)
        }
        
        
        buttons = [bothBtn, oneBtn, twoBtn, threeBtn, fourBtn]
        
        timebuttons = [bothmBtn, onemBtn, twomBtn, threemBtn, fourmBtn]
        
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
            self?.resetBtnmInfo()
        }).disposed(by: disposeBag)
        
        sureBtn.rx.tap.subscribe(onNext: { [weak self] in
            let stimeStr = self?.stimeStr ?? ""
            let etimeStr = self?.etimeStr ?? ""
            if !stimeStr.isEmpty && !etimeStr.isEmpty {
                self?.timeStr = stimeStr + "-" + etimeStr
            }else if !stimeStr.isEmpty && etimeStr.isEmpty {
                ToastViewConfig.showToast(message: "时间格式不正确,请重新选择")
                return
            }else if stimeStr.isEmpty && !etimeStr.isEmpty {
                ToastViewConfig.showToast(message: "时间格式不正确,请重新选择")
                return
            }
            let money = self?.selectIndex ?? 0
            if money == 0 {
                self?.sureBlock?("", self?.timeStr ?? "", self?.selectBtn?.titleLabel?.text ?? "")
            }else {
                self?.sureBlock?(String(money), self?.timeStr ?? "", self?.selectBtn?.titleLabel?.text ?? "")
            }
            print("one====\(self?.selectIndex ?? 0)")
            print("two====\(self?.timeStr ?? "")")
        }).disposed(by: disposeBag)
        
        startBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let vc = ViewControllerUtils.findViewController(from: self)
            vc?.getPopTimeDatePicker(completion: { time in
                self.startBtn.setTitle(time, for: .normal)
                self.startBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
                self.timeStr = ""
                self.stimeStr = time ?? ""
                for button in self.timebuttons {
                    button.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.2)
                    button.setTitleColor(.init(cssStr: "#666666"), for: .normal)
                }
            })
        }).disposed(by: disposeBag)
        
        endBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let vc = ViewControllerUtils.findViewController(from: self)
            vc?.getPopTimeDatePicker(completion: { time in
                self.endBtn.setTitle(time, for: .normal)
                self.endBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
                self.timeStr = ""
                self.etimeStr = time ?? ""
                for button in self.timebuttons {
                    button.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.2)
                    button.setTitleColor(.init(cssStr: "#666666"), for: .normal)
                }
            })
        }).disposed(by: disposeBag)
        buttonTapped(self.selectBtn ?? UIButton())
        buttonmTapped(self.selectmBtn ?? UIButton())
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PropertyLineSearchMoreView {
    
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
    
    @objc func buttonmTapped(_ sender: UIButton) {
        resetBtnmInfo()
        sender.backgroundColor = .init(cssStr: "#547AFF")
        sender.setTitleColor(.white, for: .normal)
        let title = sender.titleLabel?.text ?? ""
        if title == "全部" {
            self.timeStr = ""
        }else if title == "今天" {
            self.timeStr = "day"
        }else if title == "近一周" {
            self.timeStr = "week"
        }else if title == "近一月" {
            self.timeStr = "month"
        }else if title == "近一年" {
            self.timeStr = "year"
        }else {
            
        }
        self.stimeStr = ""
        self.etimeStr = ""
        startBtn.setTitle("开始日期", for: .normal)
        startBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
        endBtn.setTitle("结束日期", for: .normal)
        endBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
        self.selectmBtn = sender
    }
    
    private func resetBtnmInfo() {
        for button in timebuttons {
            button.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.2)
            button.setTitleColor(.init(cssStr: "#666666"), for: .normal)
        }
        self.timeStr = ""
        startBtn.setTitle("开始日期", for: .normal)
        startBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
        endBtn.setTitle("结束日期", for: .normal)
        endBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
    }
    
}
