//
//  RiskNoLoginView.swift
//  问道云
//
//  Created by 何康 on 2025/2/8.
//

import UIKit

class RiskNoLoginView: BaseView {
    
    var loginBlock: (() -> Void)?

    lazy var iconImageView1: UIImageView = {
        let iconImageView1 = UIImageView()
        iconImageView1.image = UIImage(named: "wendaoimage1")
        return iconImageView1
    }()
    
    lazy var iconImageView2: UIImageView = {
        let iconImageView2 = UIImageView()
        iconImageView2.image = UIImage(named: "riskiamgewendaore")
        return iconImageView2
    }()
    
    lazy var iconImageView3: UIImageView = {
        let iconImageView3 = UIImageView()
        iconImageView3.image = UIImage(named: "loginiamgerisk")
        return iconImageView3
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconImageView1)
        addSubview(iconImageView2)
        addSubview(iconImageView3)
        
        iconImageView1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset((SCREEN_WIDTH - 341) * 0.5)
            make.top.equalToSuperview().offset(18.5)
            make.size.equalTo(CGSize(width: 341, height: 108))
        }
        iconImageView2.snp.makeConstraints { make in
            make.centerX.equalTo(iconImageView1.snp.centerX)
            make.top.equalTo(iconImageView1.snp.bottom).offset(18.5)
            make.size.equalTo(CGSize(width: 355, height: 276))
        }
        iconImageView3.snp.makeConstraints { make in
            make.centerX.equalTo(iconImageView1.snp.centerX)
            make.top.equalTo(iconImageView2.snp.bottom).offset(111)
            make.size.equalTo(CGSize(width: 119, height: 43))
        }
        iconImageView3
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.loginBlock?()
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
