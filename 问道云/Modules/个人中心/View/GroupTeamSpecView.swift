//
//  GroupTeamSpecView.swift
//  问道云
//
//  Created by Andrew on 2025/1/2.
//  添加过后的view

import UIKit
import RxSwift

class GroupTeamSpecView: BaseView {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    lazy var headView: GroupCommonView = {
        let headView = GroupCommonView()
        headView.backgroundColor = .white
        headView.editBtn.isHidden = false
        return headView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
    }()
    
    lazy var viplabel: UILabel = {
        let viplabel = UILabel()
        viplabel.textColor = UIColor.init(cssStr: "#333333")
        viplabel.textAlignment = .left
        viplabel.font = .semiboldFontOfSize(size: 18)
        return viplabel
    }()
    
    lazy var vipBtn: UIButton = {
        let vipBtn = UIButton(type: .custom)
        vipBtn.setTitle("续费", for: .normal)
        vipBtn.titleLabel?.font = .semiboldFontOfSize(size: 10)
        vipBtn.setTitleColor(.init(cssStr: "#333333"), for: .normal)
        vipBtn.setImage(UIImage(named: "huiyuanimgeteam"), for: .normal)
        vipBtn.layer.cornerRadius = 10
        vipBtn.layer.borderWidth = 1
        vipBtn.layer.borderColor = UIColor.init(cssStr: "#FFD528")?.cgColor
        return vipBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F6F6F6")
        return lineView
    }()
    
    lazy var endlabel: UILabel = {
        let endlabel = UILabel()
        endlabel.textColor = UIColor.init(cssStr: "#666666")
        endlabel.textAlignment = .left
        endlabel.text = "到期时间"
        endlabel.font = .semiboldFontOfSize(size: 14)
        return endlabel
    }()
    
    lazy var timelabel: UILabel = {
        let timelabel = UILabel()
        timelabel.textColor = UIColor.init(cssStr: "#333333")
        timelabel.textAlignment = .right
        timelabel.font = .regularFontOfSize(size: 14)
        return timelabel
    }()
    
    lazy var currentlabel: UILabel = {
        let currentlabel = UILabel()
        currentlabel.textColor = UIColor.init(cssStr: "#666666")
        currentlabel.textAlignment = .left
        currentlabel.text = "当前套餐人数"
        currentlabel.font = .semiboldFontOfSize(size: 14)
        return currentlabel
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
        nextBtn.setTitle("管理", for: .normal)
        nextBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        nextBtn.setImage(UIImage(named: "righticonimage"), for: .normal)
        return nextBtn
    }()
    
    lazy var addBtn: UIButton = {
        let addBtn = UIButton(type: .custom)
        addBtn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
        addBtn.setTitle("增购套餐人数", for: .normal)
        addBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        addBtn.setImage(UIImage(named: "righticonimage"), for: .normal)
        return addBtn
    }()
    
    lazy var lineTwoView: UIView = {
        let lineTwoView = UIView()
        lineTwoView.backgroundColor = .init(cssStr: "#F6F6F6")
        return lineTwoView
    }()
    
    lazy var addlabel: UILabel = {
        let addlabel = UILabel()
        addlabel.textColor = UIColor.init(cssStr: "#666666")
        addlabel.textAlignment = .left
        addlabel.text = "添加团体成员"
        addlabel.font = .semiboldFontOfSize(size: 14)
        return addlabel
    }()
    
