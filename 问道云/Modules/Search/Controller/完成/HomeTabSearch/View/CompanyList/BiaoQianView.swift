//
//  BiaoQianView.swift
//  问道云
//
//  Created by Andrew on 2025/3/6.
//

import UIKit

enum ShowTimeType {
    case showTime
    case showImage
    case hide
}

class BiaoQianView: BaseView {
    
    var type: ShowTimeType = .hide
    
    var block: ((String) -> Void)?
    
    lazy var label1: UILabel = {
        let label1 = UILabel()
        label1.font = .regularFontOfSize(size: 11)
        label1.textColor = .init(cssStr: "#9FA4AD")
        label1.textAlignment = .center
        label1.isSkeletonable = true
        return label1
    }()
    
    lazy var label2: UILabel = {
        let label2 = UILabel()
        label2.numberOfLines = 0
        label2.font = .mediumFontOfSize(size: 12)
        label2.textColor = .init(cssStr: "#547AFF")
        label2.textAlignment = .center
        return label2
    }()
    
    lazy var timeLabel: PaddedLabel = {
        let timeLabel = PaddedLabel()
        timeLabel.font = .regularFontOfSize(size: 8)
        timeLabel.layer.borderWidth = 1
        timeLabel.layer.borderColor = UIColor.init(cssStr: "#9FA4AD")?.cgColor
        timeLabel.layer.cornerRadius = 1
        return timeLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#D9D9D9")
        lineView.isHidden = true
        return lineView
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "hagnyeimagede")
        return iconImageView
    }()
    
    init(frame: CGRect, enmu: ShowTimeType) {
        super.init(frame: frame)
        addSubview(label2)
        addSubview(lineView)
        if enmu == .showTime {
            addSubview(label1)
            addSubview(timeLabel)
            label1.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(15)
                make.top.equalToSuperview()
                make.height.equalTo(16.5)
            }
            timeLabel.snp.makeConstraints { make in
                make.left.equalTo(label1.snp.right).offset(2)
                make.centerY.equalTo(label1.snp.centerY)
                make.height.equalTo(13)
            }
        }else if enmu == .showImage {
            addSubview(iconImageView)
            iconImageView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
                make.size.equalTo(CGSize(width: 37, height: 16))
            }
        }else {
            addSubview(label1)
            label1.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.left.equalToSuperview()
                make.top.equalToSuperview()
                make.height.equalTo(16.5)
            }
        }
        label2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(18.5)
        }
        lineView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 0.5, height: 10))
            make.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
