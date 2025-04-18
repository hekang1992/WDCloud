//
//  CodeView.swift
//  问道云
//
//  Created by Andrew on 2024/12/3.
//

import UIKit
import KeenCodeUnit

class CodeView: BaseView {
    
    var codeBlock: ((String) -> Void)?
    
    lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "cancelImage"), for: .normal)
        return backBtn
    }()
    
    lazy var label1: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .mediumFontOfSize(size: 24)
        label.textColor = UIColor.init(cssStr: "#27344C")
        label.text = "输入短信验证码"
        return label
    }()
    
    lazy var pLabel: UILabel = {
        let pLabel = UILabel()
        pLabel.textAlignment = .left
        pLabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        return pLabel
    }()
    
    lazy var resendBtn: UIButton = {
        let resendBtn = UIButton(type: .custom)
        resendBtn.setTitleColor(UIColor.init(cssStr: "#BDBDBD"), for: .normal)
        resendBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        return resendBtn
    }()
    
    private var codeUnit: KeenCodeUnit!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backBtn)
        addSubview(label1)
        addSubview(pLabel)
        addSubview(resendBtn)
        
        backBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(StatusHeightManager.statusBarHeight + 2)
            make.left.equalToSuperview().offset(8.5)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        label1.snp.makeConstraints { make in
            make.height.equalTo(29)
            make.top.equalTo(backBtn.snp.bottom).offset(42)
            make.left.equalToSuperview().offset(30)
        }
        pLabel.snp.makeConstraints { make in
            make.left.equalTo(label1.snp.left)
            make.top.equalTo(label1.snp.bottom).offset(12)
            make.height.equalTo(17)
        }
        let rect = CGRect(x: 10, y: StatusHeightManager.statusBarHeight + 180, width: CGFloat.screenWidth - 20, height: 68)
        codeUnit = KeenCodeUnit(
            frame: rect,
            delegate: self
        ).addViewTo(self)
        resendBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(codeUnit.snp.bottom).offset(48)
            make.size.equalTo(CGSize(width: 115.pix(), height: 17))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CodeView: KeenCodeUnitDelegate {
    
    func attributesOfCodeUnit(for codeUnit: KeenCodeUnit) -> KeenCodeUnitAttributes {
        var attr = KeenCodeUnitAttributes()
        attr.style = .splitborder
        attr.textFont = .mediumFontOfSize(size: 50)
        attr.isSingleAlive = true
        attr.borderRadius = 5
        attr.viewBackColor = .clear
        return attr
    }
    
    func codeUnit(_ codeUnit: KeenCodeUnit, codeText: String, complete: Bool) {
        if complete {
            print("codeText====\(codeText)")
            self.codeBlock?(codeText)
        }
    }
    
}
