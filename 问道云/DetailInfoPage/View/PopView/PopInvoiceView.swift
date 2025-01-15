//
//  PopInvoiceView.swift
//  问道云
//
//  Created by 何康 on 2025/1/15.
//  发票抬头弹窗

import UIKit
import RxRelay

class PopInvoiceView: BaseView {
    
    var model = BehaviorRelay<DataModel?>(value: nil)

    lazy var bgViwe: UIView = {
        let bgViwe = UIView()
        bgViwe.backgroundColor = .white
        bgViwe.layer.cornerRadius = 10
        return bgViwe
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "发票抬头"
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .center
        mlabel.font = .mediumFontOfSize(size: 16)
        return mlabel
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#547AFF")
        namelabel.textAlignment = .center
        namelabel.font = .mediumFontOfSize(size: 16)
        return namelabel
    }()
    
    lazy var onelabel: UILabel = {
        let onelabel = UILabel()
        onelabel.textColor = UIColor.init(cssStr: "#999999")
        onelabel.textAlignment = .left
        onelabel.font = .regularFontOfSize(size: 13)
        onelabel.text = "税号:"
        return onelabel
    }()
    
    lazy var twolabel: UILabel = {
        let twolabel = UILabel()
        twolabel.textColor = UIColor.init(cssStr: "#999999")
        twolabel.textAlignment = .left
        twolabel.font = .regularFontOfSize(size: 13)
        twolabel.text = "地址:"
        return twolabel
    }()
    
    lazy var threelabel: UILabel = {
        let threelabel = UILabel()
        threelabel.textColor = UIColor.init(cssStr: "#999999")
        threelabel.textAlignment = .left
        threelabel.font = .regularFontOfSize(size: 13)
        threelabel.text = "电话号码:"
        return threelabel
    }()
    
    lazy var fourlabel: UILabel = {
        let fourlabel = UILabel()
        fourlabel.textColor = UIColor.init(cssStr: "#999999")
        fourlabel.textAlignment = .left
        fourlabel.font = .regularFontOfSize(size: 13)
        fourlabel.text = "开户银行:"
        return fourlabel
    }()
    
    lazy var fivelabel: UILabel = {
        let fivelabel = UILabel()
        fivelabel.textColor = UIColor.init(cssStr: "#999999")
        fivelabel.textAlignment = .left
        fivelabel.font = .regularFontOfSize(size: 13)
        fivelabel.text = "银行账号:"
        return fivelabel
    }()
    
