//
//  DiligenceListViewController.swift
//  问道云
//
//  Created by Andrew on 2024/12/13.
//

import UIKit

class DiligenceListViewController: WDBaseViewController {
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "duenoolgonimge")
        return oneImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "noimgemdesclim")
        return twoImageView
    }()
    
    lazy var threeImageView: UIImageView = {
        let threeImageView = UIImageView()
        threeImageView.isUserInteractionEnabled = true
        threeImageView.image = UIImage(named: "loginiamgerisk")
        return threeImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(oneImageView)
        view.addSubview(twoImageView)
        view.addSubview(threeImageView)
        
        oneImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset((SCREEN_WIDTH - 325) * 0.5)
            make.top.equalToSuperview().offset(25)
            make.size.equalTo(CGSize(width: 325, height: 94))
        }
        twoImageView.snp.makeConstraints { make in
            make.centerX.equalTo(oneImageView.snp.centerX)
            make.top.equalTo(oneImageView.snp.bottom).offset(20.5)
            make.size.equalTo(CGSize(width: 352, height: 347))
        }
        threeImageView.snp.makeConstraints { make in
            make.centerX.equalTo(oneImageView.snp.centerX)
            make.size.equalTo(CGSize(width: 119, height: 43))
            make.top.equalTo(twoImageView.snp.bottom).offset(32)
        }
        
        threeImageView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.popLogin()
        }).disposed(by: disposeBag)
        
    }


}
