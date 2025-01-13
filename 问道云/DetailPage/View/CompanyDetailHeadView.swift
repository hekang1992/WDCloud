//
//  CompanyDetailHeadView.swift
//  问道云
//
//  Created by 何康 on 2025/1/13.
//

import UIKit

class CompanyDetailHeadView: BaseView {

    lazy var oneHeadView: CompanyOneHeadView = {
        let oneHeadView = CompanyOneHeadView()
        return oneHeadView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(oneHeadView)
        oneHeadView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(210)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
