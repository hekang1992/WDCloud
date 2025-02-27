//
//  CompanyDetailGDCell.swift
//  问道云
//
//  Created by Andrew on 2025/1/14.
//  股东cell

import UIKit
import RxRelay
import RxSwift

class CompanyDetailGDCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    
    var model = BehaviorRelay<shareHoldersModel?>(value: nil)
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .init(cssStr: "#F8F8F8")
        bgView.layer.cornerRadius = 2
        return bgView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .left
        mlabel.numberOfLines = 2
        mlabel.font = .mediumFontOfSize(size: 12)
        return mlabel
    }()
    
    lazy var mlabel1: UILabel = {
        let mlabel = UILabel()
        mlabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        mlabel.textAlignment = .left
        mlabel.font = .regularFontOfSize(size: 11)
        return mlabel
    }()
    
    lazy var mlabel2: UILabel = {
        let mlabel = UILabel()
        mlabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        mlabel.textAlignment = .left
        mlabel.font = .mediumFontOfSize(size: 11)
        return mlabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(mlabel)
        addSubview(mlabel1)
        addSubview(mlabel2)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mlabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(2)
        }
        mlabel1.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16.5)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(2)
            make.height.equalTo(16.5)
        }
        mlabel2.snp.makeConstraints { make in
            make.top.equalTo(mlabel1.snp.bottom)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(2)
            make.height.equalTo(16.5)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            mlabel.text = model.name ?? ""
            
            let percent = model.percent ?? ""
            mlabel1.attributedText = GetRedStrConfig.getRedStr(from: percent, fullText: "持股比例\(percent)", colorStr: "#333333")
            mlabel1.font = .regularFontOfSize(size: 11)
            
            let count = String(model.relatedNum ?? 0)
            mlabel2.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "投资\(count)家公司", colorStr: "#333333")
            mlabel2.font = .regularFontOfSize(size: 11)
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class DetailPeopleInfoCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    
    var model = BehaviorRelay<staffInfosModel?>(value: nil)
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .init(cssStr: "#F8F8F8")
        bgView.layer.cornerRadius = 2
        return bgView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .left
        mlabel.font = .mediumFontOfSize(size: 12)
        return mlabel
    }()
    
    lazy var mlabel1: UILabel = {
        let mlabel = UILabel()
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .left
        mlabel.font = .regularFontOfSize(size: 11)
        return mlabel
    }()
    
    lazy var mlabel2: UILabel = {
        let mlabel = UILabel()
        mlabel.textColor = UIColor.init(cssStr: "#9FA4AD")
        mlabel.textAlignment = .left
        mlabel.font = .mediumFontOfSize(size: 11)
        return mlabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(icon)
        addSubview(mlabel)
        addSubview(mlabel1)
        addSubview(mlabel2)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        icon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.left.equalToSuperview().offset(6)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        mlabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(icon.snp.right).offset(4)
            make.height.equalTo(18.5)
        }
        mlabel1.snp.makeConstraints { make in
            make.left.equalTo(mlabel.snp.left)
            make.top.equalTo(mlabel.snp.bottom)
            make.right.equalToSuperview().offset(-2)
            make.height.equalTo(14)
        }
        mlabel2.snp.makeConstraints { make in
            make.top.equalTo(mlabel1.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(6)
            make.height.equalTo(14)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            icon.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.name ?? "", size: (24, 24)))
            mlabel.text = model.name ?? "--"
            mlabel1.text = model.positionName ?? "--"
            let count = String(model.count ?? 0)
            mlabel2.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "关联企业\(count)家", colorStr: "#333333", font: .mediumFontOfSize(size: 11))
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
