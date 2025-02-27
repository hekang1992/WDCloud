//
//  MinitoringMessagePushViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/19.
//  监控消息通知

import UIKit
import SevenSwitch
import BRPickerView

class MinitoringMessagePushViewController: WDBaseViewController {
    
    var leftDate: Date?
    var rightDate: Date?
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "监控动态消息通知"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        return headView
    }()
    
    lazy var oneView: UIView = {
        let oneView = UIView()
        oneView.backgroundColor = .white
        return oneView
    }()
    
    lazy var twoView: UIView = {
        let twoView = UIView()
        twoView.backgroundColor = .white
        return twoView
    }()
    
    lazy var threeView: UIView = {
        let threeView = UIView()
        threeView.backgroundColor = .white
        return threeView
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.text = "事件推送设置"
        oneLabel.textAlignment = .left
        oneLabel.textColor = .init(cssStr: "#333333")
        oneLabel.font = .mediumFontOfSize(size: 13)
        return oneLabel
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
    
    lazy var label1: UILabel = {
        let oneLabel = UILabel()
        oneLabel.text = "风险事件消息"
        oneLabel.textAlignment = .left
        oneLabel.textColor = .init(cssStr: "#333333")
        oneLabel.font = .regularFontOfSize(size: 12)
        return oneLabel
    }()
    
    lazy var label2: UILabel = {
        let oneLabel = UILabel()
        oneLabel.text = "舆情动态消息"
        oneLabel.textAlignment = .left
        oneLabel.textColor = .init(cssStr: "#333333")
        oneLabel.font = .regularFontOfSize(size: 12)
        return oneLabel
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "righticonimage")
        return ctImageView
    }()
    
    lazy var ctImageView1: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "righticonimage")
        return ctImageView
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.text = "推送时间"
        timeLabel.textAlignment = .left
        timeLabel.textColor = .init(cssStr: "#333333")
        timeLabel.font = .mediumFontOfSize(size: 13)
        return timeLabel
    }()
    
    lazy var threelineView: UIView = {
        let threelineView = UIView()
        threelineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return threelineView
    }()
    
    lazy var label3: UILabel = {
        let label3 = UILabel()
        label3.text = "每日接收动态消息的时间："
        label3.textAlignment = .left
        label3.textColor = .init(cssStr: "#666666")
        label3.font = .regularFontOfSize(size: 12)
        return label3
    }()
    
    lazy var label4: UILabel = {
        let label4 = UILabel()
        label4.text = "在该时间段外新增的动态将不会再推送，请设定更大范围的时间段或者直接查看监控日报"
        label4.textAlignment = .left
        label4.textColor = .init(cssStr: "#9FA4AD")
        label4.font = .regularFontOfSize(size: 11)
        label4.numberOfLines = 0
        return label4
    }()
    
    lazy var pushLabel: UILabel = {
        let pushLabel = UILabel()
        pushLabel.text = "推送方式"
        pushLabel.textAlignment = .left
        pushLabel.textColor = .init(cssStr: "#333333")
        pushLabel.font = .mediumFontOfSize(size: 13)
        return pushLabel
    }()
    
    lazy var pushLabel1: UILabel = {
        let pushLabel = UILabel()
        pushLabel.text = "平台推送"
        pushLabel.textAlignment = .left
        pushLabel.textColor = .init(cssStr: "#333333")
        pushLabel.font = .regularFontOfSize(size: 12)
        return pushLabel
    }()
    
    lazy var pushLabel2: UILabel = {
        let pushLabel = UILabel()
        pushLabel.text = "实时推送监控动态至APP端的消息中心"
        pushLabel.textAlignment = .left
        pushLabel.textColor = .init(cssStr: "#9FA4AD")
        pushLabel.font = .regularFontOfSize(size: 11)
        return pushLabel
    }()
    
    lazy var fourlineView: UIView = {
        let fourlineView = UIView()
        fourlineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return fourlineView
    }()
    
    lazy var oneSwitch: SevenSwitch = {
        let oneSwitch = SevenSwitch()
        oneSwitch.on = true
        oneSwitch.onTintColor = .init(cssStr: "#547AFF")!
        return oneSwitch
    }()
    
    lazy var zlabel: UILabel = {
        let zlabel = UILabel()
        zlabel.text = "上午"
        zlabel.textColor = .init(cssStr: "#666666")
        zlabel.textAlignment = .left
        zlabel.font = .regularFontOfSize(size: 13)
        return zlabel
    }()
    
    lazy var xlabel: UILabel = {
        let xlabel = UILabel()
        xlabel.text = "下午"
        xlabel.textColor = .init(cssStr: "#666666")
        xlabel.textAlignment = .left
        xlabel.font = .regularFontOfSize(size: 13)
        return xlabel
    }()
    
    lazy var zbtn: UIButton = {
        let zbtn = UIButton(type: .custom)
        zbtn.backgroundColor = .init(cssStr: "#F3F3F3")
        zbtn.layer.cornerRadius = 2.5
        zbtn.titleLabel?.font = .regularFontOfSize(size: 13)
        zbtn.setTitleColor(.init(cssStr: "#333333"), for: .normal)
        return zbtn
    }()
    
    lazy var mmlabel: UILabel = {
        let mmlabel = UILabel()
        mmlabel.text = "~"
        mmlabel.textAlignment = .center
        mmlabel.textColor = .init(cssStr: "#666666")
        mmlabel.font = .regularFontOfSize(size: 20)
        return mmlabel
    }()
    
    lazy var xbtn: UIButton = {
        let xbtn = UIButton(type: .custom)
        xbtn.backgroundColor = .init(cssStr: "#F3F3F3")
        xbtn.layer.cornerRadius = 2.5
        xbtn.titleLabel?.font = .regularFontOfSize(size: 13)
        xbtn.setTitleColor(.init(cssStr: "#333333"), for: .normal)
        return xbtn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(oneView)
        oneView.addSubview(oneLabel)
        oneView.addSubview(label1)
        oneView.addSubview(label2)
        oneView.addSubview(onelineView)
        oneView.addSubview(twolineView)
        oneView.addSubview(ctImageView)
        oneView.addSubview(ctImageView1)
        
        view.addSubview(twoView)
        twoView.addSubview(timeLabel)
        twoView.addSubview(threelineView)
        twoView.addSubview(label3)
        twoView.addSubview(label4)
        twoView.addSubview(zlabel)
        twoView.addSubview(xlabel)
        twoView.addSubview(zbtn)
        twoView.addSubview(mmlabel)
        twoView.addSubview(xbtn)
        
        view.addSubview(threeView)
        threeView.addSubview(pushLabel)
        threeView.addSubview(fourlineView)
        threeView.addSubview(pushLabel1)
        threeView.addSubview(pushLabel2)
        threeView.addSubview(oneSwitch)
        
        oneView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(141)
        }
        oneLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(14)
            make.height.equalTo(20)
        }
        onelineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalToSuperview().offset(46.5)
        }
        twolineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(onelineView.snp.bottom).offset(46.5)
        }
        label1.snp.makeConstraints { make in
            make.top.equalTo(onelineView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(14)
            make.height.equalTo(16)
        }
        label2.snp.makeConstraints { make in
            make.top.equalTo(twolineView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(14)
            make.height.equalTo(16)
        }
        ctImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 21, height: 21))
            make.centerY.equalTo(label1.snp.centerY)
            make.right.equalToSuperview().offset(-18)
        }
        ctImageView1.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 21, height: 21))
            make.centerY.equalTo(label2.snp.centerY)
            make.right.equalToSuperview().offset(-18)
        }
        
        twoView.snp.makeConstraints { make in
            make.top.equalTo(oneView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(125)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(14)
            make.height.equalTo(20)
        }
        threelineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalToSuperview().offset(46.5)
        }
        label3.snp.makeConstraints { make in
            make.top.equalTo(threelineView.snp.bottom).offset(13.5)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(20)
        }
        label4.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(label3.snp.bottom).offset(6.5)
            make.left.equalTo(label3.snp.left)
        }
        zlabel.snp.makeConstraints { make in
            make.centerY.equalTo(label3.snp.centerY)
            make.left.equalTo(label3.snp.right).offset(5)
            make.size.equalTo(CGSize(width: 26.pix(), height: 20))
        }
        zbtn.snp.makeConstraints { make in
            make.centerY.equalTo(zlabel.snp.centerY)
            make.left.equalTo(zlabel.snp.right)
            make.size.equalTo(CGSize(width: 43, height: 27))
        }
        mmlabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 15, height: 20))
            make.left.equalTo(zbtn.snp.right).offset(8)
            make.centerY.equalTo(zbtn.snp.centerY)
        }
        xlabel.snp.makeConstraints { make in
            make.centerY.equalTo(label3.snp.centerY)
            make.left.equalTo(mmlabel.snp.right).offset(5)
            make.size.equalTo(CGSize(width: 28.pix(), height: 20))
        }
        xbtn.snp.makeConstraints { make in
            make.centerY.equalTo(xlabel.snp.centerY)
            make.left.equalTo(xlabel.snp.right)
            make.size.equalTo(CGSize(width: 43, height: 27))
        }
        
        threeView.snp.makeConstraints { make in
            make.top.equalTo(twoView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(108)
        }
        pushLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(14)
            make.height.equalTo(20)
        }
        fourlineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalToSuperview().offset(46.5)
        }
        pushLabel1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(fourlineView.snp.bottom).offset(15)
            make.height.equalTo(16.5)
        }
        pushLabel2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(pushLabel1.snp.bottom)
            make.height.equalTo(20)
        }
        oneSwitch.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 20))
            make.top.equalTo(fourlineView.snp.bottom).offset(21)
            make.right.equalToSuperview().offset(-18)
        }
        
        
        oneView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let soVc = MonitoringSolutionViewController()
                self.navigationController?.pushViewController(soVc, animated: true)
        }).disposed(by: disposeBag)
        
        zbtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            showDatePicker(from: zbtn)
        }).disposed(by: disposeBag)
        
        xbtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            showxDatePicker(from: xbtn)
        }).disposed(by: disposeBag)
        
    }
    
}

