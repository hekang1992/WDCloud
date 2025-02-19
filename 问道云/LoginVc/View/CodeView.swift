//
//  CodeView.swift
//  问道云
//
//  Created by 何康 on 2024/12/3.
//

import UIKit

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
    
    lazy var codeInputView: WLUnitField = {
        let codeInputView = WLUnitField(inputUnitCount: 6)
        codeInputView.borderRadius = 5
        codeInputView.borderWidth = 0.5
        codeInputView.trackTintColor = UIColor.init(cssStr: "#547AFF")
        codeInputView.cursorColor = UIColor.init(cssStr: "#547AFF")
        codeInputView.textFont = UIFont.mediumFontOfSize(size: 50)
        codeInputView.textColor = UIColor.init(cssStr: "#27344C")
        codeInputView.delegate = self
        return codeInputView
    }()
    
    lazy var resendBtn: UIButton = {
        let resendBtn = UIButton(type: .custom)
        resendBtn.setTitleColor(UIColor.init(cssStr: "#BDBDBD"), for: .normal)
        resendBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        return resendBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backBtn)
        addSubview(label1)
        addSubview(pLabel)
        addSubview(codeInputView)
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
        codeInputView.snp.makeConstraints { make in
            make.top.equalTo(pLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(25)
            make.height.equalTo(67)
        }
        resendBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(codeInputView.snp.bottom).offset(48)
            make.size.equalTo(CGSize(width: 115.pix(), height: 17))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CodeView: WLUnitFieldDelegate {
    
    func unitField(_ uniField: WLUnitField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var codeStr = uniField.text ?? ""
        if range.location >= codeStr.count {
            codeStr.append(string)
        } else {
            codeStr.replaceSubrange(Range(range, in: codeStr)!, with: string)
        }
        if codeStr.count == 6 {
            self.codeBlock?(codeStr)
        }
        return true
    }
    
}
