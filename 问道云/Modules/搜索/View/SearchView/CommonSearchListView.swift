//
//  CommonSearchListView.swift
//  问道云
//
//  Created by Andrew on 2025/1/8.
//

import UIKit
import RxSwift

class CommonSearchListView: BaseView {
    
    var block: (() -> Void)?
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        return icon
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .regularFontOfSize(size: 13)
        nameLabel.textColor = .init(cssStr: "#666666")
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.font = .regularFontOfSize(size: 12)
        timeLabel.textColor = .init(cssStr: "#999999")
        timeLabel.textAlignment = .right
        return timeLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F3F3F3")
        return lineView
    }()
    
    lazy var btn: UIButton = {
        let btn = UIButton(type: .custom)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(icon)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(lineView)
        addSubview(btn)
        icon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 22, height: 22))
            make.left.equalToSuperview().offset(10.5)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(icon.snp.right).offset(4)
            make.height.equalTo(18.5)
        }
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(SCREEN_WIDTH - 50)
            make.height.equalTo(16.5)
        }
        lineView.snp.makeConstraints { make in
            make.width.equalTo(SCREEN_WIDTH)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        btn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        btn.rx.tap.subscribe(onNext: { [weak self] in
            self?.block?()
        }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
