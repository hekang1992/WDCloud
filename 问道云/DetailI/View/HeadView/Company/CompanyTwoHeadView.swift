//
//  CompanyTwoHeadView.swift
//  问道云
//
//  Created by Andrew on 2025/1/13.
//

import UIKit

class CompanyTwoHeadView: BaseView {
    
    lazy var refreshBtn: UIButton = {
        let refreshBtn = UIButton(type: .custom)
        refreshBtn.setTitle("10小时前更新", for: .normal)
        refreshBtn.setImage(UIImage(named: "deiconrefgresh"), for: .normal)
        refreshBtn.setTitleColor(.init(cssStr: "#666666"), for: .normal)
        refreshBtn.titleLabel?.font = .regularFontOfSize(size: 10)
        return refreshBtn
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setImage(UIImage(named: "dephoneicon"), for: .normal)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setImage(UIImage(named: "siteguanwangicon"), for: .normal)
        return twoBtn
    }()
    
    lazy var threeBtn: UIButton = {
        let threeBtn = UIButton(type: .custom)
        threeBtn.setImage(UIImage(named: "wechatgongcicon"), for: .normal)
        return threeBtn
    }()
    
    lazy var fourBtn: UIButton = {
        let fourBtn = UIButton(type: .custom)
        fourBtn.setImage(UIImage(named: "emailiconim"), for: .normal)
        return fourBtn
    }()
    
    lazy var fiveBtn: UIButton = {
        let fiveBtn = UIButton(type: .custom)
        fiveBtn.setImage(UIImage(named: "addressiconim"), for: .normal)
        return fiveBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(refreshBtn)
        addSubview(oneBtn)
        addSubview(twoBtn)
        addSubview(threeBtn)
        addSubview(fourBtn)
        addSubview(fiveBtn)
        addSubview(lineView)
        
        refreshBtn.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
        }
        oneBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(refreshBtn.snp.right).offset(9.5)
            make.size.equalTo(CGSize(width: 45, height: 22))
        }
        twoBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(oneBtn.snp.right).offset(5)
            make.size.equalTo(CGSize(width: 46.5, height: 22))
        }
        threeBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(twoBtn.snp.right).offset(5)
            make.size.equalTo(CGSize(width: 58.5, height: 22))
        }
        fourBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(threeBtn.snp.right).offset(5)
            make.size.equalTo(CGSize(width: 46.5, height: 22))
        }
        fiveBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(fourBtn.snp.right).offset(5)
            make.size.equalTo(CGSize(width: 46.5, height: 22))
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(4)
            make.top.equalTo(fiveBtn.snp.bottom).offset(6)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
