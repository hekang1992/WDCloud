//
//  AddInvoiceViewCell.swift
//  问道云
//
//  Created by Andrew on 2024/12/16.
//

import UIKit
import RxRelay
import RxSwift

class AddInvoiceViewCell: BaseViewCell {
    
    var model = BehaviorRelay<DescModel?>(value: nil)
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor.init(cssStr: "#333333")
        nameLabel.font = .regularFontOfSize(size: 13)
        return nameLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#EEEEEE")
        return lineView
    }()
    
    lazy var enterTx: UITextField = {
        let enterTx = UITextField()
        enterTx.keyboardType = .default
        enterTx.font = .regularFontOfSize(size: 16)
        enterTx.textColor = UIColor.init(cssStr: "#27344B")
        return enterTx
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(enterTx)
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(18.5)
            make.width.equalTo(58.pix())
        }
        lineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(0.5)
            make.centerX.equalToSuperview()
        }
        enterTx.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(nameLabel.snp.right).offset(32)
            make.height.equalTo(42)
            make.right.equalToSuperview().offset(-10)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            nameLabel.text = model.title
            let attrString = NSMutableAttributedString(string: model.descTitle, attributes: [
                .foregroundColor: UIColor.init(cssStr: "#ACACAC") as Any,
                .font: UIFont.regularFontOfSize(size: 13)
            ])
            enterTx.attributedPlaceholder = attrString
            enterTx.text = model.text.value
        }).disposed(by: disposeBag)
        
        enterTx
            .rx
            .controlEvent(.editingChanged)
            .withLatestFrom(enterTx.rx.text.orEmpty)
            .distinctUntilChanged()
            .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.model.value?.text.accept(text)
            }).disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AddInvoiceViewCell {
    
    
    
}
