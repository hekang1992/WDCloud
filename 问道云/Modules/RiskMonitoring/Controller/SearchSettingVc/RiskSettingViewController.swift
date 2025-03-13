//
//  RiskSettingViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/14.
//

import UIKit

class RiskSettingViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "监控设置"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        return headView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "centericon")
        return ctImageView
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.textAlignment = .left
        phoneLabel.textColor = .init(cssStr: "#333333")
        phoneLabel.font = .mediumFontOfSize(size: 14)
        let phone = GetSaveLoginInfoConfig.getPhoneNumber()
        phoneLabel.text = PhoneNumberFormatter.formatPhoneNumber(phoneNumber: phone)
        return phoneLabel
    }()
    
    lazy var vipImageView: UIImageView = {
        let vipImageView = UIImageView()
        return vipImageView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var oneView: RiskSettingView = {
        let oneView = RiskSettingView()
        oneView.namelabel.text = "监控方案"
        oneView.leftImageView.image = UIImage(named: "jiankongganganiamge")
        return oneView
    }()

    lazy var twoView: RiskSettingView = {
        let twoView = RiskSettingView()
        twoView.namelabel.text = "监控分组"
        twoView.leftImageView.image = UIImage(named: "fenzuxingimage")
        return twoView
    }()
    
    lazy var threeView: RiskSettingView = {
        let threeView = RiskSettingView()
        threeView.namelabel.text = "消息通知"
        threeView.leftImageView.image = UIImage(named: "pushiamgejfa")
        return threeView
    }()
    
    lazy var fourView: RiskSettingView = {
        let fourView = RiskSettingView()
        fourView.namelabel.text = "微信订阅监控通知"
        fourView.leftImageView.image = UIImage(named: "weixinwechimge")
        return fourView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        addHeadView(from: headView)
        view.addSubview(ctImageView)
        view.addSubview(phoneLabel)
        view.addSubview(vipImageView)
        view.addSubview(lineView)
        view.addSubview(oneView)
        view.addSubview(twoView)
        view.addSubview(threeView)
        view.addSubview(fourView)
        ctImageView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(18)
            make.size.equalTo(CGSize(width: 55, height: 55))
        }
        phoneLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(headView.snp.bottom).offset(16)
            make.left.equalTo(ctImageView.snp.right).offset(14)
        }
        vipImageView.snp.makeConstraints { make in
            make.left.equalTo(phoneLabel.snp.left)
            make.height.equalTo(13)
            make.top.equalTo(phoneLabel.snp.bottom).offset(14)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(5)
            make.top.equalTo(ctImageView.snp.bottom).offset(12)
        }
        oneView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(lineView.snp.bottom)
        }
        twoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(oneView.snp.bottom)
        }
        threeView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(twoView.snp.bottom)
        }
        fourView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(threeView.snp.bottom)
        }
        oneView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let monVc = MonitoringSolutionViewController()
                self?.navigationController?.pushViewController(monVc, animated: true)
        }).disposed(by: disposeBag)
        
        twoView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let addVc = RiskAddRiskGroupViewViewController()
                self?.navigationController?.pushViewController(addVc, animated: true)
        }).disposed(by: disposeBag)
        
        threeView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let messageVc = MinitoringMessagePushViewController()
                self?.navigationController?.pushViewController(messageVc, animated: true)
        }).disposed(by: disposeBag)
        
        //获取会员等级信息
        getVipInfo()
    }

}

/** 网络数据请求 */
extension RiskSettingViewController {
    
    private func getVipInfo() {
        ViewHud.addLoadView()
        let man = RequestManager()
        ViewHud.addLoadView()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/enterpriseclientbm/buymoreinfo",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    let userIdentity = model.userIdentity ?? ""
                    if userIdentity == "2" {//vip
                        vipImageView.image = UIImage(named: "levelvipimage")
                    } else if userIdentity == "3" {//svip
                        vipImageView.image = UIImage(named: "leveLsvipimage")
                    } else {//normal
                        vipImageView.image = UIImage(named: "levelnormal")
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
