//
//  PopCancelMonitoringView.swift
//  问道云
//
//  Created by 何康 on 2025/2/8.
//  设置分组或者取消监控弹窗

import UIKit

class PopCancelMonitoringView: BaseView {
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .init(cssStr: "#F6F6F6")
        return bgView
    }()
    
    lazy var setBtn: UIButton = {
        let setBtn = UIButton(type: .custom)
        setBtn.setTitle("设置分组", for: .normal)
        setBtn.setTitleColor(.black, for: .normal)
        setBtn.titleLabel?.font = .mediumFontOfSize(size: 18)
        setBtn.backgroundColor = .white
        setBtn.setTitleColor(.black, for: .normal)
        return setBtn
    }()
    
    lazy var cancelMonBtn: UIButton = {
        let cancelMonBtn = UIButton(type: .custom)
        cancelMonBtn.setTitle("取消监控", for: .normal)
        cancelMonBtn.setTitleColor(.black, for: .normal)
        cancelMonBtn.titleLabel?.font = .mediumFontOfSize(size: 18)
        cancelMonBtn.backgroundColor = .white
        cancelMonBtn.setTitleColor(.init(cssStr: "#FF4D4F"), for: .normal)
        return cancelMonBtn
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.titleLabel?.font = .mediumFontOfSize(size: 18)
        cancelBtn.backgroundColor = .white
        return cancelBtn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(setBtn)
        bgView.addSubview(cancelMonBtn)
        bgView.addSubview(cancelBtn)
        bgView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(160)
        }
        setBtn.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(54)
        }
        cancelMonBtn.snp.makeConstraints { make in
            make.top.equalTo(setBtn.snp.bottom).offset(1)
            make.left.right.equalToSuperview()
            make.height.equalTo(54)
        }
        cancelBtn.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.setTopCorners(radius: 5)
    }
    
}

