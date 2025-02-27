//
//  CompanyDescInfoView.swift
//  问道云
//
//  Created by Andrew on 2025/1/14.
//

import UIKit

class CompanyDescInfoView: BaseView {
    
    lazy var oneBgView: UIView = {
        let oneBgView = UIView()
        oneBgView.backgroundColor = .init(cssStr: "#000000")?.withAlphaComponent(0.25)
        return oneBgView
    }()
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
    }()
    
    lazy var desLabel: UILabel = {
        let desLabel = UILabel()
        desLabel.font = .regularFontOfSize(size: 12)
        desLabel.textColor = .init(cssStr: "#666666")
        desLabel.textAlignment = .left
        desLabel.numberOfLines = 0
        return desLabel
    }()

    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "headrightoneicon")
        return icon
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.text = "特别提示：数据来源是基于公开信息通过风险模型大数据分析后的结果，风险等级是基于具体身份、处罚结果的严重程度进行的判断，仅供用户参考，并不代表问道云的任何明示、暗示之观点或保证。"
        mlabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        mlabel.textAlignment = .left
        mlabel.font = .regularFontOfSize(size: 9)
        mlabel.numberOfLines = 0
        return mlabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(oneBgView)
        addSubview(whiteView)
        addSubview(desLabel)
        addSubview(icon)
        addSubview(mlabel)
        oneBgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        desLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16.5)
            make.right.equalToSuperview().offset(-17)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1000)
        }
        icon.snp.makeConstraints { make in
            make.top.equalTo(desLabel.snp.bottom).offset(18)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 28, height: 28))
        }
        mlabel.snp.makeConstraints { make in
            make.centerY.equalTo(icon.snp.centerY)
            make.width.equalTo(SCREEN_WIDTH - 57)
            make.left.equalTo(icon.snp.right).offset(7)
        }
        whiteView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(mlabel.snp.bottom).offset(10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
