//
//  BuyOneVipViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/28.
//  购买一次权益

import UIKit

class BuyOneVipViewController: WDBaseViewController {
    
    var serviceType: String = ""
    
    var moneyStr = "支付 ¥9 开通风控权益（基础版）"
    
    var money1Str = "支付 ¥19 开通风控权益（基础版）"
    
    var appleById: Int?
    
    var modelArray: [rowsModel]?
    
    var menuId: String = ""
    var entityType: Int = 0
    var entityId: String = ""
    var entityName: String = ""
    
    //返回是否需要刷新列表
    var refreshBlock: (() -> Void)?
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "购买服务"
        headView.oneBtn.setImage(UIImage(named: "headrightoneicon"), for: .normal)
        return headView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.isUserInteractionEnabled = true
        bgImageView.image = UIImage(named: "onebuyimges")
        return bgImageView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "onebuyimageView")
        return ctImageView
    }()
    
    lazy var descImageView: UIImageView = {
        let descImageView = UIImageView()
        descImageView.image = UIImage(named: "miaoshuoneimage")
        return descImageView
    }()
    
    lazy var norBtn: UIButton = {
        let norBtn = UIButton(type: .custom)
        norBtn.isSelected = true
        norBtn.adjustsImageWhenHighlighted = false
        norBtn.setImage(UIImage(named: "onenormail_nor"), for: .normal)
        norBtn.setImage(UIImage(named: "onenormail_sel"), for: .selected)
        return norBtn
    }()
    
    lazy var proBtn: UIButton = {
        let proBtn = UIButton(type: .custom)
        proBtn.adjustsImageWhenHighlighted = false
        proBtn.setImage(UIImage(named: "onepromail_nor"), for: .normal)
        proBtn.setImage(UIImage(named: "onepromail_sel"), for: .selected)
        return proBtn
    }()
    
    lazy var bImageView: UIImageView = {
        let bImageView = UIImageView()
        bImageView.image = UIImage(named: "tipsnoebuyimage")
        return bImageView
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        sureBtn.setImage(UIImage(named: "fengxianwegouxuiamg"), for: .normal)
        sureBtn.setImage(UIImage(named: "liangseimagegou"), for: .selected)
        sureBtn.titleLabel?.font = .regularFontOfSize(size: 11)
        sureBtn.setTitleColor(UIColor.init(cssStr: "#999999"), for: .normal)
        sureBtn.setTitle("《问道云会员服务协议》支付后可开票", for: .normal)
        return sureBtn
    }()
    
    lazy var buyBtn: UIButton = {
        let buyBtn = UIButton(type: .custom)
        buyBtn.setBackgroundImage(UIImage(named: "huiyuanpayimage"), for: .normal)
        buyBtn.setTitle(moneyStr, for: .normal)
        buyBtn.setTitleColor(.init(cssStr: "#3F1D02"), for: .normal)
        buyBtn.titleLabel?.font = .mediumFontOfSize(size: 15)
        return buyBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        addHeadView(from: headView)
        view.addSubview(bgImageView)
        bgImageView.addSubview(ctImageView)
        bgImageView.addSubview(descImageView)
        bgImageView.addSubview(norBtn)
        bgImageView.addSubview(proBtn)
        bgImageView.addSubview(bImageView)
        bgImageView.addSubview(sureBtn)
        bgImageView.addSubview(buyBtn)
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        ctImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 351.pix(), height: 71.pix()))
            make.top.equalToSuperview().offset(18.5)
            make.left.equalToSuperview().offset(15.5)
        }
        descImageView.snp.makeConstraints { make in
            make.left.equalTo(ctImageView.snp.left)
            make.size.equalTo(CGSize(width: 77, height: 13))
            make.top.equalTo(ctImageView.snp.bottom).offset(15.5)
        }
        
        norBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 170.pix(), height: 106.pix()))
            make.top.equalTo(descImageView.snp.bottom).offset(6.5)
            make.left.equalToSuperview().offset(15.5)
        }
        proBtn.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 170.pix(), height: 106.pix()))
            make.top.equalTo(descImageView.snp.bottom).offset(6.5)
            make.right.equalToSuperview().offset(-15.5)
        }
        bImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 358.pix(), height: 110.pix()))
            make.left.equalTo(descImageView.snp.left)
            make.top.equalTo(proBtn.snp.bottom).offset(5)
        }
        sureBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-25)
            make.left.equalToSuperview()
            make.height.equalTo(20)
        }
        buyBtn.snp.makeConstraints { make in
            make.bottom.equalTo(sureBtn.snp.top).offset(-8)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 351.pix(), height: 48.pix()))
        }
        sureBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            sureBtn.isSelected.toggle()
        }).disposed(by: disposeBag)
        
        buyBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if sureBtn.isSelected {
                self.buyInfo()
            }else {
                ToastViewConfig.showToast(message: "请先确认《问道云会员服务协议》")
            }
        }).disposed(by: disposeBag)
        
        norBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            norBtn.isSelected = true
            proBtn.isSelected = false
            self.buyBtn.setTitle(moneyStr, for: .normal)
            self.appleById = self.modelArray?.first?.combonumber ?? 0
        }).disposed(by: disposeBag)
        
        proBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            norBtn.isSelected = false
            proBtn.isSelected = true
            self.buyBtn.setTitle(money1Str, for: .normal)
            self.appleById = self.modelArray?.last?.combonumber ?? 0
        }).disposed(by: disposeBag)
        
        //获取套餐信息
        listInfo()
    }
    
    //购买
    private func buyInfo() {
        ViewHud.addLoadView()
        let man = RequestManager()
        let combonumber = self.appleById ?? 0
        let phonenumber = GetSaveLoginInfoConfig.getPhoneNumber()
        let dict = ["combonumber": String(combonumber),
                    "ordertype": "4",
                    "phonenumber": phonenumber,
                    "quantity": "1",
                    "entityType": entityType,
                    "entityId": entityId,
                    "entityName": entityName] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/customerorder/addorder-single",
                       method: .post) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    let combonumber = String(success.data?.appleById ?? 0)
                    let orderNumberID = success.data?.ordernumber ?? ""
                    self?.toApplePay(form: combonumber, orderNumberID: orderNumberID, complete: { [weak self] in
                        //添加监控
                        guard let self = self else { return }
                        if entityType == 1 {//企业
                            addCompanyMonitoring()
                        }else {//人员
                            addPeopleMonitoring()
                        }
                    })
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取套餐信息
    private func listInfo() {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["serviceType": "4"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/combo/equity-list",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let modelArray = success.data?.rows {
                        self.modelArray = modelArray
                        self.appleById = self.modelArray?.first?.combonumber ?? 0
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}

extension BuyOneVipViewController {
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        sureBtn.layoutButtonEdgeInsets(style: .left, space: 5)
    }
    
    //企业添加监控
    private func addCompanyMonitoring() {
        ViewHud.addLoadView()
        let entityid = entityId
        let firmname = entityName
        let groupnumber = menuId
        let dict = ["orgId": entityid,
                    "groupId": groupnumber,
                    "firmname": firmname] as [String : Any]
        let man = RequestManager()
        ViewHud.addLoadView()
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitor-org/addRiskMonitorOrg",
                       method: .post) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                let code = success.code ?? 0
                if code == 200 {
                    self?.refreshBlock?()
                    ToastViewConfig.showToast(message: "监控成功")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //人员监控
    private func addPeopleMonitoring() {
        ViewHud.addLoadView()
        let personId = entityId
        let personName = entityName
        let customerId = GetSaveLoginInfoConfig.getCustomerNumber()
        let groupId = menuId
        let man = RequestManager()
        let dict = ["personId": personId,
                    "customerId": customerId,
                    "groupId": groupId,
                    "personName": personName]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitor-person/addRiskMonitorPerson",
                       method: .post) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                let code = success.code ?? 0
                if code == 200 {
                    self?.refreshBlock?()
                    ToastViewConfig.showToast(message: "监控成功")
                }
                break
            case .failure(_):
                break
            }
        }
    }
}
