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
import Photos

class CompanyTwoHeadView: BaseView {
    
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
        
        phoneView.emailBlock = { model in
            if let url = URL(string: "mailto:\(model.email ?? "")") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        
        phoneView.wechatBlock = { [weak self] model in
            self?.goWensiteInfo(from: model)
        }
    }
    
    private func goWensiteInfo(from model: wechatListModel) {
        let vc = ViewControllerUtils.findViewController(from: self)
        vc?.dismiss(animated: true) {
            let listView = PopWechatListView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 346.pix()))
            let alertVc = TYAlertController(alert: listView, preferredStyle: .alert)!
            let logoUrl = model.imgUrl ?? ""
            listView.ctImageView.kf.setImage(with: URL(string: logoUrl))
            listView.nameLabel.text = "微信号: \(model.wechat ?? "")"
            vc?.present(alertVc, animated: true)
            
            listView.cancelBlock = {
                vc?.dismiss(animated: true)
            }
            
            listView.saveBlock = {
                vc?.dismiss(animated: true) {
                    guard let image = listView.ctImageView.image else { return }
                    self.saveImage(image)
                }
            }
            
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
        let pageUrl = model.website ?? ""
        if pageUrl.hasPrefix("http") {
            webVc.pageUrl.accept(pageUrl)
        }else {
            let webUrl = "http://" + pageUrl
            webVc.pageUrl.accept(webUrl)
        }
        vc?.dismiss(animated: true, completion: {
            vc?.navigationController?.pushViewController(webVc, animated: true)
        })
    }
    
    func saveImage(_ image: UIImage) {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        if status == .authorized {
            saveToAlbum(image: image)
            return
        }
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
            if newStatus == .authorized {
                self.saveToAlbum(image: image)
            } else {
                ShowAlertManager.showAlert(title: "相册权限", message: "请在设置中启用相册权限以便您可以保存图片。", confirmAction: { [weak self] in
                    self?.openSettings()
                })
            }
        }
    }

    private func saveToAlbum(image: UIImage) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        } completionHandler: { success, error in
            DispatchQueue.main.async {
                if success {
                    ToastViewConfig.showToast(message: "保存成功")
                } else {
                    ToastViewConfig.showToast(message: "保存失败")
                    print("保存失败: \(error?.localizedDescription ?? "未知错误")")
                }
            }
        }
    }
    
    func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: { success in
                    if success {
                        print("成功跳转到设置页面")
                    } else {
                        print("跳转失败")
                    }
                })
            } else {
                print("无法打开设置页面")
            }
        }
    }
    
}
