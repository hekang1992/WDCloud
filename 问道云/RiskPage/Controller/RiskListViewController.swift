//
//  RiskListViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/13.
//

import UIKit

class RiskListViewController: WDBaseViewController {
    
    var time: String = ""//today week month ""
    
    lazy var iconImageView1: UIImageView = {
        let iconImageView1 = UIImageView()
        iconImageView1.image = UIImage(named: "wendaoimage1")
        return iconImageView1
    }()
    
    lazy var iconImageView2: UIImageView = {
        let iconImageView2 = UIImageView()
        iconImageView2.image = UIImage(named: "riskiamgewendaore")
        return iconImageView2
    }()
    
    lazy var iconImageView3: UIImageView = {
        let iconImageView3 = UIImageView()
        iconImageView3.isUserInteractionEnabled = true
        iconImageView3.image = UIImage(named: "loginiamgerisk")
        return iconImageView3
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if !IS_LOGIN {
            self.noLoginUI()
        }
        
    }
    
}

extension RiskListViewController {
    
    //获取监控企业列表
    func getMonitoringCompanyInfo() {
        ViewHud.addLoadView()
        let dict = ["time": time]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/riskmonitor/riskmonitoring/monitoringEnterprises",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if let self = self, let model = success.data {
                    let total = model.total ?? 0
                    if total == 0 {
                        //去添加
                        goAddMonitoringCompanyUI()
                    }else {
                        
                    }
                }
                break
            case .failure(let failure):
                break
            }
        }
    }
    
    //获取监控人员列表
    func getMonitoringPeopleInfo() {
        ViewHud.addLoadView()
        let dict = ["time": time]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/riskmonitor/riskmonitoring/monitorPerson",
                       method: .get) { result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
                break
            }
        }
    }
    
    private func noLoginUI() {
        view.addSubview(iconImageView1)
        view.addSubview(iconImageView2)
        view.addSubview(iconImageView3)
        iconImageView1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset((SCREEN_WIDTH - 341) * 0.5)
            make.top.equalToSuperview().offset(18.5)
            make.size.equalTo(CGSize(width: 341, height: 108))
        }
        iconImageView2.snp.makeConstraints { make in
            make.centerX.equalTo(iconImageView1.snp.centerX)
            make.top.equalTo(iconImageView1.snp.bottom).offset(18.5)
            make.size.equalTo(CGSize(width: 355, height: 276))
        }
        iconImageView3.snp.makeConstraints { make in
            make.centerX.equalTo(iconImageView1.snp.centerX)
            make.top.equalTo(iconImageView2.snp.bottom).offset(111)
            make.size.equalTo(CGSize(width: 118.5, height: 43))
        }
        iconImageView3.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                PushLoginConfig.popLogin(from: self)
            }).disposed(by: disposeBag)
    }
    
    private func goAddMonitoringCompanyUI() {
        view.addSubview(iconImageView1)
        view.addSubview(iconImageView2)
        view.addSubview(iconImageView3)
        iconImageView3.image = UIImage(named: "tianjiajianonmgqiye")
        iconImageView1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset((SCREEN_WIDTH - 341) * 0.5)
            make.top.equalToSuperview().offset(18.5)
            make.size.equalTo(CGSize(width: 341, height: 108))
        }
        iconImageView2.snp.makeConstraints { make in
            make.centerX.equalTo(iconImageView1.snp.centerX)
            make.top.equalTo(iconImageView1.snp.bottom).offset(18.5)
            make.size.equalTo(CGSize(width: 355, height: 276))
        }
        iconImageView3.snp.makeConstraints { make in
            make.centerX.equalTo(iconImageView1.snp.centerX)
            make.top.equalTo(iconImageView2.snp.bottom).offset(111)
            make.size.equalTo(CGSize(width: 147, height: 46))
        }
        iconImageView3.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
            }).disposed(by: disposeBag)
    }
    
}
