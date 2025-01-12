//
//  TwoCompanyListCell.swift
//  问道云
//
//  Created by 何康 on 2025/1/9.
//  带风险扫描的cell

import UIKit
import TagListView
import RxRelay

class TwoCompanySpecListCell: BaseViewCell {
    
    //地址回调
    var addressBlock: ((pageDataModel) -> Void)?
    //官网回调
    var websiteBlock: ((pageDataModel) -> Void)?
    //电话回调
    var phoneBlock: ((pageDataModel) -> Void)?
    
    var model = BehaviorRelay<pageDataModel?>(value: nil)
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.layer.cornerRadius = 3
        return ctImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .mediumFontOfSize(size: 14)
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var tagListView: TagListView = {
        let tagListView = TagListView()
        tagListView.alignment = .left
        tagListView.cornerRadius = 2
        tagListView.textFont = .regularFontOfSize(size: 10)
        tagListView.textColor = UIColor.init(cssStr: "#F55B5B")!
        tagListView.tagBackgroundColor = UIColor.init(cssStr: "#F55B5B")!.withAlphaComponent(0.1)
        tagListView.backgroundColor = .random()
        return tagListView
    }()
    
    lazy var nameView: BiaoQianView = {
        let nameView = BiaoQianView(frame: .zero, enmu: .hide)
        nameView.lineView.isHidden = false
        nameView.label1.text = "法定代表人"
        return nameView
    }()
    
    lazy var moneyView: BiaoQianView = {
        let moneyView = BiaoQianView(frame: .zero, enmu: .hide)
        moneyView.lineView.isHidden = false
        moneyView.label1.text = "注册资本"
        return moneyView
    }()
    
    lazy var timeView: BiaoQianView = {
        let timeView = BiaoQianView(frame: .zero, enmu: .hide)
        timeView.label1.text = "成立时间"
        return timeView
    }()
    
    lazy var riskView: UIView = {
        let riskView = UIView()
        riskView.layer.cornerRadius = 2
        riskView.backgroundColor = UIColor.init(cssStr: "#F55B5B")?.withAlphaComponent(0.05)
        return riskView
    }()
    
    lazy var riskImageView: UIImageView = {
        let riskImageView = UIImageView()
        riskImageView.image = UIImage(named: "riskiamgeicon")
        return riskImageView
    }()
    
    lazy var risklabel: UILabel = {
        let risklabel = UILabel()
        risklabel.textColor = UIColor.init(cssStr: "#666666")
        risklabel.textAlignment = .left
        risklabel.font = .regularFontOfSize(size: 12)
        return risklabel
    }()
    
    lazy var riImageView: UIImageView = {
        let riImageView = UIImageView()
        riImageView.image = UIImage(named: "righticonimage")
        return riImageView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#EBEBEB")
        return lineView
    }()
    
    lazy var addressBtn: UIButton = {
        let addressBtn = UIButton(type: .custom)
        addressBtn.setImage(UIImage(named: "adressimageicon"), for: .normal)
        return addressBtn
    }()
    
    lazy var websiteBtn: UIButton = {
        let websiteBtn = UIButton(type: .custom)
        websiteBtn.setImage(UIImage(named: "guanwangimage"), for: .normal)
        return websiteBtn
    }()
    
    lazy var phoneBtn: UIButton = {
        let phoneBtn = UIButton(type: .custom)
        phoneBtn.setImage(UIImage(named: "dianhuaimageicon"), for: .normal)
        return phoneBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        contentView.addSubview(ctImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(tagListView)
        contentView.addSubview(nameView)
        contentView.addSubview(moneyView)
        contentView.addSubview(timeView)
        contentView.addSubview(riskView)
        riskView.addSubview(riskImageView)
        riskView.addSubview(risklabel)
        riskView.addSubview(riImageView)
        contentView.addSubview(lineView)
        contentView.addSubview(addressBtn)
        contentView.addSubview(websiteBtn)
        contentView.addSubview(phoneBtn)
        
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(ctImageView.snp.top)
            make.height.equalTo(20)
            make.left.equalTo(ctImageView.snp.right).offset(8)
        }
        
        tagListView.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.width.equalTo(SCREEN_WIDTH - 60)
        }
        
