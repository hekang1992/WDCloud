//
//  TwoRiskListPeopleCollectionViewCell.swift
//  问道云
//
//  Created by 何康 on 2025/1/11.
//

import UIKit
import RxRelay
import RxSwift

class TwoRiskListPeopleCollectionViewCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    
    var model = BehaviorRelay<itemsModel?>(value: nil)
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 4
        bgView.backgroundColor = .init(cssStr: "#F8F8F8")
        return bgView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.layer.cornerRadius = 4
        return ctImageView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .mediumFontOfSize(size: 13)
        return namelabel
    }()
    
    lazy var numlabel: UILabel = {
        let numlabel = UILabel()
        numlabel.textColor = UIColor.init(cssStr: "#999999")
        numlabel.textAlignment = .left
        numlabel.font = .mediumFontOfSize(size: 11)
        return numlabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(ctImageView)
        bgView.addSubview(namelabel)
        bgView.addSubview(numlabel)
        
        bgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(9.5)
            make.size.equalTo(CGSize(width: 153, height: 88))
        }
        
        ctImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(7)
            make.top.equalToSuperview().offset(8.5)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        
        namelabel.snp.makeConstraints { make in
            make.left.equalTo(ctImageView.snp.right).offset(5)
            make.top.equalToSuperview().offset(7.5)
            make.right.equalToSuperview().offset(-4)
        }
        numlabel.snp.makeConstraints { make in
            make.left.equalTo(namelabel.snp.left)
            make.right.equalTo(namelabel.snp.right)
            make.top.equalTo(namelabel.snp.bottom).offset(1)
            make.height.equalTo(15)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            
            ctImageView.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.name ?? "", size: (35, 35)))
            
            namelabel.text = model.name ?? ""
            
            let count = String(model.relevanceCount ?? 0)
            numlabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "TA有\(count)家企业")
            
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
