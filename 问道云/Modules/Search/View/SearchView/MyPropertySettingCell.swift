//
//  MyPropertySettingCell.swift
//  问道云
//
//  Created by Andrew on 2025/2/20.
//

import UIKit
import RxRelay

class MyPropertySettingCell: BaseViewCell {
    
    var block: ((UIButton) -> Void)?
    
    var model = BehaviorRelay<propertyTypeSettingModel?>(value: nil)
    
    var model1 = BehaviorRelay<propertyTypeSettingModel?>(value: nil)
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.textColor = UIColor.init(cssStr: "#666666")
        mlabel.textAlignment = .left
        mlabel.font = .regularFontOfSize(size: 12)
        mlabel.numberOfLines = 0
        return mlabel
    }()
    
    lazy var checkBtn: UIButton = {
        let checkBtn = UIButton()
        checkBtn.setImage(UIImage(named: "agreeselimage"), for: .normal)
        return checkBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(mlabel)
        contentView.addSubview(checkBtn)
        mlabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.right.equalTo(checkBtn.snp.left).offset(-8)
            make.bottom.equalToSuperview().offset(-12)
        }
        checkBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-3)
            make.centerY.equalTo(mlabel.snp.centerY)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        
        checkBtn
            .rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.block?(checkBtn)
            }).disposed(by: disposeBag)
        
        model
            .asObservable()
            .subscribe(onNext: { [weak self] model in
                guard let self = self, let model = model else { return }
                let select = model.select ?? 0
                if select == 1 {
                    checkBtn.setImage(UIImage(named: "agreeselimage"), for: .normal)
                } else {
                    checkBtn.setImage(UIImage(named: "agreenorimage"), for: .normal)
                }
            }).disposed(by: disposeBag)
        
        model1
            .asObservable()
            .subscribe(onNext: { [weak self] model in
                guard let self = self, let model = model else { return }
                let select = model.select ?? 0
                if select == 1 {
                    checkBtn.setImage(UIImage(named: "agreeselimage"), for: .normal)
                } else {
                    checkBtn.setImage(UIImage(named: "agreenorimage"), for: .normal)
                }
            }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
