//
//  PropertyFourViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/20.
//

import UIKit

class PropertyFourViewController: WDBaseViewController {
    
    var backBlock: (() -> Void)?

    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "我的"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setBackgroundImage(UIImage(named: "headrightoneicon"), for: .normal)
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
        oneView.namelabel.text = "监控设置"
        oneView.leftImageView.image = UIImage(named: "checksetimage")
        return oneView
    }()

    lazy var twoView: RiskSettingView = {
        let twoView = RiskSettingView()
        twoView.namelabel.text = "我的收藏"
        twoView.leftImageView.image = UIImage(named: "wodeshoucangiamge")
        return twoView
    }()
    
    lazy var threeView: RiskSettingView = {
        let threeView = RiskSettingView()
        threeView.namelabel.text = "权益使用记录"
        threeView.leftImageView.image = UIImage(named: "useimagepp")
        return threeView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        addHeadView(from: headView)
        headView.backBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.backBlock?()
        }).disposed(by: disposeBag)
        view.addSubview(ctImageView)
        view.addSubview(phoneLabel)
        view.addSubview(vipImageView)
        view.addSubview(lineView)
        view.addSubview(oneView)
        view.addSubview(twoView)
        view.addSubview(threeView)
        ctImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.equalTo(headView.snp.bottom).offset(12)
            make.size.equalTo(CGSize(width: 51, height: 51))
        }
        phoneLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.left.equalTo(ctImageView.snp.right).offset(14)
            make.centerY.equalTo(ctImageView.snp.centerY)
        }
        vipImageView.snp.makeConstraints { make in
            make.left.equalTo(phoneLabel.snp.right).offset(10)
            make.height.equalTo(13)
            make.centerY.equalTo(phoneLabel.snp.centerY)
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
        
        oneView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let settingVc = MyCheckSettingViewController()
                self.navigationController?.pushViewController(settingVc, animated: true)
        }).disposed(by: disposeBag)
        
        twoView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let myCollectionVc = MyCollectionPropertyViewController()
                self.navigationController?.pushViewController(myCollectionVc, animated: true)
        }).disposed(by: disposeBag)
                                                
        threeView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let useVc = MyVipUseViewController()
                self.navigationController?.pushViewController(useVc, animated: true)
        }).disposed(by: disposeBag)
        
        
        getVipInfo()
    }

}

extension PropertyFourViewController {
    
    private func getVipInfo() {
        
        let man = RequestManager()
        
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/enterpriseclientbm/buymoreinfo",
                       method: .get) { [weak self] result in
            
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
