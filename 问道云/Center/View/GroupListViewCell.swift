//
//  GroupListViewCell.swift
//  问道云
//
//  Created by 何康 on 2025/1/3.
//

import UIKit
import RxRelay

class GroupListViewCell: BaseViewCell {
    
    var changeBlock: ((rowsModel) -> Void)?
    
    var deleteBlock: ((rowsModel) -> Void)?
    
    var model = BehaviorRelay<rowsModel?>(value: nil)
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        return iconImageView
    }()
    
    lazy var phonelabel: UILabel = {
        let phonelabel = UILabel()
        phonelabel.textColor = UIColor.init(cssStr: "#333333")
        phonelabel.textAlignment = .left
        phonelabel.font = .regularFontOfSize(size: 14)
        return phonelabel
    }()
    
    lazy var tagLabel: UILabel = {
        let tagLabel = UILabel()
        tagLabel.text = "拥有者"
        tagLabel.layer.cornerRadius = 3
        tagLabel.layer.borderWidth = 1
        tagLabel.layer.borderColor = UIColor.init(cssStr: "#4DC929")?.cgColor
        tagLabel.backgroundColor = .init(cssStr: "#4DC929")?.withAlphaComponent(0.07)
        tagLabel.textColor = .init(cssStr: "#4DC929")
        tagLabel.font = .regularFontOfSize(size: 11)
        tagLabel.textAlignment = .center
        tagLabel.isHidden = true
        return tagLabel
    }()
    
    lazy var typeLabel: UILabel = {
        let typeLabel = UILabel()
        typeLabel.text = "默认部门"
        typeLabel.textColor = .init(cssStr: "#9FA4AD")
        typeLabel.font = .regularFontOfSize(size: 11)
        typeLabel.textAlignment = .left
        return typeLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F6F6F6")
        return lineView
    }()
    
    lazy var changeBtn: UIButton = {
        let changeBtn = UIButton(type: .custom)
        changeBtn.isHidden = true
        changeBtn.setImage(UIImage(named: "changeimage"), for: .normal)
        return changeBtn
    }()
    
    lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton(type: .custom)
        deleteBtn.isHidden = true
        deleteBtn.setImage(UIImage(named: "delete_icon"), for: .normal)
        return deleteBtn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconImageView)
        contentView.addSubview(phonelabel)
        contentView.addSubview(tagLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(deleteBtn)
        contentView.addSubview(changeBtn)
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 30, height: 30))
            make.left.equalToSuperview().offset(12)
        }
        phonelabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.left.equalTo(iconImageView.snp.right).offset(11)
            make.height.equalTo(20)
        }
        tagLabel.snp.makeConstraints { make in
            make.centerY.equalTo(phonelabel.snp.centerY)
            make.left.equalTo(phonelabel.snp.right).offset(8)
            make.size.equalTo(CGSize(width: 41, height: 16))
        }
        typeLabel.snp.makeConstraints { make in
            make.left.equalTo(phonelabel.snp.left)
            make.top.equalTo(phonelabel.snp.bottom)
            make.height.equalTo(15)
            make.bottom.equalToSuperview().offset(-10)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        deleteBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        changeBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(deleteBtn.snp.left).offset(-12)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            let name = model.name ?? ""
            let username = model.username ?? ""
            iconImageView.image = UIImage.imageOfText(name, size: (30, 30))
            let phoneNumStr = GetSaveLoginInfoConfig.getPhoneNumber()
            phonelabel.text = PhoneNumberFormatter.formatPhoneNumber(phoneNumber: username)
            if phoneNumStr == username {
                tagLabel.isHidden = false
                deleteBtn.isHidden = true
                changeBtn.isHidden = true
            }else {
                tagLabel.isHidden = true
                deleteBtn.isHidden = false
                changeBtn.isHidden = false
            }
        }).disposed(by: disposeBag)
        
        changeBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self, let model = model.value else { return }
            self.changeBlock?(model)
        }).disposed(by: disposeBag)
        
        deleteBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self, let model = model.value else { return }
            self.deleteBlock?(model)
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
