//
//  PropertyLineTwoCell.swift
//  问道云
//
//  Created by Andrew on 2025/3/24.
//

import UIKit
import SkeletonView

class PropertyLineTwoCell: BaseViewCell {
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        return logoImageView
    }()

    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#111111")
        nameLabel.font = .mediumFontOfSize(size: 16)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textColor = .init(cssStr: "#9FA4AD")
        oneLabel.font = .regularFontOfSize(size: 12)
        oneLabel.textAlignment = .left
        return oneLabel
    }()

    lazy var tagOneLabel: PaddedLabel = {
        let tagOneLabel = PaddedLabel()
        tagOneLabel.layer.borderColor = UIColor.init(cssStr: "#3F96FF")?.cgColor
        tagOneLabel.layer.borderWidth = 1
        tagOneLabel.backgroundColor = .white
        tagOneLabel.layer.cornerRadius = 2
        tagOneLabel.textColor = .init(cssStr: "#3F96FF")
        tagOneLabel.textAlignment = .center
        tagOneLabel.font = .regularFontOfSize(size: 12)
        return tagOneLabel
    }()
    
    lazy var tagTwoLabel: PaddedLabel = {
        let tagTwoLabel = PaddedLabel()
        tagTwoLabel.layer.borderColor = UIColor.init(cssStr: "#F55B5B")?.cgColor
        tagTwoLabel.layer.borderWidth = 1
        tagTwoLabel.backgroundColor = .white
        tagTwoLabel.layer.cornerRadius = 2
        tagTwoLabel.textColor = .init(cssStr: "#F55B5B")
        tagTwoLabel.textAlignment = .center
        tagTwoLabel.font = .regularFontOfSize(size: 12)
        return tagTwoLabel
    }()
    
    lazy var clueNameLabel: UILabel = {
        let clueNameLabel = UILabel()
        clueNameLabel.textColor = .init(cssStr: "#111111")
        clueNameLabel.font = .mediumFontOfSize(size: 16)
        clueNameLabel.textAlignment = .left
        return clueNameLabel
    }()
    
    lazy var starBtn: UIButton = {
        let starBtn = UIButton(type: .custom)
        starBtn.setImage(UIImage(named: "starimge_nor"), for: .normal)
        return starBtn
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = .init(cssStr: "#868686")
        timeLabel.font = .regularFontOfSize(size: 11)
        timeLabel.textAlignment = .right
        return timeLabel
    }()
    
    lazy var oneStackView: UIStackView = {
        let oneStackView = UIStackView()
        oneStackView.axis = .vertical
        oneStackView.distribution = .equalSpacing
        oneStackView.backgroundColor = .clear
        oneStackView.spacing = 5
        return oneStackView
    }()
    
    lazy var twoStackView: UIStackView = {
        let twoStackView = UIStackView()
        twoStackView.axis = .vertical
        twoStackView.distribution = .equalSpacing
        twoStackView.spacing = 5
        return twoStackView
    }()
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.layer.cornerRadius = 2
        coverView.backgroundColor = .init(cssStr: "#F8F8F8")
        return coverView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "righticonimage")
        ctImageView.contentMode = .scaleAspectFit
        return ctImageView
    }()
    
    lazy var diImageView: UIImageView = {
        let diImageView = UIImageView()
        diImageView.image = UIImage(named: "diprpimged")
        diImageView.contentMode = .scaleAspectFit
        return diImageView
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = .init(cssStr: "#333333")
        descLabel.font = .regularFontOfSize(size: 13)
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .left
        return descLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(logoImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(oneLabel)
        contentView.addSubview(clueNameLabel)
        contentView.addSubview(tagOneLabel)
        contentView.addSubview(tagTwoLabel)
        contentView.addSubview(starBtn)
        contentView.addSubview(timeLabel)
        contentView.addSubview(oneStackView)
        contentView.addSubview(coverView)
        coverView.addSubview(twoStackView)
        twoStackView.addSubview(ctImageView)
        contentView.addSubview(diImageView)
        diImageView.addSubview(descLabel)
        contentView.addSubview(lineView)
        logoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(8)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView.snp.right).offset(4)
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(22.5)
        }
        oneLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.height.equalTo(16.5)
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalToSuperview().offset(-40)
        }
        clueNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(oneLabel.snp.bottom).offset(8)
            make.height.equalTo(20)
        }
        tagOneLabel.snp.makeConstraints { make in
            make.top.equalTo(clueNameLabel.snp.bottom).offset(2.5)
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(16.5)
        }
        tagTwoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(tagOneLabel.snp.centerY)
            make.left.equalTo(tagOneLabel.snp.right).offset(4)
            make.height.equalTo(16.5)
        }
        
        starBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14.5)
            make.right.equalToSuperview().offset(-8.5)
            make.size.equalTo(CGSize(width: 17, height: 16.5))
        }
        timeLabel.snp.makeConstraints { make in
            make.height.equalTo(15)
            make.top.equalTo(starBtn.snp.bottom).offset(6.5)
            make.right.equalToSuperview().offset(-7)
        }
        oneStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(tagOneLabel.snp.bottom).offset(4)
            make.right.equalToSuperview().offset(-12)
        }
        coverView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(oneStackView.snp.bottom).offset(4)
            make.right.equalToSuperview().offset(-12)
        }
        twoStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-10)
        }
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 18, height: 18))
        }
        diImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(coverView.snp.bottom).offset(4)
            make.size.equalTo(CGSize(width: 351.pix(), height: 76.pix()))
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(33.pix())
            make.left.equalToSuperview().offset(9.pix())
            make.right.equalToSuperview().offset(-9.pix())
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(5)
            make.top.equalTo(coverView.snp.bottom).offset(90)
            make.bottom.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: pageItemsModel? {
        didSet {
            guard let model = model else { return }
            let companyName = model.entityName ?? ""
            let logo = model.logo ?? ""
            let clueClassificationName = model.clueClassificationName ?? ""
            logoImageView.kf.setImage(with: URL(string: logo), placeholder: UIImage.imageOfText(companyName, size: (25, 25)))
            nameLabel.text = companyName
            if clueClassificationName.isEmpty {
                oneLabel.text = "当前企业的财产线索"
            }else {
                oneLabel.text = clueClassificationName
            }
            
            clueNameLabel.text = model.clueName ?? ""
            tagOneLabel.text = model.assetTypeName ?? ""
            tagTwoLabel.text = model.directionTypeName ?? ""
            timeLabel.text = model.longTimeDes ?? ""
            descLabel.text = model.explanin ?? ""
            let oneList = model.outList ?? []
            if !oneList.isEmpty {
                configureOneInfo(with: oneList)
            }else {
                oneStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            }
            
            let twoList = model.innerList ?? []
            if !twoList.isEmpty {
                twoStackView.isHidden = false
                ctImageView.isHidden = false
                coverView.isHidden = false
                configureTwoInfo(with: twoList)
            }else {
                twoStackView.isHidden = true
                ctImageView.isHidden = true
                coverView.isHidden = true
                coverView.snp.remakeConstraints { make in
                    make.left.equalToSuperview().offset(12)
                    make.top.equalTo(oneStackView.snp.bottom)
                    make.right.equalToSuperview().offset(-12)
                    make.height.equalTo(0)
                }
                twoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            }
        }
    }
    
}

