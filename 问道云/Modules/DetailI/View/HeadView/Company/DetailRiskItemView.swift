//
//  DetailRiskItemView.swift
//  问道云
//
//  Created by Andrew on 2025/1/16.
//

import UIKit

class DetailRiskItemView: BaseView {
    
    var block: (() -> Void)?
    
    lazy var clickBtn: UIButton = {
        let clickBtn = UIButton(type: .custom)
        return clickBtn
    }()

    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 2
        bgView.layer.masksToBounds = true
        bgView.isUserInteractionEnabled = true
        bgView.backgroundColor = .init(cssStr: "#FCEEED")
        return bgView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .mediumFontOfSize(size: 12)
        return namelabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textColor = UIColor.init(cssStr: "#666666")
        descLabel.textAlignment = .left
        descLabel.font = .regularFontOfSize(size: 11)
        descLabel.numberOfLines = 0
        return descLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = UIColor.init(cssStr: "#666666")
        timeLabel.textAlignment = .left
        timeLabel.font = .regularFontOfSize(size: 11)
        return timeLabel
    }()
    
    lazy var numLabel: PaddedLabel = {
        let numLabel = PaddedLabel()
        numLabel.textColor = UIColor.init(cssStr: "#F55B5B")
        numLabel.textAlignment = .center
        numLabel.font = .mediumFontOfSize(size: 11)
        numLabel.layer.borderWidth = 1
        numLabel.layer.borderColor = UIColor.init(cssStr: "#F55B5B")?.cgColor
        numLabel.layer.cornerRadius = 2
        return numLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(namelabel)
        bgView.addSubview(numLabel)
        bgView.addSubview(descLabel)
        bgView.addSubview(timeLabel)
        addSubview(clickBtn)
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalTo(105)
        }
        namelabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(3.5)
            make.left.equalToSuperview().offset(4)
            make.height.equalTo(16.5)
        }
        numLabel.snp.makeConstraints { make in
            make.centerY.equalTo(namelabel.snp.centerY)
            make.left.equalTo(namelabel.snp.right).offset(4)
            make.height.equalTo(16)
        }
        descLabel.snp.makeConstraints { make in
            make.left.equalTo(namelabel.snp.left)
            make.top.equalTo(namelabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(namelabel.snp.left)
            make.height.equalTo(13)
            make.top.equalTo(descLabel.snp.bottom).offset(8)
        }
        clickBtn.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalTo(105)
        }
        
        clickBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.block?()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
