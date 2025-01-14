//
//  CompanyThreeHeadView.swift
//  问道云
//
//  Created by 何康 on 2025/1/13.
//

import UIKit

class CompanyThreeHeadView: BaseView {

    //股东view
    lazy var shareholderView: UIView = {
        let shareholderView = UIView()
        shareholderView.backgroundColor = .random()
        return shareholderView
    }()

    //人员view
    lazy var peopleView: UIView = {
        let peopleView = UIView()
        peopleView.backgroundColor = .random()
        return peopleView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(shareholderView)
        addSubview(peopleView)
        addSubview(lineView)
        shareholderView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(86)
        }
        peopleView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(shareholderView.snp.bottom)
            make.height.equalTo(68)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(4)
            make.top.equalTo(peopleView.snp.bottom).offset(6)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
