//
//  UserCenterView.swift
//  问道云
//
//  Created by 何康 on 2024/12/5.
//

import UIKit
import RxRelay

class UserCenterView: BaseView {
    
    var modelArray = BehaviorRelay<[String]>(value: [])
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.isUserInteractionEnabled = true
        bgImageView.image = UIImage(named: "centerbgimage")
        return bgImageView
    }()

    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "centericon")
        return icon
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.font = .mediumFontOfSize(size: 20)
        phoneLabel.textColor = .white
        phoneLabel.textAlignment = .left
        if IS_LOGIN {
            let phone = UserDefaults.standard.object(forKey: WDY_PHONE) as? String ?? ""
            phoneLabel.text = PhoneNumberFormatter.formatPhoneNumber(phoneNumber: phone)
        }else {
            phoneLabel.text = "暂未登录,请登录!"
        }
        return phoneLabel
    }()
    
    lazy var huiyuanIcon: UIImageView = {
        let huiyuanIcon = UIImageView()
        huiyuanIcon.isHidden = true
        huiyuanIcon.image = UIImage(named: "normalvip")
        return huiyuanIcon
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = .regularFontOfSize(size: 11)
        timeLabel.textColor = .white
        timeLabel.textAlignment = .left
        timeLabel.isUserInteractionEnabled = true
        return timeLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = .regularFontOfSize(size: 12)
        descLabel.textColor = .white
        descLabel.textAlignment = .left
        return descLabel
    }()
    
    lazy var setBtn: UIButton = {
        let setBtn = UIButton(type: .custom)
        setBtn.adjustsImageWhenHighlighted = false
        setBtn.setImage(UIImage(named: "shezhiimage"), for: .normal)
        return setBtn
    }()
    
    lazy var cameraBtn: UIButton = {
        let cameraBtn = UIButton(type: .custom)
        cameraBtn.adjustsImageWhenHighlighted = false
        cameraBtn.setImage(UIImage(named: "saoyisao"), for: .normal)
        return cameraBtn
    }()
    
    lazy var whiteView: UIStackView = {
        let whiteView = UIStackView()
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 5
        whiteView.axis = .horizontal
        whiteView.alignment = .fill
        whiteView.distribution = .fillEqually
        return whiteView
    }()
    
    lazy var orderBtn: UIButton = {
        let orderBtn = UIButton(type: .custom)
        orderBtn.adjustsImageWhenHighlighted = false
        orderBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        orderBtn.setTitle("我的订单", for: .normal)
        orderBtn.setImage(UIImage(named: "whit_01"), for: .normal)
        orderBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        return orderBtn
    }()
    
    lazy var downloadBtn: UIButton = {
        let downloadBtn = UIButton(type: .custom)
        downloadBtn.adjustsImageWhenHighlighted = false
        downloadBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        downloadBtn.setTitle("我的下载", for: .normal)
        downloadBtn.setImage(UIImage(named: "whit_02"), for: .normal)
        downloadBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        return downloadBtn
    }()
    
    lazy var focusBtn: UIButton = {
        let focusBtn = UIButton(type: .custom)
        focusBtn.adjustsImageWhenHighlighted = false
        focusBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        focusBtn.setTitle("我的关注", for: .normal)
        focusBtn.setImage(UIImage(named: "whit_03"), for: .normal)
        focusBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        return focusBtn
    }()
    
    lazy var historyBtn: UIButton = {
        let historyBtn = UIButton(type: .custom)
        historyBtn.adjustsImageWhenHighlighted = false
        historyBtn.titleLabel?.font = .regularFontOfSize(size: 12)
        historyBtn.setTitle("浏览历史", for: .normal)
        historyBtn.setImage(UIImage(named: "whit_04"), for: .normal)
        historyBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        return historyBtn
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "jinsehuiyuan")
        ctImageView.isUserInteractionEnabled = true
        return ctImageView
    }()
    
    lazy var ktImageView: UIImageView = {
        let ktImageView = UIImageView()
        ktImageView.image = UIImage(named: "kaitonghuiahun")
        return ktImageView
    }()
    
    lazy var descLabel1: UILabel = {
        let descLabel1 = UILabel()
        descLabel1.font = .semiboldFontOfSize(size: 14)
        descLabel1.textColor = UIColor.init(cssStr: "#7B5522")
        descLabel1.textAlignment = .left
        descLabel1.text = "会员中心"
        return descLabel1
    }()
    
    lazy var descLabel2: UILabel = {
        let descLabel2 = UILabel()
        descLabel2.font = .regularFontOfSize(size: 12)
        descLabel2.textColor = UIColor.init(cssStr: "#7B5522")
        descLabel2.textAlignment = .left
        descLabel2.text = "开通VIP 享40项特权"
        return descLabel2
    }()
    
    lazy var whiteView1: UIView = {
        let whiteView1 = UIView()
        whiteView1.backgroundColor = .white
        whiteView1.layer.cornerRadius = 5
        return whiteView1
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#4E3C83")?.withAlphaComponent(0.15)
        return lineView
    }()
    
    lazy var lineView1: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#4E3C83")?.withAlphaComponent(0.15)
        return lineView
    }()
    
    lazy var lineView2: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#4E3C83")?.withAlphaComponent(0.15)
        return lineView
    }()
    
    lazy var stackViewVertical: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    lazy var stackViewHorizontal1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    lazy var stackViewHorizontal2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    lazy var tuangouBtn: UserBuyButton = {
        let button = UserBuyButton(type: .custom)
        button.set(image: UIImage(named: "buyimage"), title: "购买团体套餐", title1: "统一管理更便捷")
        return button
    }()
    
    lazy var zengsongBtn: UserBuyButton = {
        let button = UserBuyButton(type: .custom)
        button.set(image: UIImage(named: "hongbaoimage"), title: "赠送好友会员", title1: "立即为TA买单")
        return button
    }()
    
    lazy var jiankongBtn: UserBuyButton = {
        let button = UserBuyButton(type: .custom)
        button.set(image: UIImage(named: "kaitongfengxian"), title: "开通风险监控", title1: "全网监测分析舆情")
        return button
    }()
    
    lazy var tiaochaBtn: UserBuyButton = {
        let button = UserBuyButton(type: .custom)
        button.set(image: UIImage(named: "jinzhidiaocha"), title: "开启尽职调查", title1: "客户尽职调研")
        return button
    }()
    
    lazy var whiteView2: UIView = {
        let whiteView2 = UIStackView()
        whiteView2.backgroundColor = .white
        whiteView2.layer.cornerRadius = 5
        return whiteView2
    }()
    
    lazy var morelabel: UILabel = {
        let morelabel = UILabel()
        morelabel.font = .mediumFontOfSize(size: 14)
        morelabel.textColor = UIColor.init(cssStr: "#333333")
        morelabel.textAlignment = .left
        morelabel.text = "更多功能"
        return morelabel
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = (SCREEN_WIDTH - 288) / 3
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UserCenterItemCell.self, forCellWithReuseIdentifier: "UserCenterItemCell")
        return collectionView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.font = .regularFontOfSize(size: 11)
        mlabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        mlabel.textAlignment = .center
        mlabel.text = "全国企业信息查询·风险监控平台"
        return mlabel
    }()
    
    lazy var pemailImageView: UIImageView = {
        let pemailImageView = UIImageView()
        pemailImageView.image = UIImage(named: "pemailimage")
        return pemailImageView
    }()
    
    lazy var icpLabel: UILabel = {
        let icpLabel = UILabel()
        icpLabel.font = .regularFontOfSize(size: 11)
        icpLabel.textColor = UIColor.init(cssStr: "#547AFF")
        icpLabel.textAlignment = .center
        icpLabel.isUserInteractionEnabled = true
        icpLabel.text = "沪ICP备2023018697号-6A"
        return icpLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgImageView)
        addSubview(icpLabel)
        addSubview(pemailImageView)
        addSubview(mlabel)
        addSubview(scrollView)
        scrollView.addSubview(icon)
        scrollView.addSubview(phoneLabel)
        scrollView.addSubview(huiyuanIcon)
        scrollView.addSubview(timeLabel)
        scrollView.addSubview(descLabel)
        scrollView.addSubview(setBtn)
        scrollView.addSubview(cameraBtn)
        scrollView.addSubview(whiteView)
        whiteView.addArrangedSubview(orderBtn)
        whiteView.addArrangedSubview(downloadBtn)
        whiteView.addArrangedSubview(focusBtn)
        whiteView.addArrangedSubview(historyBtn)
        scrollView.addSubview(ctImageView)
        ctImageView.addSubview(ktImageView)
        ctImageView.addSubview(descLabel1)
        ctImageView.addSubview(descLabel2)
        scrollView.addSubview(whiteView1)
        whiteView1.addSubview(stackViewVertical)
        whiteView1.addSubview(lineView)
        whiteView1.addSubview(lineView1)
        whiteView1.addSubview(lineView2)
        stackViewVertical.addArrangedSubview(stackViewHorizontal1)
        stackViewVertical.addArrangedSubview(stackViewHorizontal2)
        stackViewHorizontal1.addArrangedSubview(tuangouBtn)
        stackViewHorizontal1.addArrangedSubview(zengsongBtn)
        stackViewHorizontal2.addArrangedSubview(jiankongBtn)
        stackViewHorizontal2.addArrangedSubview(tiaochaBtn)
        scrollView.addSubview(whiteView2)
        whiteView2.addSubview(morelabel)
        whiteView2.addSubview(collectionView)
        bgImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(194)
        }
        icpLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-6)
            make.height.equalTo(15)
        }
        pemailImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(icpLabel.snp.top).offset(-2)
        }
        mlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(15)
            make.bottom.equalTo(pemailImageView.snp.top).offset(-2)
        }
        scrollView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
        }
        icon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(StatusHeightManager.statusBarHeight + 20)
            make.left.equalToSuperview().offset(20)
            make.size.equalTo(CGSizeMake(55, 55))
        }
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.top).offset(-0.5)
            make.left.equalTo(icon.snp.right).offset(8)
            make.height.equalTo(28)
        }
        huiyuanIcon.snp.makeConstraints { make in
            make.centerY.equalTo(phoneLabel.snp.centerY)
            make.left.equalTo(phoneLabel.snp.right).offset(12)
        }
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(phoneLabel.snp.left)
            make.top.equalTo(phoneLabel.snp.bottom)
            make.height.equalTo(15)
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(phoneLabel.snp.left)
            make.top.equalTo(timeLabel.snp.bottom).offset(2)
            make.height.equalTo(15)
        }
        setBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(SCREEN_WIDTH - 20)
            make.centerY.equalTo(phoneLabel.snp.centerY)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        cameraBtn.snp.makeConstraints { make in
            make.right.equalTo(setBtn.snp.left).offset(-9)
            make.centerY.equalTo(phoneLabel.snp.centerY)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        whiteView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(77.5)
            make.top.equalTo(descLabel.snp.bottom).offset(15.5)
        }
        ctImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(whiteView.snp.bottom).offset(8)
            make.height.equalTo(60)
        }
        ktImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 74, height: 25))
        }
        descLabel1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.left.equalToSuperview().offset(11)
            make.height.equalTo(20)
        }
        descLabel2.snp.makeConstraints { make in
            make.top.equalTo(descLabel1.snp.bottom).offset(2)
            make.left.equalToSuperview().offset(11)
            make.height.equalTo(16.5)
        }
        whiteView1.snp.makeConstraints { make in
            make.left.equalTo(whiteView.snp.left)
            make.centerX.equalToSuperview()
            make.top.equalTo(ctImageView.snp.bottom).offset(8)
            make.height.equalTo(115)
        }
        stackViewVertical.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        lineView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(14.5)
            make.height.equalTo(0.5)
        }
        lineView1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(18)
            make.size.equalTo(CGSize(width: 0.5, height: 30))
        }
        lineView2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-18)
            make.size.equalTo(CGSize(width: 0.5, height: 30))
        }
        whiteView2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalTo(whiteView.snp.left)
            make.top.equalTo(whiteView1.snp.bottom).offset(8)
            make.height.equalTo(234.5)
            make.bottom.equalToSuperview().offset(-20)
        }
        morelabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.5)
            make.top.equalToSuperview().offset(7.5)
            make.height.equalTo(20)
        }
        collectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(28)
            make.bottom.equalToSuperview()
            make.top.equalTo(morelabel.snp.bottom).offset(13.5)
        }
        
        
        modelArray.asObservable().bind(to: collectionView.rx.items(cellIdentifier: "UserCenterItemCell", cellType: UserCenterItemCell.self)) { row, model, cell in
            cell.model.accept(model)
        }.disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UserCenterView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 48, height: 43.5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        orderBtn.layoutButtonEdgeInsets(style: .top, space: 10)
        downloadBtn.layoutButtonEdgeInsets(style: .top, space: 10)
        focusBtn.layoutButtonEdgeInsets(style: .top, space: 10)
        historyBtn.layoutButtonEdgeInsets(style: .top, space: 10)
    }
    
}


