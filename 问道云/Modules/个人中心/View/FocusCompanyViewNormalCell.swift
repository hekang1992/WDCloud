//
//  FocusCompanyViewNormalCell.swift
//  问道云
//
//  Created by Andrew on 2024/12/26.
//  关注普通cell

import UIKit
import RxRelay

class FocusCompanyViewNormalCell: BaseViewCell {
    
    var model = BehaviorRelay<customerFollowListModel?>(value: nil)
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.layer.cornerRadius = 2.5
        return ctImageView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .left
        mlabel.font = .mediumFontOfSize(size: 15)
        mlabel.numberOfLines = 0
        return mlabel
    }()
    
    lazy var typelabel: PaddedLabel = {
        let typelabel = PaddedLabel()
        typelabel.textColor = UIColor.init(cssStr: "#333333")
        typelabel.textAlignment = .left
        typelabel.font = .mediumFontOfSize(size: 10)
        return typelabel
    }()
    
    lazy var timelabel: UILabel = {
        let timelabel = UILabel()
        timelabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        timelabel.textAlignment = .right
        timelabel.font = .regularFontOfSize(size: 11)
        return timelabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(ctImageView)
        contentView.addSubview(mlabel)
        contentView.addSubview(typelabel)
        contentView.addSubview(timelabel)
        contentView.addSubview(lineView)
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        mlabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(ctImageView.snp.right).offset(6)
            make.right.equalToSuperview().offset(-80)
        }
        typelabel.snp.makeConstraints { make in
            make.left.equalTo(mlabel.snp.left)
            make.top.equalTo(mlabel.snp.bottom).offset(1)
            make.height.equalTo(16)
            make.bottom.equalToSuperview().offset(-12)
        }
        timelabel.snp.makeConstraints { make in
            make.centerY.equalTo(mlabel.snp.centerY)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(15)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalToSuperview()
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            mlabel.text = model.followtargetname ?? ""
            timelabel.text = model.createTime ?? ""
            if let firmnamestate = model.firmnamestate, !firmnamestate.isEmpty, firmnamestate != "null" {
                typelabel.text = firmnamestate
                typelabel.isHidden = false
                TypeColorConfig.labelTextColor(form: typelabel)
            }else {
                typelabel.isHidden = true
            }
            let logo = model.logo ?? ""
            ctImageView.kf.setImage(with: URL(string: logo), placeholder: UIImage.imageOfText(model.followtargetname ?? "", size: (24, 24), bgColor: UIColor.init(cssStr: model.logoColor ?? "")!))
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
