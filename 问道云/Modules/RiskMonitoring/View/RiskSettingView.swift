//
//  RiskSettingView.swift
//  问道云
//
//  Created by Andrew on 2025/2/14.
//

import UIKit

class RiskSettingView: BaseView {

    lazy var leftImageView: UIImageView = {
        let leftImageView = UIImageView()
        return leftImageView
    }()
    
    lazy var rightImageView: UIImageView = {
        let rightImageView = UIImageView()
        rightImageView.image = UIImage(named: "righticonimage")
        return rightImageView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .regularFontOfSize(size: 15)
        return namelabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(leftImageView)
        addSubview(namelabel)
        addSubview(rightImageView)
        addSubview(lineView)
        leftImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(18)
            make.size.equalTo(CGSize(width: 18, height: 18))
        }
        namelabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
            make.left.equalTo(leftImageView.snp.right).offset(8)
        }
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-25)
            make.size.equalTo(CGSize(width: 18, height: 18))
        }
        lineView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
