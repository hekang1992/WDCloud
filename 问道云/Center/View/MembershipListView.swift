//
//  MembershipListView.swift
//  问道云
//
//  Created by Andrew on 2024/12/27.
//

import UIKit
import RxRelay

let squareWidth = 120

let squareXLength = (SCREEN_WIDTH - 360) * 0.25

class PriceView: BaseView {
    
    var model = BehaviorRelay<serviceComboListModel?>(value: nil)
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 7.5
        bgView.layer.borderWidth = 2
        bgView.layer.borderColor = UIColor.init(cssStr: "#E5E2ED")?.cgColor
        return bgView
    }()
    
    lazy var onelabel: UILabel = {
        let onelabel = UILabel()
        onelabel.textColor = UIColor.init(cssStr: "#333333")
        onelabel.textAlignment = .center
        onelabel.font = .regularFontOfSize(size: 13)
        return onelabel
    }()
    
    lazy var twolabel: UILabel = {
        let twolabel = UILabel()
        twolabel.textColor = UIColor.init(cssStr: "#333333")
        twolabel.textAlignment = .right
        twolabel.font = .boldFontOfSize(size: 30)
        return twolabel
    }()
    
    lazy var threelabel: UILabel = {
        let threelabel = UILabel()
        threelabel.textColor = UIColor.init(cssStr: "#F75838")
        threelabel.textAlignment = .center
        threelabel.font = .regularFontOfSize(size: 11)
        threelabel.backgroundColor = .init(cssStr: "#FFF5F5")
        threelabel.layer.cornerRadius = 7.5
        return threelabel
    }()
    
    lazy var iclabel: UILabel = {
        let iclabel = UILabel()
        iclabel.textColor = UIColor.init(cssStr: "#333333")
        iclabel.textAlignment = .left
        iclabel.text = "¥"
        iclabel.font = .regularFontOfSize(size: 17)
        return iclabel
    }()
    
    lazy var combonumberLabel: UILabel = {
        let combonumberLabel = UILabel()
        return combonumberLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(combonumberLabel)
        addSubview(bgView)
        bgView.addSubview(onelabel)
        bgView.addSubview(twolabel)
        bgView.addSubview(iclabel)
        bgView.addSubview(threelabel)
        combonumberLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        bgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: squareWidth, height: squareWidth))
        }
        onelabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(16.5)
            make.top.equalToSuperview().offset(18)
        }
        twolabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(3)
            make.height.equalTo(38)
            make.top.equalTo(onelabel.snp.bottom).offset(3)
        }
        iclabel.snp.makeConstraints { make in
            make.right.equalTo(twolabel.snp.left).offset(-2)
            make.top.equalToSuperview().offset(48.5)
            make.size.equalTo(CGSize(width: 10.5, height: 24))
        }
        threelabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(13.5)
            make.top.equalTo(twolabel.snp.bottom).offset(2)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let listModel = model else { return }
            onelabel.text = listModel.comboname ?? ""
            NumberAnimator.animateNumber(on: twolabel, from: 0, to: Int(listModel.price ?? 0.0), duration: 0.5)
            threelabel.text = "低至\(listModel.minconsumption ?? "0.00")元/天"
            combonumberLabel.text = String(listModel.combonumber ?? 0)
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MembershipListView: BaseView {
    
    lazy var oneView: PriceView = {
        let oneView = PriceView()
        return oneView
    }()
    
    lazy var twoView: PriceView = {
        let twoView = PriceView()
        return twoView
    }()
    
    lazy var threeView: PriceView = {
        let threeView = PriceView()
        return threeView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(oneView)
        addSubview(twoView)
        addSubview(threeView)
        oneView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(squareXLength)
            make.size.equalTo(CGSize(width: squareWidth, height: squareWidth))
        }
        twoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(oneView.snp.right).offset(squareXLength)
            make.size.equalTo(CGSize(width: squareWidth, height: squareWidth))
        }
        threeView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(twoView.snp.right).offset(squareXLength)
            make.size.equalTo(CGSize(width: squareWidth, height: squareWidth))
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AgreementView: BaseView {
    
    lazy var onelabel: UILabel = {
        let onelabel = UILabel()
        onelabel.text = "购买须知"
        onelabel.textColor = UIColor.init(cssStr: "#333333")
        onelabel.textAlignment = .left
        onelabel.font = .semiboldFontOfSize(size: 15)
        return onelabel
    }()
    
    lazy var twolabel: UILabel = {
        let twolabel = UILabel()
        twolabel.text = "完成支付后，可在我的订单中，申请发票"
        twolabel.textColor = UIColor.init(cssStr: "#78849A")
        twolabel.textAlignment = .left
        twolabel.font = .regularFontOfSize(size: 14)
        return twolabel
    }()
    
    lazy var threelabel: UILabel = {
        let threelabel = UILabel()
        threelabel.text = "会员自支付之时起5分钟内生效"
        threelabel.textColor = UIColor.init(cssStr: "#78849A")
        threelabel.textAlignment = .left
        threelabel.font = .regularFontOfSize(size: 14)
        return threelabel
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        sureBtn.setImage(UIImage(named: "agreenorimage"), for: .normal)
        sureBtn.setImage(UIImage(named: "agreeselimage"), for: .selected)
        return sureBtn
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.isUserInteractionEnabled = true
        descLabel.font = .regularFontOfSize(size: 12.5)
        descLabel.textColor = .init(cssStr: "#999999")
        descLabel.textAlignment = .left
        let originalString = "我已阅读并同意《问道云会员服务协议》"
        let range = NSRange(location: 7, length: 11)
        let attributedString = NSMutableAttributedString(string: originalString)
        let defaultColor: UIColor = UIColor.init(cssStr: "#547AFF")!
        attributedString.addAttribute(.foregroundColor, value: defaultColor, range: range)
        descLabel.attributedText = attributedString
        return descLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(onelabel)
        addSubview(twolabel)
        addSubview(threelabel)
        addSubview(sureBtn)
        addSubview(descLabel)
        
        onelabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(13.5)
            make.height.equalTo(20)
        }
        twolabel.snp.makeConstraints { make in
            make.top.equalTo(onelabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(13.5)
            make.height.equalTo(20)
        }
        threelabel.snp.makeConstraints { make in
            make.top.equalTo(twolabel.snp.bottom).offset(3)
            make.left.equalToSuperview().offset(13.5)
            make.height.equalTo(20)
        }
        sureBtn.snp.makeConstraints { make in
            make.top.equalTo(threelabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(12.5)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        descLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sureBtn.snp.centerY)
            make.height.equalTo(16.5)
            make.left.equalTo(sureBtn.snp.right).offset(2)
        }
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MemberBgImageView: BaseView {
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.contentMode = .scaleAspectFit
        return ctImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ctImageView)
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.bottom.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class PayBtnView: BaseView {
    
    lazy var payBtn: UIButton = {
        let payBtn = UIButton(type: .custom)
        payBtn.adjustsImageWhenHighlighted = false
        return payBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(payBtn)
        payBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 351.pix(), height: 48.pix()))
            make.bottom.equalToSuperview().offset(-25)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
