//
//  PropertyLineInfoView.swift
//  问道云
//
//  Created by Andrew on 2025/3/22.
//

import UIKit

class PropertyLineInfoView: BaseView {

    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "xiaoxinxinimge")
        return ctImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 9
        return nameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ctImageView)
        addSubview(nameLabel)
        ctImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 13, height: 13))
            make.left.equalToSuperview().offset(2)
            make.top.equalToSuperview().offset(2)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.left.equalTo(ctImageView.snp.right).offset(4)
            make.right.equalToSuperview().offset(-6)
            make.bottom.equalToSuperview().offset(-2)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