    lazy var desclabel: UILabel = {
        let desclabel = UILabel()
        desclabel.textColor = UIColor.init(cssStr: "#547AFF")
        desclabel.textAlignment = .center
        desclabel.font = .regularFontOfSize(size: 11)
        desclabel.text = "*仅用于开具发票，请勿用于转账等其他用途，谨防受骗"
        return desclabel
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.1)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.init(cssStr: "#547AFF"), for: .normal)
        cancelBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        cancelBtn.layer.cornerRadius = 3
        return cancelBtn
    }()
    
    lazy var saveBtn: UIButton = {
        let saveBtn = UIButton(type: .custom)
        saveBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")
        saveBtn.setTitle("保存至【发票抬头】", for: .normal)
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        saveBtn.layer.cornerRadius = 3
        return saveBtn
    }()
    
    lazy var label1: UILabel = {
        let label1 = UILabel()
        label1.textColor = UIColor.init(cssStr: "#333333")
        label1.textAlignment = .left
        label1.font = .regularFontOfSize(size: 13)
        return label1
    }()
    
    lazy var label2: UILabel = {
        let label2 = UILabel()
        label2.textColor = UIColor.init(cssStr: "#333333")
        label2.textAlignment = .left
        label2.font = .regularFontOfSize(size: 13)
        label2.numberOfLines = 0
        return label2
    }()
    
    lazy var label3: UILabel = {
        let label3 = UILabel()
        label3.textColor = UIColor.init(cssStr: "#333333")
        label3.textAlignment = .left
        label3.font = .regularFontOfSize(size: 13)
        label3.numberOfLines = 0
        return label3
    }()
    
    lazy var label4: UILabel = {
        let label4 = UILabel()
        label4.textColor = UIColor.init(cssStr: "#333333")
        label4.textAlignment = .left
        label4.font = .regularFontOfSize(size: 13)
        return label4
    }()
    
    lazy var label5: UILabel = {
        let label5 = UILabel()
        label5.textColor = UIColor.init(cssStr: "#333333")
        label5.textAlignment = .left
        label5.font = .regularFontOfSize(size: 13)
        return label5
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgViwe)
        bgViwe.addSubview(mlabel)
        bgViwe.addSubview(namelabel)
        bgViwe.addSubview(onelabel)
        bgViwe.addSubview(twolabel)
        bgViwe.addSubview(threelabel)
        bgViwe.addSubview(fourlabel)
        bgViwe.addSubview(fivelabel)
        bgViwe.addSubview(desclabel)
        bgViwe.addSubview(cancelBtn)
        bgViwe.addSubview(saveBtn)
        
        bgViwe.addSubview(label1)
        bgViwe.addSubview(label2)
        bgViwe.addSubview(label3)
        bgViwe.addSubview(label4)
        bgViwe.addSubview(label5)
        
        bgViwe.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.height.equalTo(346)
        }
        mlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(11)
            make.height.equalTo(22.5)
        }
        namelabel.snp.makeConstraints { make in
            make.top.equalTo(mlabel.snp.bottom).offset(31)
            make.centerX.equalToSuperview()
            make.height.equalTo(22.5)
        }
        onelabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(namelabel.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 69.5, height: 18.5))
        }
        twolabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(onelabel.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: 69.5, height: 18.5))
        }
        threelabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(twolabel.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: 69.5, height: 18.5))
        }
        fourlabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(threelabel.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: 69.5, height: 18.5))
        }
        fivelabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(fourlabel.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: 69.5, height: 18.5))
        }
        
        label1.snp.makeConstraints { make in
            make.centerY.equalTo(onelabel.snp.centerY)
            make.height.equalTo(18.5)
            make.left.equalTo(onelabel.snp.right).offset(16)
            make.right.equalToSuperview().offset(-20)
        }
        label2.snp.makeConstraints { make in
            make.centerY.equalTo(twolabel.snp.centerY)
            make.left.equalTo(twolabel.snp.right).offset(16)
            make.right.equalToSuperview().offset(-20)
        }
        label3.snp.makeConstraints { make in
            make.centerY.equalTo(threelabel.snp.centerY)
            make.left.equalTo(threelabel.snp.right).offset(16)
            make.right.equalToSuperview().offset(-20)
        }
        label4.snp.makeConstraints { make in
            make.centerY.equalTo(fourlabel.snp.centerY)
            make.height.equalTo(18.5)
            make.left.equalTo(fourlabel.snp.right).offset(16)
            make.right.equalToSuperview().offset(-20)
        }
        label5.snp.makeConstraints { make in
            make.centerY.equalTo(fivelabel.snp.centerY)
            make.height.equalTo(18.5)
            make.left.equalTo(fivelabel.snp.right).offset(16)
            make.right.equalToSuperview().offset(-20)
        }
        
        
        
        desclabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(fivelabel.snp.bottom).offset(40)
            make.height.equalTo(15)
        }
        cancelBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(22)
            make.top.equalTo(desclabel.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: 130, height: 37))
        }
        saveBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-22)
            make.top.equalTo(desclabel.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: 130, height: 37))
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            namelabel.text = model.firmInfo?.entityName ?? ""
            label1.text = model.taxInfo?.taxpayerId ?? ""
            label2.text = model.firmInfo?.entityAddress ?? ""
            label3.text = model.taxInfo?.phone ?? ""
            label4.text = "--"
            label5.text = "--"
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
