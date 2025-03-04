//
//  TwoPeopleSpecListCell.swift
//  问道云
//
//  Created by Andrew on 2025/1/10.
//

import UIKit
import RxRelay

class TwoPeopleSpecListCell: BaseViewCell {
    
    var model = BehaviorRelay<itemsModel?>(value: nil)
    
    var lastView: CompanyListView?//记录公司列表信息的最后一个
    
    var height: Float = 0
    
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
    
    // 创建一个容器视图，来放置这些动态生成的listView
    let containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4.5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var cooperationLabel: UILabel = {
        let cooperationLabel = UILabel()
        cooperationLabel.textColor = .init(cssStr: "#999999")
        cooperationLabel.font = .regularFontOfSize(size: 13)
        cooperationLabel.textAlignment = .left
        cooperationLabel.text = "TA的合作伙伴:"
        return cooperationLabel
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TwoPeopleCoopViewCell.self, forCellWithReuseIdentifier: "TwoPeopleCoopViewCell")
        return collectionView
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
        contentView.addSubview(collectionView)
        
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
            make.bottom.equalToSuperview().offset(-110)
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
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(cooperationLabel.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(69.5)
        }
        
        model.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            
            let logoColor = model.logoColor ?? ""
            self.ctImageView.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.personName ?? "", size: (40, 40), bgColor: UIColor.init(cssStr: logoColor)!))
            
            nameLabel.text = model.personName ?? ""
            
            let count = String(model.companyCount ?? 0)
            self.numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "共关联\(count)家企业", font: .regularFontOfSize(size: 13))
            
            //关联公司
            if let listCompany = model.listCompany {
                configureLabels(with: listCompany)
            }
            self.collectionView.reloadData()
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TwoPeopleSpecListCell {
    
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

extension TwoPeopleSpecListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 69.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.model.value?.shareholderList?.count ?? 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TwoPeopleCoopViewCell", for: indexPath) as! TwoPeopleCoopViewCell
        let model = self.model.value?.shareholderList?[indexPath.row]
        cell.model1.accept(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.model.value?.shareholderList?[indexPath.row]
        let vc = ViewControllerUtils.findViewController(from: self)
        let peopleDetailVc = PeopleBothViewController()
        peopleDetailVc.enityId.accept(String(model?.personId ?? 0))
        peopleDetailVc.peopleName.accept(model?.personName ?? "")
        vc?.navigationController?.pushViewController(peopleDetailVc, animated: true)
    }
    
}


class CompanyListView: UIView {
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textColor = .init(cssStr: "#333333")
        numLabel.font = .regularFontOfSize(size: 13)
        numLabel.textAlignment = .left
        return numLabel
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .regularFontOfSize(size: 13)
        nameLabel.textAlignment = .right
        return nameLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(numLabel)
        addSubview(nameLabel)
        
        numLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.height.equalTo(18.5)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(numLabel.snp.right).offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(18.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
