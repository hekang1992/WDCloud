//
//  CompanyActivityViewCell.swift
//  问道云
//
//  Created by Andrew on 2025/1/12.
//

import UIKit
import RxRelay

class CompanyActivityViewCell: BaseViewCell {
    
    var model = BehaviorRelay<itemsModel?>(value: nil)

    private let stackView = UIStackView()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.textAlignment = .left
        nameLabel.font = .mediumFontOfSize(size: 12)
        return nameLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = .init(cssStr: "#A1A1A1")
        timeLabel.textAlignment = .right
        timeLabel.font = .regularFontOfSize(size: 11)
        return timeLabel
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "righticonimage")
        ctImageView.contentMode = .scaleAspectFit
        return ctImageView
    }()
    
    lazy var typeLabel: PaddedLabel = {
        let typeLabel = PaddedLabel()
        typeLabel.padding = UIEdgeInsets(top: 2, left: 3, bottom: 2, right: 3)
        typeLabel.layer.cornerRadius = 1.5
        typeLabel.textAlignment = .center
        typeLabel.font = .regularFontOfSize(size: 11)
        return typeLabel
    }()
    
    lazy var cycleView: UIView = {
        let cycleView = UIView()
        cycleView.backgroundColor = UIColor.init(cssStr: "#D8D8D8")
        cycleView.layer.cornerRadius = 2.5
        return cycleView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(cssStr: "#DBDBDB")
        return lineView
    }()
    
    lazy var lineView1: UIView = {
        let lineView1 = UIView()
        lineView1.backgroundColor = UIColor.init(cssStr: "#DBDBDB")
        return lineView1
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(ctImageView)
        contentView.addSubview(cycleView)
        contentView.addSubview(lineView)
        contentView.addSubview(lineView1)
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.backgroundColor = UIColor.init(cssStr: "#F7F8FC")
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(16.5)
            make.left.equalToSuperview().offset(27.5)
            make.top.equalToSuperview().offset(16)
        }
        typeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.left.equalTo(nameLabel.snp.right).offset(6)
            make.height.equalTo(16.5)
        }
        stackView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(27.5)
            make.width.equalTo(SCREEN_WIDTH - 43.5)
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalTo(stackView.snp.centerY)
            make.right.equalTo(stackView.snp.right).offset(-8)
            make.size.equalTo(CGSize(width: 14, height: 14))
        }
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.right.equalTo(stackView.snp.right)
            make.height.equalTo(15)
        }
        cycleView.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel.snp.centerY)
            make.size.equalTo(CGSize(width: 5, height: 5))
            make.left.equalToSuperview().offset(14)
        }
        lineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalTo(cycleView.snp.centerX)
            make.width.equalTo(0.5)
            make.top.equalTo(cycleView.snp.bottom)
        }
        lineView1.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalTo(cycleView.snp.centerX)
            make.width.equalTo(0.5)
            make.bottom.equalTo(cycleView.snp.top)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            nameLabel.text = model.itemName ?? ""
            timeLabel.text = model.createtime ?? ""
            let type = model.risklevel ?? ""
            switch type {
            case "1":
                typeLabel.text = "高风险"
                typeLabel.textColor = UIColor.init(cssStr: "#F55B5B")
                typeLabel.backgroundColor = UIColor.init(cssStr: "#FEF0EF")
                break
            case "2":
                typeLabel.text = "低风险"
                typeLabel.textColor = UIColor.init(cssStr: "#4DC929")
                typeLabel.backgroundColor = UIColor.init(cssStr: "#4DC929")?.withAlphaComponent(0.1)
                break
            case "3":
                typeLabel.text = "提示信息"
                typeLabel.textColor = UIColor.init(cssStr: "#547AFF")
                typeLabel.backgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.1)
                break
            default:
                break
            }
            configure(with: model.dynamiccontent ?? [])
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with dynamiccontent: [dynamiccontentModel]) {
        // 清空之前的 labels
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        // 创建新的 labels
        for text in dynamiccontent {
            let label = UILabel()
            label.textColor = .init(cssStr: "#999999")
            label.textAlignment = .left
            label.font = .regularFontOfSize(size: 12)
            label.text = "  \(text.title ?? ""):  \(text.fieldValue ?? "")"
            label.numberOfLines = 2
//            label.heightAnchor.constraint(equalToConstant: 20).isActive = true
            label.setContentHuggingPriority(.defaultLow, for: .vertical)
            stackView.addArrangedSubview(label)
        }
    }

}
