//
//  DeleteAccountViewController.swift
//  问道云
//
//  Created by 何康 on 2024/12/20.
//

import UIKit
import ActiveLabel

class DeleteAccountViewController: WDBaseViewController {
    
    var block: (() -> Void)?
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "注销账号"
        return headView
    }()
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "deleaccimge")
        return bgImageView
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var nextBtn: UIButton = {
        let nextBtn = UIButton(type: .custom)
        nextBtn.layer.cornerRadius = 3
        nextBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")
        nextBtn.setTitle("下一步", for: .normal)
        nextBtn.setTitleColor(.white, for: .normal)
        nextBtn.isEnabled = false
        nextBtn.backgroundColor = .init(cssStr: "#9FA4AD")
        nextBtn.titleLabel?.font = .regularFontOfSize(size: 16)
        return nextBtn
    }()
    
    lazy var eyeBtn: UIButton = {
        let eyeBtn = UIButton(type: .custom)
        eyeBtn.setImage(UIImage(named: "Control_nor"), for: .normal)
        eyeBtn.setImage(UIImage(named: "control_sel"), for: .selected)
        return eyeBtn
    }()
    
    lazy var yinsiLabel: ActiveLabel = {
        let yinsiLabel = ActiveLabel()
        yinsiLabel.font = .regularFontOfSize(size: 12)
        yinsiLabel.numberOfLines = 0
        yinsiLabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        yinsiLabel.text = "我已阅读并同意《问道云用户协议》条款"
        let customType1 = ActiveType.custom(pattern: "\\b《问道云用户协议》\\b")
        yinsiLabel.enabledTypes.append(customType1)
        yinsiLabel.customColor[customType1] = UIColor.init(cssStr: "#547AFF")
        yinsiLabel.customSelectedColor[customType1] = UIColor.init(cssStr: "#547AFF")
        yinsiLabel.handleCustomTap(for: customType1) { [weak self] element in
            self?.block?()
        }
        let attributedString = NSMutableAttributedString(string: yinsiLabel.text!)
        yinsiLabel.attributedText = attributedString
        return yinsiLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        view.addSubview(bgView)
        bgView.addSubview(bgImageView)
        bgView.addSubview(nextBtn)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(0.5)
            make.left.right.bottom.equalToSuperview()
        }
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(11)
            make.size.equalTo(CGSize(width: 343, height: 285))
            make.centerX.equalToSuperview()
        }
        
        nextBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-60)
            make.left.equalToSuperview().offset(25)
        }
        
        bgView.addSubview(eyeBtn)
        eyeBtn.snp.makeConstraints { make in
            make.bottom.equalTo(nextBtn.snp.top).offset(-16)
            make.left.equalTo(nextBtn.snp.left)
            make.size.equalTo(CGSize(width: 12, height: 12))
        }
        
        bgView.addSubview(yinsiLabel)
        yinsiLabel.snp.makeConstraints { make in
            make.centerY.equalTo(eyeBtn.snp.centerY)
            make.height.equalTo(15)
            make.left.equalTo(eyeBtn.snp.right).offset(5)
        }
        
        eyeBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            eyeBtn.isSelected.toggle()
            nextBtn.isEnabled = eyeBtn.isSelected
            nextBtn.backgroundColor = eyeBtn.isSelected ? UIColor.init(cssStr: "#547AFF") : UIColor.init(cssStr: "#9FA4AD")
        }).disposed(by: disposeBag)
        
        nextBtn.rx.tap.subscribe(onNext: { [weak self] in
            let delVc = DeleteSureViewController()
            self?.navigationController?.pushViewController(delVc, animated: true)
        }).disposed(by: disposeBag)
        
        self.block = { [weak self] in
            self?.pushWebPage(from: base_url + agreement_url)
        }
        
    }
    
}
