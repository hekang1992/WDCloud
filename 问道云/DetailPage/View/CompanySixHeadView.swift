//
//  CompanySixHeadView.swift
//  问道云
//
//  Created by 何康 on 2025/1/13.
//

import UIKit

class CompanySixHeadView: BaseView {

    lazy var oneView: UIView = {
        let oneView = UIView()
        return oneView
    }()
    
    lazy var twoView: UIView = {
        let twoView = UIView()
        return twoView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "commonseicon")
        return oneImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "wenpuicon")
        return twoImageView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(oneView)
        oneView.addSubview(oneImageView)
        
        addSubview(twoView)
        twoView.addSubview(twoImageView)
        
        addSubview(lineView)
        
        oneView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(73)
        }
        oneImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 17, height: 61))
            make.left.equalToSuperview().offset(12)
        }
        
        
        twoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(oneView.snp.bottom)
            make.height.equalTo(73)
        }
        twoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 17, height: 60))
            make.left.equalToSuperview().offset(12)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(twoView.snp.bottom)
            make.height.equalTo(4)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