class UserBuyButton: UIButton {
    
    private let customImageView = UIImageView()
    
    private let customImageView1 = UIImageView()
    
    private let customLabel = UILabel()
    
    private let customLabel1 = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.addSubview(customImageView)
        self.addSubview(customImageView1)
        self.addSubview(customLabel)
        self.addSubview(customLabel1)
        
        customImageView1.image = UIImage(named: "jinserightimage")
        customLabel.textAlignment = .left
        customLabel.numberOfLines = 0
        customLabel.textColor = UIColor.init(cssStr: "#333333")
        customLabel.font = .mediumFontOfSize(size: 13)
        
        customLabel1.textAlignment = .left
        customLabel1.numberOfLines = 0
        customLabel1.textColor = UIColor.init(cssStr: "#C58C3F")
        customLabel1.font = .regularFontOfSize(size: 11)
        
        customLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(9.5)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(18.5)
        }
        
        customLabel1.snp.makeConstraints { make in
            make.top.equalTo(customLabel.snp.bottom).offset(3)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(15)
        }
        customImageView1.snp.makeConstraints { make in
            make.centerY.equalTo(customLabel1.snp.centerY)
            make.left.equalTo(customLabel1.snp.right)
            make.size.equalTo(CGSize(width: 10, height: 10))
        }
        
        customImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-17.5)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
    }
    func set(image: UIImage?, title: String, title1: String) {
        customImageView.image = image
        customLabel.text = title
        customLabel.font = .mediumFontOfSize(size: 13)
        customLabel1.text = title1
        customLabel1.font = .regularFontOfSize(size: 11)
    }
}
