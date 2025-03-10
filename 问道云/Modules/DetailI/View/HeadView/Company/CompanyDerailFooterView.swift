//
//  CompanyDerailFooterView.swift
//  问道云
//
//  Created by Andrew on 2025/1/13.
//

import UIKit

class CompanyDerailFooterView: BaseView {

    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: .custom)
        backBtn.setTitle("首页", for: .normal)
        backBtn.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        backBtn.setImage(UIImage(named: "首页"), for: .normal)
        backBtn.titleLabel?.font = .mediumFontOfSize(size: 10)
        return backBtn
    }()
    
    lazy var backBtn1: UIButton = {
        let backBtn1 = UIButton(type: .custom)
        backBtn1.setTitle("一键报告", for: .normal)
        backBtn1.setImage(UIImage(named: "检测-报告"), for: .normal)
        backBtn1.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        backBtn1.titleLabel?.font = .mediumFontOfSize(size: 10)
        return backBtn1
    }()
    
    lazy var backBtn2: UIButton = {
        let backBtn2 = UIButton(type: .custom)
        backBtn2.setTitle("添加监控", for: .normal)
        backBtn2.setImage(UIImage(named: "添加监控"), for: .normal)
        backBtn2.titleLabel?.font = .mediumFontOfSize(size: 10)
        backBtn2.setTitleColor(UIColor.init(cssStr: "#333333"), for: .normal)
        return backBtn2
    }()
    
    lazy var backBtn3: UIButton = {
        let backBtn3 = UIButton(type: .custom)
        backBtn3.setTitle("关注", for: .normal)
        backBtn3.setImage(UIImage(named: "添加关注"), for: .normal)
        backBtn3.titleLabel?.font = .mediumFontOfSize(size: 15)
        backBtn3.setTitleColor(UIColor.init(cssStr: "#FFFFFF"), for: .normal)
        backBtn3.backgroundColor = UIColor.init(cssStr: "#3F96FF")
        backBtn3.layer.cornerRadius = 4
        backBtn3.layer.masksToBounds = true
        return backBtn3
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(lineView)
        addSubview(backBtn)
        addSubview(backBtn1)
        addSubview(backBtn2)
        addSubview(backBtn3)
        
        lineView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        backBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(11)
            make.size.equalTo(CGSize(width: 50.pix(), height: 40.pix()))
        }
        backBtn1.snp.makeConstraints { make in
            make.top.equalTo(backBtn.snp.top)
            make.left.equalTo(backBtn.snp.right).offset(30)
            make.size.equalTo(CGSize(width: 50.pix(), height: 40.pix()))
        }
        backBtn2.snp.makeConstraints { make in
            make.top.equalTo(backBtn.snp.top)
            make.left.equalTo(backBtn1.snp.right).offset(30)
            make.size.equalTo(CGSize(width: 50.pix(), height: 40.pix()))
        }
        backBtn3.snp.makeConstraints { make in
            make.top.equalTo(backBtn.snp.top)
            make.left.equalTo(backBtn2.snp.right).offset(30)
            make.height.equalTo(45.pix())
            make.right.equalToSuperview().offset(-20)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backBtn.layoutButtonEdgeInsets(style: .top, space: 3)
        backBtn1.layoutButtonEdgeInsets(style: .top, space: 3)
        backBtn2.layoutButtonEdgeInsets(style: .top, space: 3)
        backBtn3.layoutButtonEdgeInsets(style: .left, space: 3)
    }

}
