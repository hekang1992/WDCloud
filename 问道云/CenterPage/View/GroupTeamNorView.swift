//
//  GroupTeamNorView.swift
//  问道云
//
//  Created by 何康 on 2025/1/2.
//  团体添加

import UIKit

class GroupCommonView: BaseView {
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .init(cssStr: "#F5F7F9")
        bgView.layer.cornerRadius = 3
        return bgView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "您尚未创建团体"
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .left
        mlabel.font = .mediumFontOfSize(size: 15)
        return mlabel
    }()
    
    lazy var clabel: UILabel = {
        let clabel = UILabel()
        clabel.text = "团体邮箱: -"
        clabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        clabel.textAlignment = .left
        clabel.font = .regularFontOfSize(size: 12)
        return clabel
    }()
    
    lazy var editBtn: UIButton = {
        let editBtn = UIButton(type: .custom)
        editBtn.setImage(UIImage(named: "editimagebb"), for: .normal)
        editBtn.setTitle("编辑", for: .normal)
        editBtn.titleLabel?.font = .regularFontOfSize(size: 15)
        editBtn.setTitleColor(UIColor(cssStr: "#547AFF"), for: .normal)
        editBtn.isHidden = true
        return editBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(mlabel)
        bgView.addSubview(clabel)
        bgView.addSubview(editBtn)
        bgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(12.5)
            make.height.equalTo(81.5)
        }
        mlabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(21)
        }
        clabel.snp.makeConstraints { make in
            make.top.equalTo(mlabel.snp.bottom).offset(13)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(15.5)
        }
        editBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(21)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        editBtn.layoutButtonEdgeInsets(style: .left, space: 5)
    }
    
}

class GroupTeamNorView: BaseView {

    lazy var headView: GroupCommonView = {
        let headView = GroupCommonView()
        headView.backgroundColor = .white
        return headView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "请输入信息创建团体"
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .left
        mlabel.font = .semiboldFontOfSize(size: 18)
        return mlabel
    }()
    
    lazy var onelabel: UILabel = {
        let onelabel = UILabel()
        onelabel.text = "团体名称"
        onelabel.textColor = UIColor.init(cssStr: "#333333")
        onelabel.textAlignment = .left
        onelabel.font = .regularFontOfSize(size: 14)
        return onelabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F6F6F6")
        return lineView
    }()
    
    lazy var twolabel: UILabel = {
        let twolabel = UILabel()
        twolabel.text = "团体邮箱"
        twolabel.textColor = UIColor.init(cssStr: "#333333")
        twolabel.textAlignment = .left
        twolabel.font = .regularFontOfSize(size: 14)
        return twolabel
    }()
    
    lazy var nameTx: UITextField = {
        let nameTx = UITextField()
        let attrString = NSMutableAttributedString(string: " 请输入团体名称（必填）", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
            .font: UIFont.regularFontOfSize(size: 14)
        ])
        nameTx.attributedPlaceholder = attrString
        nameTx.font = .regularFontOfSize(size: 14)
        nameTx.textColor = UIColor.init(cssStr: "#333333")
        nameTx.layer.borderWidth = 0.5
        nameTx.layer.cornerRadius = 1.5
        nameTx.layer.borderColor = UIColor.init(cssStr: "#000000")?.withAlphaComponent(0.15).cgColor
        return nameTx
    }()
    
    lazy var emailTx: UITextField = {
        let emailTx = UITextField()
        let attrString = NSMutableAttributedString(string: " 请输入团体邮箱", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
            .font: UIFont.regularFontOfSize(size: 14)
        ])
        emailTx.attributedPlaceholder = attrString
        emailTx.font = .regularFontOfSize(size: 14)
        emailTx.textColor = UIColor.init(cssStr: "#333333")
        emailTx.layer.borderWidth = 0.5
        emailTx.layer.cornerRadius = 1.5
        emailTx.layer.borderColor = UIColor.init(cssStr: "#000000")?.withAlphaComponent(0.15).cgColor
        return emailTx
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")
        nextBtn.setTitle("创建团队", for: .normal)
        nextBtn.titleLabel?.font = .mediumFontOfSize(size: 15)
        nextBtn.layer.cornerRadius = 4
        return nextBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headView)
        addSubview(whiteView)
        whiteView.addSubview(mlabel)
        whiteView.addSubview(onelabel)
        whiteView.addSubview(lineView)
        whiteView.addSubview(twolabel)
        whiteView.addSubview(nameTx)
        whiteView.addSubview(emailTx)
        addSubview(nextBtn)
        headView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(100)
        }
        whiteView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(7)
            make.left.right.equalToSuperview()
            make.height.equalTo(160)
        }
        mlabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(25)
        }
        onelabel.snp.makeConstraints { make in
            make.top.equalTo(mlabel.snp.bottom).offset(28)
            make.left.equalToSuperview().offset(18)
            make.height.equalTo(20)
            make.width.equalTo(60)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(onelabel.snp.bottom).offset(17)
            make.height.equalTo(1)
            make.left.right.equalToSuperview()
        }
        twolabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(21)
            make.left.equalToSuperview().offset(18)
            make.height.equalTo(20)
            make.width.equalTo(60)
        }
        nameTx.snp.makeConstraints { make in
            make.centerY.equalTo(onelabel.snp.centerY)
            make.height.equalTo(40)
            make.right.equalToSuperview().offset(-12.5)
            make.left.equalTo(onelabel.snp.right).offset(56)
        }
        emailTx.snp.makeConstraints { make in
            make.centerY.equalTo(twolabel.snp.centerY)
            make.height.equalTo(40)
            make.right.equalToSuperview().offset(-12.5)
            make.left.equalTo(twolabel.snp.right).offset(56)
        }
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
            make.left.equalToSuperview().offset(26)
            make.height.equalTo(50.5)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
