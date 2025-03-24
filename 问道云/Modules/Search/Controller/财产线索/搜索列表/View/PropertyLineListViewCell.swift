//
//  PropertyLineListViewCell.swift
//  问道云
//
//  Created by Andrew on 2025/3/15.
//

import UIKit

class PropertyLineListViewCell: UICollectionViewCell {
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 2
        bgView.backgroundColor = .init(cssStr: "#F8F8F8")
        return bgView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .mediumFontOfSize(size: 12)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var tagLabel: PaddedLabel = {
        let tagLabel = PaddedLabel()
        tagLabel.textColor = .init(cssStr: "#FF7D00")
        tagLabel.font = .mediumFontOfSize(size: 10)
        tagLabel.textAlignment = .center
        tagLabel.layer.cornerRadius = 2
        tagLabel.layer.borderWidth = 1
        tagLabel.layer.borderColor = UIColor.init(cssStr: "#FF7D00")?.cgColor
        return tagLabel
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.text = "类型:"
        oneLabel.textColor = .init(cssStr: "#999999")
        oneLabel.textAlignment = .left
        oneLabel.font = .regularFontOfSize(size: 12)
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.text = "线索:"
        twoLabel.textColor = .init(cssStr: "#999999")
        twoLabel.textAlignment = .left
        twoLabel.font = .regularFontOfSize(size: 12)
        return twoLabel
    }()
    
    lazy var threeLabel: UILabel = {
        let threeLabel = UILabel()
        threeLabel.text = "估值:"
        threeLabel.textColor = .init(cssStr: "#999999")
        threeLabel.textAlignment = .left
        threeLabel.font = .regularFontOfSize(size: 12)
        return threeLabel
    }()
    
    lazy var fourLabel: UILabel = {
        let fourLabel = UILabel()
        fourLabel.textColor = .init(cssStr: "#333333")
        fourLabel.font = .mediumFontOfSize(size: 12)
        fourLabel.textAlignment = .left
        return fourLabel
    }()
    
    lazy var fiveLabel: UILabel = {
        let fiveLabel = UILabel()
        fiveLabel.textColor = .init(cssStr: "#333333")
        fiveLabel.font = .mediumFontOfSize(size: 12)
        fiveLabel.textAlignment = .left
        return fiveLabel
    }()
    
    lazy var sixLabel: UILabel = {
        let sixLabel = UILabel()
        sixLabel.textColor = .init(cssStr: "#333333")
        sixLabel.font = .mediumFontOfSize(size: 12)
        sixLabel.textAlignment = .left
        return sixLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(tagLabel)
        bgView.addSubview(oneLabel)
        bgView.addSubview(twoLabel)
        bgView.addSubview(threeLabel)
        bgView.addSubview(fourLabel)
        bgView.addSubview(fiveLabel)
        bgView.addSubview(sixLabel)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.left.equalToSuperview().offset(4)
            make.size.equalTo(CGSize(width: 50.pix(), height: 16.5))
        }
        tagLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.height.equalTo(14)
            make.left.equalTo(nameLabel.snp.right).offset(4)
        }
        oneLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(2.5)
            make.height.equalTo(18)
            make.width.equalTo(30.pix())
        }
        twoLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(oneLabel.snp.bottom).offset(2)
            make.height.equalTo(18)
            make.width.equalTo(30.pix())
        }
        threeLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(twoLabel.snp.bottom).offset(2)
            make.height.equalTo(18)
            make.width.equalTo(30.pix())
        }
        fourLabel.snp.makeConstraints { make in
            make.left.equalTo(oneLabel.snp.right).offset(2)
            make.centerY.equalTo(oneLabel.snp.centerY)
            make.height.equalTo(16.5)
            make.right.equalToSuperview().offset(-1)
        }
        fiveLabel.snp.makeConstraints { make in
            make.left.equalTo(twoLabel.snp.right).offset(2)
            make.centerY.equalTo(twoLabel.snp.centerY)
            make.height.equalTo(16.5)
            make.right.equalToSuperview().offset(-1)
        }
        sixLabel.snp.makeConstraints { make in
            make.left.equalTo(threeLabel.snp.right).offset(2)
            make.centerY.equalTo(threeLabel.snp.centerY)
            make.height.equalTo(16.5)
            make.right.equalToSuperview().offset(-1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: cluesDataListModel? {
        didSet {
            guard let model = model else { return }
            nameLabel.text = model.clueDirectionName ?? ""
            tagLabel.text = model.typeTotalCount ?? ""
            let count1 = model.typeNum ?? "0"
            let count2 = model.typeTotalCount ?? "0"
            let count3 = model.typeTotalValuation ?? "0"
            let totalValuationUnit = model.totalValuationUnit ?? ""
            fourLabel.attributedText = GetRedStrConfig.getRedStr(from: count1, fullText: "\(count1)类", font: UIFont.mediumFontOfSize(size: 12))
            fiveLabel.attributedText = GetRedStrConfig.getRedStr(from: count2, fullText: "\(count2)条", font: UIFont.mediumFontOfSize(size: 12))
            sixLabel.attributedText = GetRedStrConfig.getRedStr(from: count3, fullText: "\(count3)\(totalValuationUnit)", font: UIFont.mediumFontOfSize(size: 12))
        }
    }
    
}
