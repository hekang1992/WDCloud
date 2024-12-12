//
//  MyDownloadSearchView.swift
//  问道云
//
//  Created by 何康 on 2024/12/12.
//

import UIKit

class MyDownloadSearchView: UIView {

    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var serachTx: UITextField = {
        let serachTx = UITextField()
        serachTx.placeholder = "请输入下载文件的名称关键词"
        serachTx.clearButtonMode = .whileEditing
        serachTx.returnKeyType = .search
        let leftViwe = UIView(frame: CGRectMake(0, 0, 40, 46))
        let searchIcon = UIImageView()
        searchIcon.image = UIImage(named: "fagnfajingicon")
        searchIcon.contentMode = .center
        searchIcon.frame = CGRect(x: 0, y: 0, width: 40, height: 46)
        leftViwe.addSubview(searchIcon)
        serachTx.leftView = leftViwe
        serachTx.leftViewMode = .always
        serachTx.backgroundColor = UIColor.init(cssStr: "#F3F3F3")
        serachTx.font = .regularFontOfSize(size: 12)
        serachTx.layer.cornerRadius = 4
        return serachTx
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(serachTx)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        serachTx.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.equalToSuperview().offset(6.5)
            make.left.equalToSuperview().offset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
