//
//  RiskView.swift
//  问道云
//
//  Created by Andrew on 2024/12/13.
//

import UIKit

class RiskView: BaseView {

    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "appheadbgimage")
        return ctImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ctImageView)
        ctImageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(StatusHeightManager.navigationBarHeight + 55)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
