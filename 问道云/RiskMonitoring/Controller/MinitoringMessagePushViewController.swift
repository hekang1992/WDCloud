//
//  MinitoringMessagePushViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/19.
//  监控消息通知

import UIKit
import SevenSwitch

class MinitoringMessagePushViewController: WDBaseViewController {
    
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
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
