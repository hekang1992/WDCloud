//
//  AddPropertyUnioCell.swift
//  问道云
//
//  Created by Andrew on 2025/3/28.
//

import UIKit

class AddPropertyUnioCell: BaseViewCell {
    
    var cellCompanyBlock: ((rowsModel) -> Void)?
    var cellPeopleBlock: ((rowsModel) -> Void)?

    var model: rowsModel? {
        didSet {
            guard let model = model else { return }
            //企业
            let name = model.entityName ?? ""
            ctImageView.image = UIImage.imageOfText(name, size: (24, 24))
            nameLabel.text = name
            let companyRelation = model.companyRelation ?? false
            unioBtn.isSelected = companyRelation
            //人员
            let peopleName = model.legalName ?? ""
            peopleImageView.image = UIImage.imageOfText(peopleName, size: (24, 24))
            namePeopleLabel.text = peopleName
            descPeopleLabel.text = model.legalType ?? ""
            let personRelation = model.personRelation ?? false
            unioPeopleBtn.isSelected = personRelation
        }
    }
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        return ctImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.textAlignment = .left
        nameLabel.font = .mediumFontOfSize(size: 13)
        nameLabel.numberOfLines = 0
        return nameLabel
    }()
    
    lazy var unioBtn: UIButton = {
        let unioBtn = UIButton(type: .custom)
        unioBtn.setImage(UIImage(named: "goaddunioimge"), for: .normal)
        unioBtn.setImage(UIImage(named: "haveunioimge"), for: .selected)
        return unioBtn
    }()
    
    lazy var peopleImageView: UIImageView = {
        let peopleImageView = UIImageView()
        return peopleImageView
    }()
    
    lazy var namePeopleLabel: UILabel = {
        let namePeopleLabel = UILabel()
        namePeopleLabel.textColor = .init(cssStr: "#333333")
        namePeopleLabel.textAlignment = .left
        namePeopleLabel.font = .mediumFontOfSize(size: 13)
        namePeopleLabel.numberOfLines = 0
        return namePeopleLabel
    }()
    
    lazy var descPeopleLabel: UILabel = {
        let descPeopleLabel = UILabel()
        descPeopleLabel.textColor = .init(cssStr: "#666666")
        descPeopleLabel.textAlignment = .left
        descPeopleLabel.font = .regularFontOfSize(size: 12)
        return descPeopleLabel
    }()
    
    lazy var unioPeopleBtn: UIButton = {
        let unioPeopleBtn = UIButton(type: .custom)
        unioPeopleBtn.setImage(UIImage(named: "goaddunioimge"), for: .normal)
        unioPeopleBtn.setImage(UIImage(named: "haveunioimge"), for: .selected)
        return unioPeopleBtn
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var lineView1: UIView = {
        let lineView1 = UIView()
        lineView1.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView1
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(ctImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(unioBtn)
        
        contentView.addSubview(peopleImageView)
        contentView.addSubview(namePeopleLabel)
        contentView.addSubview(descPeopleLabel)
        contentView.addSubview(unioPeopleBtn)
        
        contentView.addSubview(lineView)
        contentView.addSubview(lineView1)
        ctImageView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.left.equalTo(ctImageView.snp.right).offset(6)
            make.right.equalToSuperview().offset(-60)
        }
        unioBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-13)
            make.height.equalTo(19)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        peopleImageView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        namePeopleLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.left.equalTo(peopleImageView.snp.right).offset(6)
            make.right.equalToSuperview().offset(-60)
        }
        descPeopleLabel.snp.makeConstraints { make in
            make.left.equalTo(namePeopleLabel.snp.left)
            make.top.equalTo(namePeopleLabel.snp.bottom).offset(1.5)
            make.height.equalTo(16.5)
        }
        unioPeopleBtn.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-13)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-15)
        }
        lineView1.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(4)
        }
        
        unioBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self, let model = model else { return  }
            self.cellCompanyBlock?(model)
        }).disposed(by: disposeBag)
        
        unioPeopleBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self, let model = model else { return  }
            self.cellPeopleBlock?(model)
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
