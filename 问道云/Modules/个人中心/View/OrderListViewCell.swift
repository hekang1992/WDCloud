//
//  OrderListViewCell.swift
//  问道云
//
//  Created by Andrew on 2024/12/5.
//

import UIKit
import RxRelay
import RxSwift

class OrderListViewCell: BaseViewCell {
    
    var model = BehaviorRelay<rowsModel?>(value: nil)
    
    var block: ((rowsModel) -> Void)?
    
    private var timer: Timer?
    private var endDate: Date?
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .mediumFontOfSize(size: 16)
        return nameLabel
    }()
    
    lazy var descLabel1: UILabel = {
        let descLabel1 = UILabel()
        descLabel1.textAlignment = .left
        descLabel1.text = "订单编号:"
        descLabel1.textColor = .init(cssStr: "#999999")
        descLabel1.font = .regularFontOfSize(size: 13)
        return descLabel1
    }()
    
    lazy var descLabel2: UILabel = {
        let descLabel2 = UILabel()
        descLabel2.textAlignment = .left
        descLabel2.text = "下单时间:"
        descLabel2.textColor = .init(cssStr: "#999999")
        descLabel2.font = .regularFontOfSize(size: 13)
        return descLabel2
    }()
    
    lazy var descLabel3: UILabel = {
        let descLabel3 = UILabel()
        descLabel3.textAlignment = .left
        descLabel3.text = "支付方式:"
        descLabel3.textColor = .init(cssStr: "#999999")
        descLabel3.font = .regularFontOfSize(size: 13)
        return descLabel3
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#EFEFEF")
        return lineView
    }()
    
    lazy var descLabel4: UILabel = {
        let descLabel4 = UILabel()
        descLabel4.textAlignment = .left
        descLabel4.text = "共支付:"
        descLabel4.textColor = .init(cssStr: "#212121")
        descLabel4.font = .regularFontOfSize(size: 14)
        return descLabel4
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "cancelimage")
        return ctImageView
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var orderLabel: UILabel = {
        let orderLabel = UILabel()
        orderLabel.textAlignment = .left
        orderLabel.textColor = .init(cssStr: "#333333")
        orderLabel.font = .regularFontOfSize(size: 13)
        return orderLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textAlignment = .left
        timeLabel.textColor = .init(cssStr: "#333333")
        timeLabel.font = .regularFontOfSize(size: 13)
        return timeLabel
    }()
    
    lazy var payLabel: UILabel = {
        let payLabel = UILabel()
        payLabel.textAlignment = .left
        payLabel.textColor = .init(cssStr: "#333333")
        payLabel.font = .regularFontOfSize(size: 13)
        return payLabel
    }()
    
    lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textAlignment = .left
        moneyLabel.textColor = .init(cssStr: "#FF2D55")
        moneyLabel.font = .regularFontOfSize(size: 14)
        return moneyLabel
    }()
    
    lazy var syLabel: UILabel = {
        let syLabel = UILabel()
        syLabel.textAlignment = .left
        syLabel.textColor = .init(cssStr: "#FF2D55")
        syLabel.font = .semiboldFontOfSize(size: 12)
        return syLabel
    }()
    
    lazy var payBtn: UIButton = {
        let payBtn = UIButton()
        payBtn.layer.cornerRadius = 2
        payBtn.titleLabel?.font = .semiboldFontOfSize(size: 12)
        payBtn.setTitle("立即支付", for: .normal)
        payBtn.setTitleColor(UIColor.white, for: .normal)
        payBtn.backgroundColor = .init(cssStr: "#F55B5B")
        return payBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descLabel1)
        contentView.addSubview(descLabel2)
        contentView.addSubview(descLabel3)
        contentView.addSubview(lineView)
        contentView.addSubview(descLabel4)
        contentView.addSubview(ctImageView)
        
        contentView.addSubview(orderLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(payLabel)
        contentView.addSubview(moneyLabel)
        
        contentView.addSubview(syLabel)
        contentView.addSubview(payBtn)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(22.5)
        }
        descLabel1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.height.equalTo(18.5)
        }
        descLabel2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(descLabel1.snp.bottom).offset(4)
            make.height.equalTo(18.5)
        }
        descLabel3.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(descLabel2.snp.bottom).offset(4)
            make.height.equalTo(18.5)
        }
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(0.5)
            make.top.equalTo(descLabel3.snp.bottom).offset(8)
        }
        descLabel4.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(lineView.snp.bottom).offset(8)
            make.height.equalTo(29)
            make.bottom.equalToSuperview().offset(-16)
        }
        orderLabel.snp.makeConstraints { make in
            make.centerY.equalTo(descLabel1.snp.centerY)
            make.left.equalTo(descLabel1.snp.right).offset(9)
            make.height.equalTo(18.5)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(descLabel2.snp.centerY)
            make.left.equalTo(descLabel2.snp.right).offset(9)
            make.height.equalTo(18.5)
        }
        payLabel.snp.makeConstraints { make in
            make.centerY.equalTo(descLabel3.snp.centerY)
            make.left.equalTo(descLabel3.snp.right).offset(9)
            make.height.equalTo(18.5)
        }
        moneyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(descLabel4.snp.centerY)
            make.left.equalTo(descLabel4.snp.right).offset(9)
            make.height.equalTo(20)
        }
        syLabel.snp.makeConstraints { make in
            make.centerY.equalTo(descLabel4.snp.centerY)
            make.left.equalTo(moneyLabel.snp.right).offset(9)
            make.height.equalTo(20)
        }
        payBtn.snp.makeConstraints { make in
            make.centerY.equalTo(descLabel4.snp.centerY)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(74.5)
            make.height.equalTo(24)
        }
        bgView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-6)
        }
        ctImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 75, height: 75))
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
        }
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            nameLabel.text = model.comboname ?? ""
            orderLabel.text = model.ordernumber ?? ""
            timeLabel.text = model.ordertime ?? ""
            let payway = model.payway ?? ""
            if payway == "3" {
                payLabel.text = "Apple支付"
            }else {
                payLabel.text = payway
            }
            let price = String(format: "%.2f", model.pirce ?? 0.00)
            moneyLabel.text = "¥\(price)"
            let orderstate = model.orderstate ?? ""
            if orderstate == "0" {
                ctImageView.image = UIImage(named: "weizhijinngimge")
            }else if orderstate == "1" {
                ctImageView.image = UIImage(named: "yijingzhifuimga")
            }else if orderstate == "2" {
                ctImageView.image = UIImage(named: "cancelimage")
            }else {
                ctImageView.image = UIImage(named: "cancelimage")
            }
            if orderstate == "0" {
                self.syLabel.isHidden = false
                self.payBtn.isHidden = false
                let ordertime = model.ordertime ?? ""
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                dateFormatter.timeZone = TimeZone.current
                let startDate = dateFormatter.date(from: ordertime)!
                self.configure(with: startDate)
            }else {
                self.syLabel.text = ""
                self.syLabel.isHidden = true
                self.payBtn.isHidden = true
            }
        }).disposed(by: disposeBag)
        
        //立即支付
        payBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self,
                  let model = model.value else { return }
            self.block?(model)
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with startDate: Date) {
        // 清除之前的计时器
        timer?.invalidate()
        
        // 设置结束时间（开始时间 + 30分钟）
        endDate = startDate.addingTimeInterval(30 * 60)
        
        // 立即更新一次显示
        updateCountdown()
        
        // 启动新的计时器
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateCountdown()
        }
    }
    
    private func updateCountdown() {
        guard let endDate = endDate else { return }
        
        let now = Date()
        let remainingTime = endDate.timeIntervalSince(now)
        
        if remainingTime <= 0 {
            // 倒计时结束
            self.syLabel.text = ""
            timer?.invalidate()
            timer = nil
        } else {
            // 格式化剩余时间
            let hours = Int(remainingTime) / 3600
            let minutes = (Int(remainingTime) % 3600) / 60
            let seconds = Int(remainingTime) % 60
            self.syLabel.text = String(format: "剩余支付时间:%02d:%02d", minutes, seconds)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()
        timer = nil
        self.syLabel.text = nil
    }
    
    deinit {
        timer?.invalidate()
    }
}
