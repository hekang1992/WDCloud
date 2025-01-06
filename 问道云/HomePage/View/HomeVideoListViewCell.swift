//
//  HomeVideoListViewCell.swift
//  问道云
//
//  Created by 何康 on 2025/1/5.
//

import UIKit
import RxRelay

class HomeVideoListViewCell: BaseViewCell {

    var model = BehaviorRelay<rowsModel?>(value: nil)

    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.layer.cornerRadius = 4
        iconImageView.layer.masksToBounds = true
        iconImageView.contentMode = .scaleAspectFill
        return iconImageView
    }()
    
    lazy var vImageView: UIImageView = {
        let vImageView = UIImageView()
        vImageView.image = UIImage(named: "videoimagep")
        return vImageView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .mediumFontOfSize(size: 13)
        titleLabel.textColor = UIColor.init(cssStr: "#333333")
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 2
        return titleLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = .regularFontOfSize(size: 12)
        descLabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        descLabel.textAlignment = .left
        descLabel.numberOfLines = 2
        return descLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconImageView)
        iconImageView.addSubview(vImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(lineView)
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12.5)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 70, height: 70))
            make.bottom.equalToSuperview().offset(-20)
        }
        vImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(12.5)
            make.top.equalToSuperview().offset(12.5)
            make.right.equalToSuperview().offset(-17)
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.right.equalToSuperview().offset(-17)
        }
        
        lineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16.5)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            iconImageView.kf.setImage(with: URL(string: model.pic ?? ""))
            titleLabel.text = model.title ?? ""
            descLabel.text = model.summary ?? ""
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
