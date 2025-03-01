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
                self.appleById = self.modelArray?.first?.appleById ?? 0
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
            self.appleById = self.modelArray?.first?.appleById ?? 0
        }).disposed(by: disposeBag)
        
        proBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            norBtn.isSelected = false
            proBtn.isSelected = true
            self.buyBtn.setTitle(money1Str, for: .normal)
            self.appleById = self.modelArray?.last?.appleById ?? 0
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
                    "quantity": "1"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/customerorder/addorder-single",
                       method: .post) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
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
                    if let modelArray = success.rows {
                        self.modelArray = modelArray
                    }
                }
                break
            case .failure(let failure):
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
    
}
