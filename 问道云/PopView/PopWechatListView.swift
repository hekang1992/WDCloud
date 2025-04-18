//
//  PopWechatListView.swift
//  问道云
//
//  Created by 何康 on 2025/4/15.
//

import UIKit

class PopWechatListView: BaseView {
    
    var cancelBlock: (() -> Void)?
    var saveBlock: (() -> Void)?
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 5
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "公众号"
        titleLabel.textColor = .init(cssStr: "#333333")
        titleLabel.font = .mediumFontOfSize(size: 16)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        return ctImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#999999")
        nameLabel.font = .regularFontOfSize(size: 21)
        nameLabel.textAlignment = .center
        return nameLabel
    }()
    
    lazy var saveBtn: UIButton = {
        let saveBtn = UIButton(type: .custom)
        saveBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")
        saveBtn.setTitle("保存到本地", for: .normal)
        saveBtn.setTitleColor(.white, for: .normal)
        saveBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        saveBtn.layer.cornerRadius = 3
        return saveBtn
    }()
    
    lazy var cancelBtn: UIButton = {
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.backgroundColor = UIColor.init(cssStr: "#547AFF")?.withAlphaComponent(0.1)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.init(cssStr: "#547AFF"), for: .normal)
        cancelBtn.titleLabel?.font = .regularFontOfSize(size: 14)
        cancelBtn.layer.cornerRadius = 3
        return cancelBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.addSubview(titleLabel)
        bgView.addSubview(ctImageView)
        bgView.addSubview(nameLabel)
        bgView.addSubview(saveBtn)
        bgView.addSubview(cancelBtn)
        
        bgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 315.pix(), height: 346.pix()))
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.height.equalTo(22.5)
            make.left.right.equalToSuperview()
        }
        ctImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(36)
            make.size.equalTo(CGSize(width: 150.pix(), height: 150.pix()))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.top.equalTo(ctImageView.snp.bottom).offset(18)
        }
        saveBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(22)
            make.size.equalTo(CGSize(width: 130.pix(), height: 37.pix()))
            make.top.equalTo(nameLabel.snp.bottom).offset(36.pix())
        }
        cancelBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-22)
            make.size.equalTo(CGSize(width: 130.pix(), height: 37.pix()))
            make.top.equalTo(nameLabel.snp.bottom).offset(36.pix())
        }
        
        cancelBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.cancelBlock?()
        }).disposed(by: disposeBag)
        
        saveBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.saveBlock?()
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