        moneyView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(120)
            make.top.equalTo(ctImageView.snp.bottom).offset(10.5)
            make.size.equalTo(CGSize(width: 150, height: 36))
        }
        
        nameView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(moneyView.snp.left)
            make.top.equalTo(moneyView.snp.top)
            make.height.equalTo(36)
        }
        
        timeView.snp.makeConstraints { make in
            make.left.equalTo(moneyView.snp.right)
            make.top.equalTo(moneyView.snp.top)
            make.height.equalTo(36)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-90)
        }
        
        bgView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
        
        riskView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(30)
            make.top.equalTo(moneyView.snp.bottom).offset(7)
        }
        riskImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(6)
            make.size.equalTo(CGSize(width: 57, height: 13))
        }
        risklabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(riskImageView.snp.right).offset(10.5)
            make.height.equalTo(16.5)
        }
        riImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-7)
            make.size.equalTo(CGSize(width: 12, height: 12))
        }
        
        
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalTo(riskView.snp.bottom).offset(11.5)
            make.height.equalTo(0.5)
        }
        
        addressBtn.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: 46.5, height: 21))
            make.right.equalToSuperview().offset(-12)
        }
        
        websiteBtn.snp.makeConstraints { make in
            make.top.equalTo(addressBtn.snp.top)
            make.size.equalTo(CGSize(width: 46.5, height: 21))
            make.right.equalTo(addressBtn.snp.left).offset(-8)
        }
        
        phoneBtn.snp.makeConstraints { make in
            make.top.equalTo(addressBtn.snp.top)
            make.size.equalTo(CGSize(width: 46.5, height: 21))
            make.right.equalTo(websiteBtn.snp.left).offset(-8)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            self.ctImageView.kf.setImage(with: URL(string: model.firmInfo?.logo ?? ""), placeholder: UIImage.imageOfText(model.firmInfo?.entityName ?? "", size: (32, 32), bgColor: .random(), textColor: .white))
           
            self.nameLabel.attributedText = TextStyler.styledText(for: model.firmInfo?.entityName ?? "", target: model.searchStr ?? "", color: UIColor.init(cssStr: "#F55B5B")!)
            
            self.nameView.label2.text = model.legalPerson?.legalName ?? ""
            self.nameView.label2.textColor = .init(cssStr: "#547AFF")
           
            self.moneyView.label2.text = "\(model.firmInfo?.registerCapital ?? "--")\(model.firmInfo?.registerCapitalCurrency ?? "")"
            self.moneyView.label2.textColor = .init(cssStr: "#333333")
            
            self.timeView.label2.text = model.firmInfo?.incorporationTime ?? ""
            self.timeView.label2.textColor = .init(cssStr: "#333333")
            
            self.risklabel.text = (model.riskInfo?.riskTime ?? "") + " " + (model.riskInfo?.content ?? "")
            
        }).disposed(by: disposeBag)
        
        //地址点击
        addressBtn.rx.tap.subscribe(onNext: { [weak self] in
            if let self = self, let model = self.model.value {
                self.addressBlock?(model)
            }
        }).disposed(by: disposeBag)
        
        //官网点击
        websiteBtn.rx.tap.subscribe(onNext: { [weak self] in
            if let self = self, let model = self.model.value {
                self.websiteBlock?(model)
            }
        }).disposed(by: disposeBag)
        
        //电话点击
        phoneBtn.rx.tap.subscribe(onNext: { [weak self] in
            if let self = self, let model = self.model.value {
                self.phoneBlock?(model)
            }
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



enum ShowTimeType {
    case show
    case hide
}

class BiaoQianView: BaseView {
    
    var type: ShowTimeType = .hide
    
    var block: ((String) -> Void)?
    
    lazy var label1: UILabel = {
        let label1 = UILabel()
        label1.font = .regularFontOfSize(size: 12)
        label1.textColor = .init(cssStr: "#9FA4AD")
        label1.textAlignment = .center
        return label1
    }()
    
    lazy var label2: UILabel = {
        let label2 = UILabel()
        label2.numberOfLines = 0
        label2.font = .mediumFontOfSize(size: 13)
        label2.textColor = .init(cssStr: "#547AFF")
        label2.textAlignment = .center
        return label2
    }()
    
    lazy var timeLabel: PaddedLabel = {
        let timeLabel = PaddedLabel()
        timeLabel.font = .regularFontOfSize(size: 9)
        timeLabel.layer.borderWidth = 0.5
        timeLabel.layer.borderColor = UIColor.init(cssStr: "#9FA4AD")?.cgColor
        timeLabel.layer.cornerRadius = 1

        return timeLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#D9D9D9")
        lineView.isHidden = true
        return lineView
    }()
    
    init(frame: CGRect, enmu: ShowTimeType) {
        super.init(frame: frame)
        addSubview(label1)
        addSubview(label2)
        addSubview(lineView)
        if enmu == .show {
            addSubview(timeLabel)
            label1.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview()
                make.height.equalTo(16.5)
            }
            timeLabel.snp.makeConstraints { make in
                make.left.equalTo(label1.snp.right).offset(1)
                make.centerY.equalTo(label1.snp.centerY)
                make.height.equalTo(10)
            }
            label2.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.left.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            lineView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize(width: 0.5, height: 10))
                make.right.equalToSuperview()
            }
        }else {
            label1.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.left.equalToSuperview()
                make.top.equalToSuperview()
                make.height.equalTo(16.5)
            }
            label2.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.left.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(18.5)
            }
            lineView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize(width: 0.5, height: 10))
                make.right.equalToSuperview()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


import UIKit

class TextStyler {

    static func styledText(for text: String, target: String, color: UIColor) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: text)
        var range = (text as NSString).range(of: target)
        while range.location != NSNotFound {
            attributedText.addAttribute(.foregroundColor, value: color, range: range)
            let startLocation = range.location + range.length
            if startLocation < text.count {
                range = (text as NSString).range(of: target, options: [], range: NSRange(location: startLocation, length: text.count - startLocation))
            } else {
                break
            }
        }
        return attributedText
    }
}

