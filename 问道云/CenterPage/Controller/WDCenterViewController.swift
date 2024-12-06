//
//  WDCenterViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//  个人中心页面

import UIKit
import RxGesture
import RxSwift

class WDCenterViewController: WDBaseViewController {
    
    var model: DataModel?
    
    var modelArray: [String] = ["发票抬头", "我要开票", "客服中心", "微信通知", "邀请好友", "分享好友", "加入分销", "联系我们", "意见反馈", "团体中心"]
    
    lazy var centerView: UserCenterView = {
        let centerView = UserCenterView()
        return centerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if IS_LOGIN {
            //获取套餐信息
            getBuymoreinfo()
            centerView.huiyuanIcon.isHidden = false
        }else {
            centerView.phoneLabel.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    self?.popLogin()
            }).disposed(by: disposeBag)
            centerView.huiyuanIcon.isHidden = true
            modelArray.remove(at: modelArray.count - 1)
            self.centerView.modelArray.accept(modelArray)
        }
        self.centerView.collectionView.rx.modelSelected(String.self).subscribe(onNext: { [weak self] title in
            ToastViewConfig.showToast(message: title)
            if !IS_LOGIN {
                self?.popLogin()
            }else {
                
            }
        }).disposed(by: disposeBag)
        
        //跳转订单页面
        self.centerView.orderBtn.rx.tap.subscribe(onNext: { [weak self] in
            if IS_LOGIN {
                let orderListVc = UserAllOrderSController()
                if let model = self?.model {
                    orderListVc.model.accept(model)
                }
                self?.navigationController?.pushViewController(orderListVc, animated: true)
            }else {
                self?.popLogin()
            }
        }).disposed(by: disposeBag)
    }
}

extension WDCenterViewController {
    
    func getBuymoreinfo() {
        let man = RequestManager()
        let customernumber = UserDefaults.standard.object(forKey: WDY_CUSTOMERNUMBER) as? String ?? ""
        let dict = ["customernumber": customernumber]
        man.requestAPI(params: dict,
                       pageUrl: buymore_info,
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    self.model = model
                    getCenterInfo(model: model)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func getCenterInfo(model: DataModel) {
        centerView.timeLabel.text = "\(model.endtime ?? "") 到期"
        let accounttype = model.accounttype ?? 0
        let userIdentity = model.userIdentity ?? ""
        let combonumber = model.combonumber ?? 0
        centerView.descLabel.text = "问道云已陪伴您\(combonumber)天"
        let ktImageName: String
        let huiyuanIconName: String
        if userIdentity == "2" {
            ktImageName = "xufeihuiyuanimage"
            huiyuanIconName = (accounttype == 2 || accounttype == 3) ? "VIP_02" : "VIP_01"
        } else if userIdentity == "3" {
            ktImageName = "xufeihuiyuanimage"
            huiyuanIconName = (accounttype == 2 || accounttype == 3) ? "SVIP_02" : "SVIP_01"
        } else {
            ktImageName = "kaitonghuiahun"
            huiyuanIconName = "normalvip"
        }
        centerView.timeLabel.isHidden = userIdentity == "1" ? true : false
        centerView.descLabel2.text = userIdentity == "1" ? "开通VIP 享40项特权" : "已享40+项企业VIP特权权益"
        // 设置图片
        centerView.ktImageView.image = UIImage(named: ktImageName)
        centerView.huiyuanIcon.image = UIImage(named: huiyuanIconName)
        if accounttype != 2  {
            modelArray.remove(at: modelArray.count - 1)
        }
        self.centerView.modelArray.accept(modelArray)
    }
    
}
