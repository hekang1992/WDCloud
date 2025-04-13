//
//  SearchInvoiceCell.swift
//  问道云
//
//  Created by Andrew on 2024/12/16.
//

import UIKit
import RxRelay

class SearchInvoiceCell: BaseViewCell {
    
    var model = BehaviorRelay<pageDataModel?>(value: nil)

    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.layer.cornerRadius = 4
        return iconImageView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .left
        mlabel.font = .regularFontOfSize(size: 20)
        return mlabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconImageView)
        contentView.addSubview(mlabel)
        contentView.addSubview(lineView)
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 32, height: 32))
            make.left.equalToSuperview().offset(15)
        }
        mlabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.height.equalTo(40)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-5)
        }
        lineView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            let logoColor = model.orgInfo?.logoColor ?? ""
            iconImageView.image = UIImage.imageOfText(model.orgInfo?.orgName ?? "", size: (40, 40), bgColor: UIColor.init(cssStr: logoColor)!)
            mlabel.text = model.orgInfo?.orgName ?? ""
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
