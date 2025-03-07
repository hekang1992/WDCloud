//
//  TwoRiskListPeopleCollectionViewCell.swift
//  问道云
//
//  Created by Andrew on 2025/1/11.
//

import UIKit
import RxRelay
import RxSwift

class TwoRiskListPeopleCollectionViewCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    
    var model = BehaviorRelay<itemsModel?>(value: nil)
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .init(cssStr: "#F8F8F8")
        bgView.layer.cornerRadius = 4
        return bgView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        return ctImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .mediumFontOfSize(size: 15)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textColor = .init(cssStr: "#999999")
        numLabel.font = .regularFontOfSize(size: 11)
        numLabel.textAlignment = .left
        return numLabel
    }()
    
    lazy var oneListView: CompanyListView = {
        let oneListView = CompanyListView()
        return oneListView
    }()
    
    lazy var twoListView: CompanyListView = {
        let twoListView = CompanyListView()
        return twoListView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(ctImageView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(numLabel)
        bgView.addSubview(oneListView)
        bgView.addSubview(twoListView)
        bgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(9)
            make.top.equalToSuperview().offset(2)
            make.centerY.equalToSuperview()
            make.width.equalTo(153.pix())
        }
        ctImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8.5)
            make.left.equalToSuperview().offset(7)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7.5)
            make.left.equalTo(ctImageView.snp.right).offset(5)
            make.height.equalTo(21)
        }
        numLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(1)
            make.height.equalTo(15)
        }
        oneListView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(ctImageView.snp.bottom).offset(6.5)
            make.height.equalTo(15)
            make.right.equalToSuperview()
        }
        twoListView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(oneListView.snp.bottom).offset(0.5)
            make.height.equalTo(15)
            make.right.equalToSuperview()
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            let name = model.name ?? ""
            let count = String(model.orgCount ?? 0)
            ctImageView.image = UIImage.imageOfText(name, size: (35, 35))
            nameLabel.text = name
            numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "TA有\(count)家企业", font: .regularFontOfSize(size: 11))
            let provinceStatList = model.provinceStatList ?? []
            if !provinceStatList.isEmpty {
                if provinceStatList.count == 1 {
                    let model = provinceStatList[0]
                    let province = model.province ?? ""
                    let count = String(model.count ?? 0)
                    let repOrgName = model.repOrgName ?? ""
                    oneListView.numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "\(province)\(count)家")
                    oneListView.nameLabel.text = repOrgName
                }else {
                    let model = provinceStatList[0]
                    let province = model.province ?? ""
                    let count = String(model.count ?? 0)
                    let repOrgName = model.repOrgName ?? ""
                    oneListView.numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "\(province)\(count)家", font: .regularFontOfSize(size: 11))
                    oneListView.nameLabel.text = repOrgName
                    
                    let model1 = provinceStatList[1]
                    let province1 = model1.province ?? ""
                    let count1 = String(model1.count ?? 0)
                    let repOrgName1 = model1.repOrgName ?? ""
                    twoListView.numLabel.attributedText = GetRedStrConfig.getRedStr(from: count1, fullText: "\(province1)\(count1)家", font: .regularFontOfSize(size: 11))
                    twoListView.nameLabel.text = repOrgName1
                }
            }
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
