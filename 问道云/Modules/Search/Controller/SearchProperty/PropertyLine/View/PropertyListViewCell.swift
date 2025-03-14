//
//  PropertyListViewCell.swift
//  问道云
//
//  Created by 何康 on 2025/3/14.
//

import UIKit

class PropertyListViewCell: BaseViewCell {
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        return logoImageView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .mediumFontOfSize(size: 15)
        return namelabel
    }()
    
    lazy var monitoringBtn: UIButton = {
        let monitoringBtn = UIButton(type: .custom)
        monitoringBtn.setImage(UIImage(named: "propertymongijan"), for: .normal)
        return monitoringBtn
    }()
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = .init(cssStr: "#F2F8FF")
        coverView.layer.cornerRadius = 2
        coverView.layer.masksToBounds = true
        return coverView
    }()
    
    lazy var desclabel: UILabel = {
        let desclabel = UILabel()
        desclabel.textColor = UIColor.init(cssStr: "#666666")
        desclabel.textAlignment = .left
        desclabel.text = "财产状况:"
        desclabel.font = .regularFontOfSize(size: 13)
        return desclabel
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .random()
        collectionView.register(HomeItemViewCell.self, forCellWithReuseIdentifier: "HomeItemViewCell")
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(logoImageView)
        contentView.addSubview(namelabel)
        contentView.addSubview(monitoringBtn)
        contentView.addSubview(coverView)
        coverView.addSubview(desclabel)
        contentView.addSubview(collectionView)
        contentView.addSubview(lineView)
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        namelabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView.snp.centerY)
            make.left.equalTo(logoImageView.snp.right).offset(6)
            make.right.equalToSuperview().offset(-80)
            make.height.equalTo(22)
        }
        monitoringBtn.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView.snp.centerY)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(19)
        }
        coverView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(30.5)
            make.top.equalTo(logoImageView.snp.bottom).offset(8)
        }
        desclabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(6.5)
            make.size.equalTo(CGSize(width: 65, height: 18.5))
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(coverView.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview()
            make.height.equalTo(0)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(14)
            make.left.right.equalToSuperview()
            make.height.equalTo(5)
            make.bottom.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: DataModel? {
        didSet {
            guard let model = model else { return }
            let companyName = model.entityName ?? ""
            
            let logoUrl = model.logoUrl ?? ""
            
            logoImageView.kf.setImage(with: URL(string: logoUrl), placeholder: UIImage.imageOfText(companyName, size: (30, 30)))
            
            let searchStr = model.searchStr ?? ""
            
            namelabel.attributedText = GetRedStrConfig.getRedStr(from: searchStr, fullText: companyName)
            
            let monitor = model.monitor ?? false
            
            if monitor {
                monitoringBtn.setImage(UIImage(named: "propertyhavjiank"), for: .normal)
            }else {
                monitoringBtn.setImage(UIImage(named: "propertymongijan"), for: .normal)
            }
        }
    }
    
}

extension PropertyListViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 97, height: 80)
    }
    
}
