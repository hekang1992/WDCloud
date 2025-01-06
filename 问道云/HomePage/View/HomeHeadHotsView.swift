//
//  HomeHeadHotsView.swift
//  问道云
//
//  Created by 何康 on 2025/1/5.
//

import UIKit

class HomeHeadHotsView: BaseView {
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "hotwordsimage")
        return ctImageView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .white
        lineView.layer.cornerRadius = 0.5
        return lineView
    }()
    
    lazy var oneView: UIView = {
        let oneView = UIView()
        oneView.backgroundColor = .random()
        return oneView
    }()
    
    //刷新按钮
    lazy var refreshImageView: UIImageView = {
        let refreshImageView = UIImageView()
        refreshImageView.isUserInteractionEnabled = true
        refreshImageView.image = UIImage(named: "refreshbtnimagehome")
        refreshImageView.contentMode = .scaleAspectFit
        return refreshImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(ctImageView)
        addSubview(lineView)
        addSubview(oneView)
        addSubview(refreshImageView)
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 25, height: 12))
        }
        lineView.snp.makeConstraints { make in
            make.left.equalTo(ctImageView.snp.right).offset(4)
            make.centerY.equalToSuperview()
            make.top.equalTo(ctImageView.snp.top).offset(0.5)
            make.width.equalTo(1)
        }
        refreshImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 18, height: 18))
        }
        oneView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview()
            make.left.equalTo(lineView.snp.right).offset(10)
            make.right.equalTo(refreshImageView.snp.left).offset(-3.5)
        }
        
        refreshImageView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
                UIView.animate(withDuration: 0.5, animations: {
                self.refreshImageView.transform = self.refreshImageView.transform.rotated(by: .pi)
            })
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
