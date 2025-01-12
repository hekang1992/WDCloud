//
//  TwoCompanyNormalListCell.swift
//  问道云
//
//  Created by 何康 on 2025/1/10.
//  不带风险扫描的cell

import UIKit
import RxRelay
import TagListView

class TwoCompanyNormalListCell: BaseViewCell {
    
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
        nameView.label1.text = "法定代表人"
        nameView.lineView.isHidden = false
        return nameView
    }()
    
    lazy var moneyView: BiaoQianView = {
        let moneyView = BiaoQianView(frame: .zero, enmu: .hide)
        moneyView.label1.text = "注册资本"
        moneyView.lineView.isHidden = false
        return moneyView
    }()
    
    lazy var timeView: BiaoQianView = {
        let timeView = BiaoQianView(frame: .zero, enmu: .hide)
        timeView.label1.text = "成立时间"
        return timeView
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
            make.bottom.equalToSuperview().offset(-45)
        }
        
        bgView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
        
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalTo(moneyView.snp.bottom).offset(7)
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
            self.nameView.label2.textColor = .init(cssStr: "#F55B5B")
           
            self.moneyView.label2.text = "\(model.firmInfo?.registerCapital ?? "--")\(model.firmInfo?.registerCapitalCurrency ?? "")"
            self.moneyView.label2.textColor = .init(cssStr: "#333333")
            
            self.timeView.label2.text = model.firmInfo?.incorporationTime ?? ""
            self.timeView.label2.textColor = .init(cssStr: "#333333")
            
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
