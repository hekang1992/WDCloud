//
//  MembershipListViewController.swift
//  问道云
//
//  Created by Andrew on 2024/12/27.
//  具体购买页面

import UIKit

class MembershipListViewController: WDBaseViewController {
    
    var combonumber: String = "0"
    
    var ordertype: Int = 0 //是否赠送 1自购 2赠送
    
    var friendphone: String = ""//好友电话
    
    var pushmsflag: Int = 0 //是否发送短信 0不发 1发送
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var listView: MembershipListView = {
        let listView = MembershipListView()
        listView.backgroundColor = .white
        return listView
    }()
    
    lazy var agreeView: AgreementView = {
        let agreeView = AgreementView()
        agreeView.backgroundColor = .white
        return agreeView
    }()
    
    lazy var bgImageView: MemberBgImageView = {
        let bgImageView = MemberBgImageView()
        bgImageView.backgroundColor = .white
        return bgImageView
    }()
    
    lazy var payView: PayBtnView = {
        let payView = PayBtnView()
        payView.backgroundColor = .white
        return payView
    }()
    
    //是否数字滚动
    var isRool: Bool = false
    
    //是否点击了协议
    var isClickPriType: Bool = false
    
    //是否支付成功
    var payBlock: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(scrollView)
        scrollView.addSubview(listView)
        scrollView.addSubview(agreeView)
        scrollView.addSubview(bgImageView)
        view.addSubview(payView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        listView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(squareWidth + 20)
        }
        agreeView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(listView.snp.bottom).offset(5)
            make.height.equalTo(121)
        }
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(agreeView.snp.bottom).offset(5)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(0).priority(.required)
            make.bottom.equalToSuperview().offset(-80)
        }
        payView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(80)
        }
        payView.payBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if self.isClickPriType {
                if ordertype == 1 {
                    self.payMemberInfo(from: self.combonumber, ordertype: ordertype, friendphone: "", pushmsflag: 0) { [weak self] in
                        //通知页面支付成功了
                        self?.payBlock?()
                    }
                }else {
                    self.payMemberInfo(from: self.combonumber, ordertype: ordertype, friendphone: friendphone, pushmsflag: pushmsflag)
                }
            }else {
                ToastViewConfig.showToast(message: "请先阅读《问道云会员服务协议》")
            }
            
        }).disposed(by: disposeBag)
        
        agreeView.sureBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            agreeView.sureBtn.isSelected.toggle()
            self.isClickPriType = agreeView.sureBtn.isSelected
        }).disposed(by: disposeBag)
        
    }
}

extension MembershipListViewController {
    
    //获取套餐信息
    func getPriceModelInfo(from index: Int, model: DataModel) {
        if isRool {
            return
        }
        if let rowModel = model.rows?[index],
            let oneModel = rowModel.serviceComboList?[0],
            let twoModel = rowModel.serviceComboList?[1],
            let threeModel = rowModel.serviceComboList?[2] {
            self.writeToListView(form: oneModel,
                                 listView: self.listView.oneView)
            self.writeToListView(form: twoModel,
                                 listView: self.listView.twoView)
            self.writeToListView(form: threeModel,
                                 listView: self.listView.threeView)
        }
        if index == 2 {
            self.addNodataView(from: view)
        } else if index == 1 {
            self.payView.payBtn.setBackgroundImage(UIImage(named: "svipimagepay"), for: .normal)
            self.payView.payBtn.setTitleColor(UIColor.init(cssStr: "#3F1D02"), for: .normal)
        } else {
            self.payView.payBtn.setBackgroundImage(UIImage(named: "huiyuanpayimage"), for: .normal)
            self.payView.payBtn.setTitleColor(UIColor.init(cssStr: "#21314F"), for: .normal)
        }
        [listView.oneView, listView.twoView, listView.threeView].enumerated().forEach { index, view in
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:))))
        }
        setBorder(for: listView.oneView)
        isRool = true
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view as? PriceView else { return }
        // 重置所有视图的边框
        resetBorders()
        // 设置点击的视图边框
        setBorder(for: tappedView)
    }
    
    private func resetBorders() {
        [listView.oneView,
         listView.twoView,
         listView.threeView].forEach { view in
            view.layer.borderWidth = 2
            view.layer.cornerRadius = 7.5
            view.layer.borderColor = UIColor.init(cssStr: "#E5E2ED")?.cgColor
        }
    }
    
    private func setBorder(for view: PriceView) {
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 7.5
        view.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        self.payView.payBtn.titleLabel?.font = .mediumFontOfSize(size: 15)
        let priceStr = "\(view.model.value?.price ?? 0.0)"
        let titleStr = "确认协议并支付¥\(priceStr)开通VIP"
        let attributedString = NSMutableAttributedString(string: titleStr)
        if let range = titleStr.range(of: priceStr) {
            let nsRange = NSRange(range, in: titleStr)
            attributedString.addAttribute(.font, value: UIFont.boldFontOfSize(size: 22), range: nsRange)
            self.payView.payBtn.setAttributedTitle(attributedString, for: .normal)
        }
        self.combonumber = String(view.model.value?.combonumber ?? 0)
    }
    
    //数据写入
    func writeToListView(form listModel: serviceComboListModel, listView: PriceView) {
        listView.model.accept(listModel)
        let imageUrl = listModel.privilegedpic ?? ""
        bgImageView.ctImageView.kf.setImage(with: URL(string: imageUrl)) { result in
            switch result {
            case .success(let imageResult):
                let imageWidth = imageResult.image.size.width
                let imageHeight = imageResult.image.size.height
                let imageHeightForDisplay = SCREEN_WIDTH / imageWidth * imageHeight
                self.bgImageView.snp.updateConstraints { make in
                    make.height.equalTo(imageHeightForDisplay)
                }
                self.view.layoutIfNeeded()
                break
            default:
                break
            }
        }
    }
    
    
}

extension MembershipListViewController {
    
}
