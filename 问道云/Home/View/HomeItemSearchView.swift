//
//  HomeItemSearchView.swift
//  问道云
//
//  Created by Andrew on 2025/2/10.
//

import UIKit

class HomeItemSearchView: BaseView {
    
    lazy var cycleView: UIView = {
        let cycleView = UIView()
        cycleView.layer.cornerRadius = 4
        cycleView.backgroundColor = .init(cssStr: "#F5F5F5")
        return cycleView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "searchiconf")
        return ctImageView
    }()
    
    lazy var searchTx: UITextField = {
        let searchTx = UITextField()
        searchTx.font = UIFont.mediumFontOfSize(size: 14)
        searchTx.textColor = UIColor.init(cssStr: "#333333")
        searchTx.clearButtonMode = .whileEditing
        return searchTx
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cycleView)
        cycleView.addSubview(ctImageView)
        cycleView.addSubview(searchTx)
        cycleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(5)
        }
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 17, height: 17))
            make.left.equalToSuperview().offset(10)
        }
        searchTx.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.right.equalToSuperview().offset(-4)
            make.left.equalTo(ctImageView.snp.right).offset(10)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
