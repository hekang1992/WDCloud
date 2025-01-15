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

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ctImageView)
        addSubview(lineView)
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
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
