//
//  CompanyFiveHeadView.swift
//  问道云
//
//  Created by 何康 on 2025/1/13.
//

import UIKit

class CompanyFiveHeadView: BaseView {

    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "detaildongicon")
        return ctImageView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var timelabel: UILabel = {
        let timelabel = UILabel()
        timelabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        timelabel.textAlignment = .left
        timelabel.font = .regularFontOfSize(size: 10)
        return timelabel
    }()
    
    lazy var desclabel: UILabel = {
        let desclabel = UILabel()
        desclabel.textColor = UIColor.init(cssStr: "#333333")
        desclabel.textAlignment = .left
        desclabel.font = .mediumFontOfSize(size: 12)
        return desclabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ctImageView)
        addSubview(lineView)
        addSubview(timelabel)
        addSubview(desclabel)
        
        ctImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 18, height: 33))
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(ctImageView.snp.bottom).offset(4)
            make.height.equalTo(4)
        }
        
        timelabel.snp.makeConstraints { make in
            make.left.equalTo(ctImageView.snp.right).offset(6.5)
            make.top.equalToSuperview().offset(6.5)
            make.height.equalTo(14)
        }
        
        desclabel.snp.makeConstraints { make in
            make.left.equalTo(ctImageView.snp.right).offset(6.5)
            make.top.equalTo(timelabel.snp.bottom).offset(4)
            make.height.equalTo(16.5)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
