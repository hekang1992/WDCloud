//
//  HomeOneReportCell.swift
//  问道云
//
//  Created by Andrew on 2025/2/10.
//

import UIKit
import RxRelay

class HomeOneReportCell: BaseViewCell {
    
    var model = BehaviorRelay<itemsModel?>(value: nil)
    
    var block: ((itemsModel) -> Void)?
    
    var twoblock: ((String) -> Void)?
    
    var name: String? {
        didSet {
            guard let name = name else { return }
            nlabel.text = name
        }
    }
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "dfdaemoimage")
        return ctImageView
    }()
    
    lazy var vipImageView: UIImageView = {
        let vipImageView = UIImageView()
        vipImageView.image = UIImage(named: "vipimagedesck")
        return vipImageView
    }()
    
    lazy var nlabel: UILabel = {
        let nlabel = UILabel()
        nlabel.textColor = UIColor.init(cssStr: "#FFFFFF")
        nlabel.textAlignment = .center
        nlabel.font = .semiboldFontOfSize(size: 12)
        return nlabel
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .regularFontOfSize(size: 15)
        return namelabel
    }()
    
    lazy var desclabel: PaddedLabel = {
        let desclabel = PaddedLabel()
        desclabel.textColor = UIColor.init(cssStr: "#666666")
        desclabel.textAlignment = .left
        desclabel.font = .regularFontOfSize(size: 12)
        desclabel.backgroundColor = .init(cssStr: "#F7F7F7")
        desclabel.numberOfLines = 0
        desclabel.padding = UIEdgeInsets(top: 9, left: 6, bottom: 9, right: 6)
        return desclabel
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setTitle("样本预览", for: .normal)
        oneBtn.setTitleColor(.init(cssStr: "#333333"), for: .normal)
        oneBtn.backgroundColor = .init(cssStr: "#F7F7F7")
        oneBtn.titleLabel?.font = .regularFontOfSize(size: 13)
        oneBtn.layer.cornerRadius = 2
        oneBtn.layer.borderWidth = 1
        oneBtn.layer.borderColor = UIColor.init(cssStr: "#C7C7C7")?.cgColor
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setTitle("立即购买", for: .normal)
        twoBtn.setTitleColor(.init(cssStr: "#333333"), for: .normal)
        twoBtn.backgroundColor = .init(cssStr: "#547AFF")?.withAlphaComponent(0.1)
        twoBtn.titleLabel?.font = .regularFontOfSize(size: 13)
        twoBtn.layer.cornerRadius = 2
        twoBtn.layer.borderWidth = 1
        twoBtn.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        return twoBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(ctImageView)
        ctImageView.addSubview(nlabel)
        contentView.addSubview(namelabel)
        contentView.addSubview(vipImageView)
        contentView.addSubview(desclabel)
        contentView.addSubview(oneBtn)
        contentView.addSubview(twoBtn)
        ctImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(21)
            make.size.equalTo(CGSize(width: 81, height: 111))
            make.bottom.equalToSuperview().offset(-40)
        }
        nlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24.5)
            make.height.equalTo(16.5)
        }
        namelabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(ctImageView.snp.right).offset(12)
            make.height.equalTo(21)
        }
        vipImageView.snp.makeConstraints { make in
            make.left.equalTo(namelabel.snp.left)
            make.top.equalTo(namelabel.snp.bottom).offset(4)
            make.size.equalTo(CGSize(width: 162, height: 15))
        }
        desclabel.snp.makeConstraints { make in
            make.left.equalTo(namelabel.snp.left)
            make.top.equalTo(namelabel.snp.bottom).offset(32)
            make.right.equalToSuperview().offset(-22.5)
        }
        oneBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 162, height: 30))
        }
        twoBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 162, height: 30))
        }
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            namelabel.text = model.forshort ?? ""
            desclabel.text = model.descprtion ?? ""
            let templatepath = model.templatepath ?? ""
            let authflag = model.authflag ?? 0
            let reporttype = model.reporttype ?? 0
            if templatepath.isEmpty {
                twoBtn.setTitle("联系客服", for: .normal)
            }else {
                if authflag == 0 {
                    twoBtn.setTitle("生成报告", for: .normal)
                }else {
                    if reporttype == 1 {
                        twoBtn.setTitle("购买VIP", for: .normal)
                    } else if reporttype == 2 {
                        twoBtn.setTitle("购买SVIP", for: .normal)
                    } else if reporttype == 3 {
                        twoBtn.setTitle("联系客服", for: .normal)
                    }
                }
            }
        }).disposed(by: disposeBag)
        
        oneBtn.rx.tap.subscribe(onNext: { [weak self] in
            if let self = self, let model = self.model.value {
                self.block?(model)
            }
        }).disposed(by: disposeBag)
        
        twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            if let self = self {
                self.twoblock?(self.twoBtn.titleLabel?.text ?? "")
            }
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
