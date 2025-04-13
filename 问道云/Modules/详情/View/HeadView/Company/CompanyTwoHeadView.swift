//
//  CompanyTwoHeadView.swift
//  问道云
//
//  Created by Andrew on 2025/1/13.
//

import UIKit
import MapKit
import RxRelay
import TYAlertController

class CompanyTwoHeadView: BaseView {
    
//    lazy var refreshBtn: UIButton = {
//        let refreshBtn = UIButton(type: .custom)
//        refreshBtn.setTitle("10小时前更新", for: .normal)
//        refreshBtn.setImage(UIImage(named: "deiconrefgresh"), for: .normal)
//        refreshBtn.setTitleColor(.init(cssStr: "#666666"), for: .normal)
//        refreshBtn.titleLabel?.font = .regularFontOfSize(size: 10)
//        return refreshBtn
//    }()
    var model = BehaviorRelay<DataModel?>(value: nil)
    var emailModel: DataModel?
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setImage(UIImage(named: "dephoneicon"), for: .normal)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setImage(UIImage(named: "siteguanwangicon"), for: .normal)
        return twoBtn
    }()
    
    lazy var threeBtn: UIButton = {
        let threeBtn = UIButton(type: .custom)
        threeBtn.setImage(UIImage(named: "wechatgongcicon"), for: .normal)
        return threeBtn
    }()
    
    lazy var fourBtn: UIButton = {
        let fourBtn = UIButton(type: .custom)
        fourBtn.setImage(UIImage(named: "emailiconim"), for: .normal)
        return fourBtn
    }()
    
    lazy var fiveBtn: UIButton = {
        let fiveBtn = UIButton(type: .custom)
        fiveBtn.setImage(UIImage(named: "addressiconim"), for: .normal)
        return fiveBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        addSubview(refreshBtn)
        addSubview(oneBtn)
        addSubview(twoBtn)
        addSubview(threeBtn)
        addSubview(fourBtn)
        addSubview(fiveBtn)
        addSubview(lineView)
        
//        refreshBtn.snp.makeConstraints { make in
//            make.height.equalTo(34)
//            make.left.equalToSuperview().offset(12)
//            make.centerY.equalToSuperview()
//            make.width.equalTo(80)
//        }
        oneBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.left.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: 45, height: 22))
        }
        twoBtn.snp.makeConstraints { make in
            make.centerY.equalTo(oneBtn.snp.centerY)
            make.left.equalTo(oneBtn.snp.right).offset(5)
            make.size.equalTo(CGSize(width: 46.5, height: 22))
        }
        threeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(oneBtn.snp.centerY)
            make.left.equalTo(twoBtn.snp.right).offset(5)
            make.size.equalTo(CGSize(width: 58.5, height: 22))
        }
        fourBtn.snp.makeConstraints { make in
            make.centerY.equalTo(oneBtn.snp.centerY)
            make.left.equalTo(threeBtn.snp.right).offset(5)
            make.size.equalTo(CGSize(width: 46.5, height: 22))
        }
        fiveBtn.snp.makeConstraints { make in
            make.centerY.equalTo(oneBtn.snp.centerY)
            make.left.equalTo(fourBtn.snp.right).offset(5)
            make.size.equalTo(CGSize(width: 46.5, height: 22))
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(4)
            make.top.equalTo(fiveBtn.snp.bottom).offset(6)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            let phoneCount = model.contactInfoCount?.phoneCount ?? 0
            let webSiteCount = model.contactInfoCount?.webSiteCount ?? 0
            let wechatCount = model.contactInfoCount?.wechatCount ?? 0
            let emailCount = model.contactInfoCount?.emailCount ?? 0
            let addressCount = model.contactInfoCount?.addressCount ?? 0
            
            if phoneCount != 0 {
                oneBtn.isEnabled = true
                oneBtn.setImage(UIImage(named: "dephoneicon"), for: .normal)
            }else {
                oneBtn.isEnabled = false
                oneBtn.setImage(UIImage(named: "phonegrayimge"), for: .normal)
            }
            
            if webSiteCount != 0 {
                oneBtn.isEnabled = true
                twoBtn.setImage(UIImage(named: "siteguanwangicon"), for: .normal)
            }else {
                twoBtn.isEnabled = false
                twoBtn.setImage(UIImage(named: "siteguanwangray"), for: .normal)
            }
            
            if wechatCount != 0 {
                threeBtn.isEnabled = true
                threeBtn.setImage(UIImage(named: "wechatgongcicon"), for: .normal)
            }else {
                threeBtn.isEnabled = true
                threeBtn.setImage(UIImage(named: "wechatgongcgray"), for: .normal)
            }
            
            if emailCount != 0 {
                fourBtn.isEnabled = true
                fourBtn.setImage(UIImage(named: "emailiconim"), for: .normal)
            }else {
                fourBtn.isEnabled = true
                fourBtn.setImage(UIImage(named: "emailiconimgray"), for: .normal)
            }
            
            if addressCount != 0 {
                fiveBtn.isEnabled = true
                fiveBtn.setImage(UIImage(named: "addressiconim"), for: .normal)
            }else {
                fiveBtn.isEnabled = true
                fiveBtn.setImage(UIImage(named: "addressicogray"), for: .normal)
            }
        }).disposed(by: disposeBag)
        
        
        oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.getPhoneInfo()
        }).disposed(by: disposeBag)
        
        twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.getPhoneInfo()
        }).disposed(by: disposeBag)
        
        threeBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.getPhoneInfo()
        }).disposed(by: disposeBag)
        
        fourBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.getPhoneInfo()
        }).disposed(by: disposeBag)
        
        fiveBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.getPhoneInfo()
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CompanyTwoHeadView {
    
    //获取电话信息
    private func getPhoneInfo() {
        if let emailModel = self.emailModel {
            self.popModel(from: emailModel)
        }else {
            let man = RequestManager()
            let dict = ["orgId": model.value?.basicInfo?.orgId ?? ""]
            man.requestAPI(params: dict,
                           pageUrl: "/firminfo/v2/bus-reg-info/contact-info",
                           method: .get) { result in
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        if let model = success.data {
                            self.emailModel = model
                            self.popModel(from: model)
                        }
                    }
                    break
                case .failure(_):
                    break
                }
            }
        }
    }
    
    private func popModel(from model: DataModel) {
        let phoneView = PopPhoneEmailView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 610))
        let alertVc = TYAlertController(alert: phoneView, preferredStyle: .actionSheet)!
        phoneView.model.accept(model)
        let vc = ViewControllerUtils.findViewController(from: self)
        vc?.present(alertVc, animated: true)
        
        phoneView.addressBlock = { [weak self] model in
            self?.goAddressInfo(from: model)
        }
        
        phoneView.websiteBlock = { [weak self] model in
            self?.goWensiteInfo(from: model)
        }
    }
    
    private func goAddressInfo(from model: addressListModel) {
        let vc = ViewControllerUtils.findViewController(from: self)
        let latitude = Double(model.lat ?? "0.0") ?? 0.0
        let longitude = Double(model.lng ?? "0.0") ?? 0.0
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let locationVc = CompanyLocationViewController(location: location)
        locationVc.name = model.address ?? ""
        vc?.dismiss(animated: true, completion: {
            vc?.navigationController?.pushViewController(locationVc, animated: true)
        })
    }
    
    private func goWensiteInfo(from model: websitesListModel) {
        let vc = ViewControllerUtils.findViewController(from: self)
        let webVc = WebPageViewController()
        webVc.pageUrl.accept(model.website ?? "")
        vc?.dismiss(animated: true, completion: {
            vc?.navigationController?.pushViewController(webVc, animated: true)
        })
    }
    
}
