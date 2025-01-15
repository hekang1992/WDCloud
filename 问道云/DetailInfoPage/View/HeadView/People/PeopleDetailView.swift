//
//  PeopleDetailView.swift
//  问道云
//
//  Created by 何康 on 2025/1/15.
//

import UIKit

class PeopleDetailView: BaseView {

    lazy var headView: PeopleDetailHeadView = {
        let headView = PeopleDetailHeadView()
        headView.backgroundColor = .random()
        return headView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headView)
        headView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
