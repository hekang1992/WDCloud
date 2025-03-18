//
//  TwoPeopleNormalListCell.swift
//  问道云
//
//  Created by Andrew on 2025/1/10.
//

import UIKit
import RxRelay

class TwoPeopleNormalListCell: BaseViewCell {
    
    var model = BehaviorRelay<itemsModel?>(value: nil)
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.layer.cornerRadius = 4
        return ctImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .mediumFontOfSize(size: 15)
        nameLabel.textAlignment = .left
        return nameLabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textColor = .init(cssStr: "#999999")
        numLabel.font = .regularFontOfSize(size: 13)
        numLabel.textAlignment = .right
        return numLabel
    }()
    
    // 创建一个容器视图，来放置这些动态生成的 labels
    let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical   // 垂直排列
        stackView.spacing = 2       // label 之间的间距
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var cooperationLabel: UILabel = {
        let cooperationLabel = UILabel()
        cooperationLabel.textColor = .init(cssStr: "#999999")
        cooperationLabel.font = .regularFontOfSize(size: 13)
        cooperationLabel.textAlignment = .left
        cooperationLabel.text = "TA的合作伙伴: 暂无合作伙伴信息"
        return cooperationLabel
    }()
    
    var listViews: [CompanyListView] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        contentView.addSubview(ctImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(numLabel)
        contentView.addSubview(containerView)
        contentView.addSubview(cooperationLabel)
        
        ctImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(9)
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.left.equalTo(ctImageView.snp.right).offset(6)
            make.height.equalTo(21)
        }
        numLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(18.5)
        }
        containerView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(ctImageView.snp.bottom).offset(11)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-28.5)
        }
        
        bgView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
        
        cooperationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(containerView.snp.bottom).offset(8)
            make.height.equalTo(18.5)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            
            self.ctImageView.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.personName ?? "", size: (40, 40), bgColor: UIColor.init(cssStr: model.logoColor ?? "")!))
            
            nameLabel.text = model.personName ?? ""
            
            let count = String(model.companyCount ?? 0)
            self.numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "共关联\(count)家企业", font: .regularFontOfSize(size: 13))
            
            //关联公司
            if let listCompany = model.listCompany {
                configureLabels(with: listCompany)
            }
            
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TwoPeopleNormalListCell {
    
    func configureLabels(with data: [listCompanyModel]) {
        // 清空之前的所有 UILabel
        listViews.forEach { $0.removeFromSuperview() }
        listViews.removeAll()
        
        // 为每个数据项创建一个新的 listView
        for model in data {
            let listView = CompanyListView()
            
            let companyCountText = String(model.count ?? 0)
            
            let fullText = "\(model.province ?? "") \(companyCountText)"
            
            listView.numLabel.attributedText = GetRedStrConfig.getRedStr(from: companyCountText, fullText: fullText)
            
            listView.nameLabel.text = model.orgName ?? ""
            
            listViews.append(listView)
            listView.heightAnchor.constraint(equalToConstant: 18.5).isActive = true
            containerView.addArrangedSubview(listView)
        }
    }
    
}
