//
//  TwoPeopleCoopViewCell.swift
//  问道云
//
//  Created by Andrew on 2025/1/10.
//

import UIKit
import RxSwift
import RxRelay

class TwoPeopleCoopViewCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    
    var model1 = BehaviorRelay<shareholderListModel?>(value: nil)
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 4
        bgView.backgroundColor = .init(cssStr: "#F8F8F8")
        return bgView
    }()
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.layer.cornerRadius = 3
        icon.layer.masksToBounds = true
        return icon
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .mediumFontOfSize(size: 12)
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.font = .regularFontOfSize(size: 10)
        numLabel.textColor = .init(cssStr: "#999999")
        numLabel.textAlignment = .left
        return numLabel
    }()
    
    lazy var companyLabel: UILabel = {
        let companyLabel = UILabel()
        companyLabel.font = .regularFontOfSize(size: 11)
        companyLabel.textColor = .init(cssStr: "#999999")
        companyLabel.textAlignment = .left
        companyLabel.numberOfLines = 2
        return companyLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        addSubview(bgView)
        bgView.addSubview(icon)
        bgView.addSubview(nameLabel)
        bgView.addSubview(numLabel)
        bgView.addSubview(companyLabel)
        
        bgView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(115)
            make.left.equalToSuperview()
        }
        
        icon.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(7)
            make.top.equalToSuperview().offset(8)
            make.size.equalTo(CGSize(width: 26, height: 26))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(5)
            make.top.equalToSuperview().offset(6)
            make.height.equalTo(16)
            make.right.equalToSuperview().offset(-5)
        }
        
        numLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(1)
            make.height.equalTo(14)
        }
        
        companyLabel.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.left)
            make.top.equalTo(icon.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-4)
        }
        
        model1.subscribe(onNext: { [weak self] data in
            guard let self = self, let data = data else { return }
            self.icon.kf.setImage(with: URL(string: ""), placeholder: UIImage.imageOfText(data.personName ?? "", size: (26, 26)))
            self.nameLabel.text = data.personName ?? ""
            
            let companyCountText = String(data.count ?? 0)
            let fullText = "合作\(companyCountText)次"
            numLabel.attributedText = GetRedStrConfig.getRedStr(from: companyCountText, fullText: fullText, font: .regularFontOfSize(size: 10))
            companyLabel.text = data.entityName ?? ""
        }).disposed(by: disposeBag)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
