//
//  FocusCompanyEditViewCell.swift
//  问道云
//
//  Created by Andrew on 2024/12/26.
//  关注编辑cell

import UIKit

import UIKit
import RxRelay

class FocusCompanyEditViewCell: BaseViewCell {
    
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
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "Check_nor")
        return icon
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(icon)
        contentView.addSubview(ctImageView)
        contentView.addSubview(mlabel)
        contentView.addSubview(typelabel)
        contentView.addSubview(timelabel)
        contentView.addSubview(lineView)
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 15, height: 15))
            make.left.equalToSuperview().offset(10)
        }
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(30)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        mlabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(ctImageView.snp.right).offset(6)
            make.height.equalTo(21)
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
            make.left.equalTo(mlabel.snp.right)
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
            if let logo = model.logo, !logo.isEmpty, logo != "null" {
                ctImageView.kf.setImage(with: URL(string: logo))
            }else {
                ctImageView.image = UIImage.imageOfText(model.followtargetname ?? "", size: (24, 24))
            }
        }).disposed(by: disposeBag)
    }
    
    func configureDeleteCell(isChecked: Bool) {
        icon.image = isChecked ? UIImage(named: "Checkb_sel") : UIImage(named: "Check_nor")
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
