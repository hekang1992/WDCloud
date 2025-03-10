//
//  ServiceCenterViewCell.swift
//  问道云
//
//  Created by Andrew on 2025/2/15.
//

import UIKit
import RxRelay

class ServiceCenterViewCell: BaseViewCell {
    
    var model = BehaviorRelay<itemsModel?>(value: nil)

    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textAlignment = .left
        numLabel.font = .regularFontOfSize(size: 13)
        return numLabel
    }()
    
    lazy var desclabel: UILabel = {
        let desclabel = UILabel()
        desclabel.textColor = UIColor.init(cssStr: "#333333")
        desclabel.textAlignment = .left
        desclabel.font = .regularFontOfSize(size: 13)
        return desclabel
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "righticonimage")
        return ctImageView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(numLabel)
        contentView.addSubview(desclabel)
        contentView.addSubview(ctImageView)
        contentView.addSubview(lineView)
        numLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.5)
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(18.5)
            make.width.equalTo(20)
            make.bottom.equalToSuperview().offset(-12.5)
        }
        desclabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(numLabel.snp.right).offset(11.5)
            make.right.equalToSuperview().offset(-30)
        }
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-8)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        lineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            desclabel.text = model.title ?? ""
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