extension PropertyLineTwoCell {
    
    func configureOneInfo(with dynamiccontent: [outListModel]) {
        // 清空之前的 labels
        oneStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        // 创建新的 labels
        for model in dynamiccontent {
            let label = UILabel()
            label.textColor = .init(cssStr: "#333333")
            label.textAlignment = .left
            label.font = .regularFontOfSize(size: 13)
            let name = model.itemKey ?? ""
            let persent = model.itemValue ?? ""
            label.attributedText = GetRedStrConfig.getRedStr(from: "\(persent)", fullText: "\(name): \(persent)", colorStr: "#3F96FF", font: UIFont.regularFontOfSize(size: 13))
            label.setContentHuggingPriority(.defaultLow, for: .vertical)
            oneStackView.addArrangedSubview(label)
        }
    }
    
    func configureTwoInfo(with dynamiccontent: [outListModel]) {
        // 清空之前的 labels
        twoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for model in dynamiccontent {
            let label = UILabel()
            label.textColor = .init(cssStr: "#333333")
            label.textAlignment = .left
            label.font = .regularFontOfSize(size: 13)
            let name = model.itemKey ?? ""
            let persent = model.itemValue ?? ""
            label.attributedText = GetRedStrConfig.getRedStr(from: "\(persent)", fullText: "\(name): \(persent)", colorStr: "#3F96FF", font: UIFont.regularFontOfSize(size: 13))
            label.setContentHuggingPriority(.defaultLow, for: .vertical)
            twoStackView.addArrangedSubview(label)
        }
    }
    
}