    lazy var nameTx: UITextField = {
        let nameTx = UITextField()
        let attrString = NSMutableAttributedString(string: " 请输入成员姓名", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
            .font: UIFont.regularFontOfSize(size: 14)
        ])
        nameTx.attributedPlaceholder = attrString
        nameTx.font = .regularFontOfSize(size: 14)
        nameTx.textColor = UIColor.init(cssStr: "#333333")
        nameTx.textAlignment = .right
        return nameTx
    }()
    
    lazy var lineThreeView: UIView = {
        let lineThreeView = UIView()
        lineThreeView.backgroundColor = .init(cssStr: "#F6F6F6")
        return lineThreeView
    }()
    
    lazy var phonelabel: UILabel = {
        let phonelabel = UILabel()
        phonelabel.textColor = UIColor.init(cssStr: "#666666")
        phonelabel.textAlignment = .left
        phonelabel.text = "手机号码"
        phonelabel.font = .semiboldFontOfSize(size: 14)
        return phonelabel
    }()
    
    lazy var borView: UIView = {
        let borView = UIView()
        borView.layer.borderWidth = 0.5
        borView.layer.cornerRadius = 1.5
        borView.layer.borderColor = UIColor.init(cssStr: "#000000")?.withAlphaComponent(0.15).cgColor
        return borView
    }()
    
    lazy var phoneTx: UITextField = {
        let phoneTx = UITextField()
        phoneTx.keyboardType = .phonePad
        let attrString = NSMutableAttributedString(string: "请输入成员手机号码", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#9FA4AD") as Any,
            .font: UIFont.regularFontOfSize(size: 14)
        ])
        phoneTx.attributedPlaceholder = attrString
        phoneTx.font = .regularFontOfSize(size: 14)
        phoneTx.textColor = UIColor.init(cssStr: "#333333")
        return phoneTx
    }()
    
    lazy var phoneImageView: UIImageView = {
        let phoneImageView = UIImageView()
        phoneImageView.isUserInteractionEnabled = true
        phoneImageView.image = UIImage(named: "phonimagetonxunlu")
        return phoneImageView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.text = "此手机号即将开通套餐会员权限，请核实后进行添加"
        descLabel.textColor = .init(cssStr: "#9FA4AD")
        descLabel.textAlignment = .center
        descLabel.font = .regularFontOfSize(size: 12)
        return descLabel
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        sureBtn.layer.cornerRadius = 4
        sureBtn.backgroundColor = UIColor.init(cssStr: "#ADBFFF")
        sureBtn.setTitle("确认添加", for: .normal)
        sureBtn.titleLabel?.font = .regularFontOfSize(size: 15)
        sureBtn.isEnabled = false
        return sureBtn
    }()
    
    lazy var whiteTwoView: UIView = {
        let whiteTwoView = UIView()
        whiteTwoView.backgroundColor = .white
        return whiteTwoView
    }()
    
    lazy var teamlabel: UILabel = {
        let teamlabel = UILabel()
        teamlabel.textColor = UIColor.init(cssStr: "#333333")
        teamlabel.textAlignment = .left
        teamlabel.text = "团体成员管理"
        teamlabel.font = .semiboldFontOfSize(size: 14)
        return teamlabel
    }()
    
    lazy var numBtn: UIButton = {
        let numBtn = UIButton(type: .custom)
        numBtn.setImage(UIImage(named: "righticonimage"), for: .normal)
        numBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        numBtn.setTitleColor(.black, for: .normal)
        numBtn.contentHorizontalAlignment = .right
        return numBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.addSubview(headView)
        scrollView.addSubview(whiteView)
        scrollView.addSubview(whiteTwoView)
        
        whiteView.addSubview(viplabel)
        whiteView.addSubview(vipBtn)
        whiteView.addSubview(lineView)
        whiteView.addSubview(endlabel)
        whiteView.addSubview(timelabel)
        whiteView.addSubview(currentlabel)
        whiteView.addSubview(nextBtn)
        whiteView.addSubview(addBtn)
        whiteView.addSubview(lineTwoView)
        whiteView.addSubview(addlabel)
        whiteView.addSubview(nameTx)
        whiteView.addSubview(lineThreeView)
        whiteView.addSubview(phonelabel)
        
        whiteView.addSubview(borView)
        borView.addSubview(phoneTx)
        borView.addSubview(phoneImageView)
        
        whiteView.addSubview(descLabel)
        whiteView.addSubview(sureBtn)
        
        whiteTwoView.addSubview(teamlabel)
        whiteTwoView.addSubview(numBtn)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        headView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(100)
        }
        whiteView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(5)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(378)
        }
        viplabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(11)
            make.height.equalTo(25)
        }
        vipBtn.snp.makeConstraints { make in
            make.centerY.equalTo(viplabel.snp.centerY)
            make.right.equalToSuperview().offset(-12.5)
            make.width.equalTo(47)
            make.height.equalTo(20)
        }
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(viplabel.snp.bottom).offset(7.5)
        }
        endlabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(17)
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(18)
        }
        timelabel.snp.makeConstraints { make in
            make.centerY.equalTo(endlabel.snp.centerY)
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-12.5)
        }
        currentlabel.snp.makeConstraints { make in
            make.top.equalTo(timelabel.snp.bottom).offset(13.5)
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(18)
        }
        nextBtn.snp.makeConstraints { make in
            make.centerY.equalTo(currentlabel.snp.centerY)
            make.left.equalTo(currentlabel.snp.right).offset(7.5)
            make.size.equalTo(CGSizeMake(44.pix(), 20))
        }
        addBtn.snp.makeConstraints { make in
            make.centerY.equalTo(currentlabel.snp.centerY)
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 100.pix(), height: 20))
        }
        lineTwoView.snp.makeConstraints { make in
            make.top.equalTo(addBtn.snp.bottom).offset(23)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(1)
        }
        addlabel.snp.makeConstraints { make in
            make.top.equalTo(lineTwoView.snp.bottom).offset(17.5)
            make.left.equalToSuperview().offset(18.5)
            make.height.equalTo(20)
        }
        nameTx.snp.makeConstraints { make in
            make.centerY.equalTo(addlabel.snp.centerY)
            make.height.equalTo(56)
            make.right.equalToSuperview().offset(-12.5)
            make.width.equalTo(220)
        }
        lineThreeView.snp.makeConstraints { make in
            make.top.equalTo(nameTx.snp.bottom)
            make.height.equalTo(1)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
        }
        phonelabel.snp.makeConstraints { make in
            make.left.equalTo(addlabel.snp.left)
            make.top.equalTo(lineThreeView.snp.bottom).offset(29)
            make.height.equalTo(20)
        }
        borView.snp.makeConstraints { make in
            make.centerY.equalTo(phonelabel.snp.centerY)
            make.right.equalToSuperview().offset(-12.5)
            make.height.equalTo(40)
            make.width.equalTo(233)
        }
        phoneTx.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(5)
            make.width.equalTo(150)
        }
        phoneImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-8)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        
        descLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(lineThreeView.snp.bottom).offset(99)
            make.height.equalTo(16.5)
        }
        sureBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descLabel.snp.bottom).offset(6.5)
            make.left.equalToSuperview().offset(27.5)
            make.height.equalTo(50.5)
        }
        
        whiteTwoView.snp.makeConstraints { make in
            make.top.equalTo(whiteView.snp.bottom).offset(7)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().offset(-20)
        }
        teamlabel.snp.makeConstraints { make in
            make.left.equalTo(phonelabel.snp.left)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        numBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12.5)
            make.size.equalTo(CGSize(width: 60, height: 20))
        }
    
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GroupTeamSpecView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nextBtn.layoutButtonEdgeInsets(style: .right, space: 2)
        addBtn.layoutButtonEdgeInsets(style: .right, space: 2)
        numBtn.layoutButtonEdgeInsets(style: .right, space: 9)
        vipBtn.layoutButtonEdgeInsets(style: .left, space: 4)
    }
    
}