extension MinitoringMessagePushViewController {
    
    func showDatePicker(from btn: UIButton) {
        let datePickerView = BRDatePickerView()
        datePickerView.pickerMode = .HM
        datePickerView.title = "选择时间"
        datePickerView.isAutoSelect = true
        datePickerView.isTwelveHourMode = true
        datePickerView.selectDate = NSDate.br_setHour(9, minute: 0)
        datePickerView.timeZone = TimeZone(identifier: "Asia/Shanghai")
        if let leftDate = self.leftDate {
            datePickerView.selectDate = leftDate
        }
        datePickerView.resultBlock = { selectDate, selectValue in
            btn.setTitle(selectValue ?? "", for: .normal)
            self.leftDate = selectDate
        }
        
        let customStyle = BRPickerStyle()
        customStyle.pickerColor = .white
        customStyle.pickerTextFont = .regularFontOfSize(size: 16)
        customStyle.selectRowTextColor = .black
        datePickerView.pickerStyle = customStyle
        datePickerView.show()
    }
    
    func showxDatePicker(from btn: UIButton) {
        let datePickerView = BRDatePickerView()
        datePickerView.pickerMode = .HM
        datePickerView.minDate = NSDate.br_setHour(13, minute: 0)
        datePickerView.maxDate = NSDate.br_setHour(23, minute: 59)
        datePickerView.title = "选择时间"
        datePickerView.isAutoSelect = true
        datePickerView.timeZone = TimeZone(identifier: "Asia/Shanghai")
        if let rightDate = self.rightDate {
            datePickerView.selectDate = rightDate
        }
        datePickerView.resultBlock = { selectDate, selectValue in
            btn.setTitle(selectValue ?? "", for: .normal)
            self.rightDate = selectDate
        }
        let customStyle = BRPickerStyle()
        customStyle.pickerColor = .white
        customStyle.pickerTextFont = .regularFontOfSize(size: 16)
        customStyle.selectRowTextColor = .black
        datePickerView.pickerStyle = customStyle
        

        datePickerView.show()
    }
    
    
}
