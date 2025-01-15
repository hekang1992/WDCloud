//
//  PeopleDetailHeadView.swift
//  问道云
//
//  Created by 何康 on 2025/1/15.
//

import UIKit

class PeopleDetailHeadView: BaseView {

    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        return iconImageView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#111111")
        namelabel.textAlignment = .left
        namelabel.font = .mediumFontOfSize(size: 16)
        return namelabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineView)
        addSubview(iconImageView)
        addSubview(namelabel)
        
        lineView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(1)
        }
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(11.5)
            make.top.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        namelabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(iconImageView.snp.right).offset(6)
            make.height.equalTo(22.5)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
