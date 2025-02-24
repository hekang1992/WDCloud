//
//  Untitled.swift
//  问道云
//
//  Created by 何康 on 2024/12/12.
//

import UIKit
import RxRelay

class PopMoreBtnView: BaseView {
    
    var model = BehaviorRelay<rowsModel?>(value: nil)
    
    var block: (() -> Void)?
    
    var block1: (() -> Void)?
    
    var block2: (() -> Void)?
    
    var block3: (() -> Void)?
    
    var block4: ((rowsModel) -> Void)?
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 10
        bgView.backgroundColor = UIColor.init(cssStr: "#F3F3F3")
        return bgView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .mediumFontOfSize(size: 16)
        nameLabel.textColor = UIColor.init(cssStr: "#333333")
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var btn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor.init(cssStr: "#27344B"), for: .normal)
        btn.titleLabel?.font = .regularFontOfSize(size: 16)
        return btn
    }()
    
    lazy var btn1: UIButton = {
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "renameimage"), for: .normal)
        btn1.setTitle("重命名", for: .normal)
        btn1.titleLabel?.font = .regularFontOfSize(size: 13)
        btn1.setTitleColor(UIColor.init(cssStr: "#666666"), for: .normal)
        return btn1
    }()
    
    lazy var btn2: UIButton = {
        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "emailimageicon"), for: .normal)
        btn2.setTitle("发送至邮箱", for: .normal)
        btn2.titleLabel?.font = .regularFontOfSize(size: 13)
        btn2.setTitleColor(UIColor.init(cssStr: "#666666"), for: .normal)
        return btn2
    }()
    
    lazy var btn3: UIButton = {
        let btn3 = UIButton(type: .custom)
        btn3.setImage(UIImage(named: "deletenameimage"), for: .normal)
        btn3.setTitle("删除", for: .normal)
        btn3.titleLabel?.font = .regularFontOfSize(size: 13)
        btn3.setTitleColor(UIColor.init(cssStr: "#666666"), for: .normal)
        return btn3
    }()
    
    lazy var btn4: UIButton = {
        let btn4 = UIButton(type: .custom)
        btn4.setImage(UIImage(named: "otherimageapp"), for: .normal)
        btn4.setTitle("用其他应用打开", for: .normal)
        btn4.titleLabel?.font = .regularFontOfSize(size: 13)
        btn4.setTitleColor(UIColor.init(cssStr: "#666666"), for: .normal)
        return btn4
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(whiteView)
        whiteView.addSubview(btn)
        bgView.addSubview(nameLabel)
        bgView.addSubview(btn1)
        bgView.addSubview(btn2)
        bgView.addSubview(btn3)
        bgView.addSubview(btn4)
        bgView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(265)
        }
        whiteView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(68)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(22.5)
        }
        btn1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(17.5)
            make.top.equalTo(nameLabel.snp.bottom).offset(26)
            make.size.equalTo(CGSize(width: 60, height: 74))
        }
        btn2.snp.makeConstraints { make in
            make.left.equalTo(btn1.snp.right).offset(20)
            make.top.equalTo(nameLabel.snp.bottom).offset(26)
            make.size.equalTo(CGSize(width: 80, height: 74))
        }
        btn3.snp.makeConstraints { make in
            make.left.equalTo(btn2.snp.right).offset(20)
            make.top.equalTo(nameLabel.snp.bottom).offset(26)
            make.size.equalTo(CGSize(width: 60, height: 74))
        }
        btn4.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(17.5)
            make.top.equalTo(btn3.snp.bottom).offset(17)
            make.size.equalTo(CGSize(width: 160, height: 24))
        }
        btn.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(47)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            self?.nameLabel.text = model?.downloadfilename ?? ""
        }).disposed(by: disposeBag)
        
        
        btn.rx.tap.subscribe(onNext: { [weak self] in
            self?.block?()
        }).disposed(by: disposeBag)
        
        btn1.rx.tap.subscribe(onNext: { [weak self] in
            self?.block1?()
        }).disposed(by: disposeBag)
        
        btn2.rx.tap.subscribe(onNext: { [weak self] in
            self?.block2?()
        }).disposed(by: disposeBag)
        
        btn3.rx.tap.subscribe(onNext: { [weak self] in
            self?.block3?()
        }).disposed(by: disposeBag)
        
        btn4.rx.tap.subscribe(onNext: { [weak self] in
            if let model = self?.model.value {
                self?.block4?(model)
            }
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        btn1.layoutButtonEdgeInsets(style: .top, space: 8)
        btn2.layoutButtonEdgeInsets(style: .top, space: 8)
        btn3.layoutButtonEdgeInsets(style: .top, space: 8)
        btn4.layoutButtonEdgeInsets(style: .left, space: 8)
    }
}


//重命名
class CMMView: BaseView {
    
    var cblock: (() -> Void)?
    
