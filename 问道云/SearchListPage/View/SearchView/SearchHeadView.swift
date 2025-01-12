//
//  SearchAllView.swift
//  问道云
//
//  Created by 何康 on 2025/1/7.
//

import UIKit

class SearchHeadView: BaseView {
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
    }()

    lazy var searchView: UIView = {
        let searchView = UIView()
        searchView.backgroundColor = .init(cssStr: "#F3F3F3")
        searchView.layer.cornerRadius = 5
        return searchView
    }()
    
    lazy var searchIcon: UIImageView = {
        let searchIcon = UIImageView()
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.image = UIImage(named: "searchiconf")
        return searchIcon
    }()
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton()
        clickBtn.setTitle("取消", for: .normal)
        clickBtn.titleLabel?.font = .regularFontOfSize(size: 15)
        clickBtn.setTitleColor(UIColor.init(cssStr: "#242424"), for: .normal)
        return clickBtn
    }()
    
    lazy var searchTx: UITextField = {
        let searchTx = UITextField()
        searchTx.font = .regularFontOfSize(size: 13)
        searchTx.textColor = .init(cssStr: "#666666")
        searchTx.clearButtonMode = .whileEditing
        searchTx.returnKeyType = .search
        searchTx.becomeFirstResponder()
        return searchTx
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(whiteView)
        whiteView.addSubview(searchView)
        searchView.addSubview(searchIcon)
        searchView.addSubview(searchTx)
        whiteView.addSubview(clickBtn)
        whiteView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(104)
        }
        searchView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-50)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(45)
        }
        searchIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(11)
            make.size.equalTo(CGSize(width: 14, height: 14))
        }
        searchTx.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalTo(searchIcon.snp.right).offset(12)
            make.top.equalToSuperview()
            make.right.equalToSuperview()
        }
        clickBtn.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.top)
            make.bottom.equalTo(searchView.snp.bottom)
            make.left.equalTo(searchView.snp.right)
            make.right.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
