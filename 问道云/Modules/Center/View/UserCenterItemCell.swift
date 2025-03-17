//
//  UserCenterItemCell.swift
//  问道云
//
//  Created by Andrew on 2024/12/5.
//

import UIKit
import RxRelay
import RxSwift

class UserCenterItemCell: UICollectionViewCell {
    
    let disposed = DisposeBag()
    
    var model = BehaviorRelay<String>(value: "")
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        return iconImageView
    }()
    
    lazy var desclabel: UILabel = {
        let desclabel = UILabel()
        desclabel.font = .regularFontOfSize(size: 12)
        desclabel.textColor = UIColor.init(cssStr: "#333333")
        desclabel.textAlignment = .center
        return desclabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconImageView)
        addSubview(desclabel)
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 23.pix(), height: 23.pix()))
        }
        desclabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(4)
            make.left.equalToSuperview()
            make.height.equalTo(16.5.pix())
        }
        
        model.asObservable().subscribe(onNext: { [weak self] title in
            guard let self = self else { return }
            iconImageView.image = UIImage(named: title)
            desclabel.text = title
        }).disposed(by: disposed)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