    var sblock: (() -> Void)?
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 10
        return bgView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "重命名"
        nameLabel.font = .regularFontOfSize(size: 15)
        nameLabel.textColor = UIColor.init(cssStr: "#333333")
        return nameLabel
    }()
    
    lazy var cycleView: UIView = {
        let cycleView = UIView()
        cycleView.layer.cornerRadius = 2
        cycleView.layer.borderWidth = 0.5
        cycleView.layer.borderColor = UIColor.init(cssStr: "#DCDCDC")?.cgColor
        return cycleView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var lineView1: UIView = {
        let lineView1 = UIView()
        lineView1.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView1
    }()
    
    lazy var tf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "重命名"
        tf.font = .mediumFontOfSize(size: 16)
        tf.textColor = UIColor.init(cssStr: "#333333")
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    lazy var canBtn: UIButton = {
        let canBtn = UIButton(type: .custom)
        canBtn.setTitle("取消", for: .normal)
        canBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
        canBtn.titleLabel?.font = .regularFontOfSize(size: 15)
        return canBtn
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(UIColor.init(cssStr: "#307CFF"), for: .normal)
        sureBtn.titleLabel?.font = .regularFontOfSize(size: 15)
        return sureBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(cycleView)
        bgView.addSubview(lineView)
        bgView.addSubview(lineView1)
        bgView.addSubview(canBtn)
        bgView.addSubview(sureBtn)
        cycleView.addSubview(tf)
        
        bgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 300, height: 177))
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(14)
            make.top.equalToSuperview().offset(24)
            make.height.equalTo(21)
        }
        cycleView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(9.5)
            make.height.equalTo(49)
        }
        tf.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.bottom.top.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(cycleView.snp.bottom).offset(19)
            make.height.equalTo(1)
        }
        lineView1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-14)
            make.width.equalTo(0.5)
        }
        canBtn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom)
            make.right.equalTo(lineView1.snp.left)
        }
        sureBtn.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom)
            make.left.equalTo(lineView1.snp.right)
        }
        
        canBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.cblock?()
        }).disposed(by: disposeBag)
        
        sureBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.sblock?()
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: rowsModel? {
        didSet {
            guard let model = model else { return }
            tf.text = model.downloadfilename ?? ""
        }
    }
    
}

//发送至邮箱
class SendEmailView: BaseView {
    
    var cblock: (() -> Void)?
    
    var sblock: (() -> Void)?
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 10
        return bgView
    }()
    
    lazy var fasongLabel: UILabel = {
        let fasongLabel = UILabel()
        fasongLabel.text = "发送至邮箱"
        fasongLabel.textAlignment = .center
        fasongLabel.font = .mediumFontOfSize(size: 14)
        fasongLabel.textColor = UIColor.init(cssStr: "#547AFF")
        return fasongLabel
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "接收邮箱:"
        nameLabel.font = .regularFontOfSize(size: 12)
        nameLabel.textColor = UIColor.init(cssStr: "#333333")
        return nameLabel
    }()
    
    lazy var nameLabel1: UILabel = {
        let nameLabel1 = UILabel()
        nameLabel1.text = "报告格式:"
        nameLabel1.font = .regularFontOfSize(size: 12)
        nameLabel1.textColor = UIColor.init(cssStr: "#333333")
        return nameLabel1
    }()
    
    lazy var cycleView: UIView = {
        let cycleView = UIView()
        cycleView.layer.cornerRadius = 2
        cycleView.layer.borderWidth = 0.5
        cycleView.layer.borderColor = UIColor.init(cssStr: "#DCDCDC")?.cgColor
        return cycleView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var lineView1: UIView = {
        let lineView1 = UIView()
        lineView1.backgroundColor = UIColor.init(cssStr: "#EEEEEE")
        return lineView1
    }()
    
    lazy var tf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入接受邮箱"
        tf.keyboardType = .emailAddress
        tf.font = .mediumFontOfSize(size: 16)
        tf.textColor = UIColor.init(cssStr: "#333333")
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "pdficon")
        return icon
    }()
    
    lazy var canBtn: UIButton = {
        let canBtn = UIButton(type: .custom)
        canBtn.setTitle("取消", for: .normal)
        canBtn.setTitleColor(UIColor.init(cssStr: "#9FA4AD"), for: .normal)
        canBtn.titleLabel?.font = .regularFontOfSize(size: 15)
        return canBtn
    }()
    
    lazy var sureBtn: UIButton = {
        let sureBtn = UIButton(type: .custom)
        sureBtn.setTitle("发送", for: .normal)
        sureBtn.setTitleColor(UIColor.init(cssStr: "#307CFF"), for: .normal)
        sureBtn.titleLabel?.font = .regularFontOfSize(size: 15)
        return sureBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(fasongLabel)
        bgView.addSubview(nameLabel)
        bgView.addSubview(cycleView)
        bgView.addSubview(nameLabel1)
        bgView.addSubview(icon)
        
        bgView.addSubview(lineView)
        bgView.addSubview(lineView1)
        bgView.addSubview(canBtn)
        bgView.addSubview(sureBtn)
        cycleView.addSubview(tf)
        
        
        bgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(60)
            make.height.equalTo(268)
        }
        fasongLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview()
            make.height.equalTo(20)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(14)
            make.top.equalToSuperview().offset(57)
            make.height.equalTo(19)
        }
        cycleView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(9.5)
            make.height.equalTo(37)
        }
        tf.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.bottom.top.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
        
        nameLabel1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(14)
            make.top.equalTo(cycleView.snp.bottom).offset(20)
            make.height.equalTo(19)
        }
        
        icon.snp.makeConstraints { make in
            make.top.equalTo(nameLabel1.snp.bottom).offset(9)
            make.left.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: 112.5, height: 36.5))
        }
        
        lineView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(icon.snp.bottom).offset(23)
            make.height.equalTo(1)
        }
        lineView1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-14)
            make.width.equalTo(0.5)
        }
        canBtn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom)
            make.right.equalTo(lineView1.snp.left)
        }
        sureBtn.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom)
            make.left.equalTo(lineView1.snp.right)
        }
        
        canBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.cblock?()
        }).disposed(by: disposeBag)
        
        sureBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.sblock?()
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: rowsModel? {
        didSet {
            guard let model = model else { return }
        }
    }
    
}
