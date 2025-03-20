//
//  PropertyListViewCell.swift
//  问道云
//
//  Created by Andrew on 2025/3/14.
//

import UIKit
import SkeletonView

class PropertyListViewCell: BaseViewCell {
    
    //监控block
    var monitoringBlock: (() -> Void)?
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.isSkeletonable = true
        return logoImageView
    }()
    
    lazy var namelabel: UILabel = {
        let namelabel = UILabel()
        namelabel.textColor = UIColor.init(cssStr: "#333333")
        namelabel.textAlignment = .left
        namelabel.font = .mediumFontOfSize(size: 15)
        namelabel.isSkeletonable = true
        return namelabel
    }()
    
    lazy var monitoringBtn: UIButton = {
        let monitoringBtn = UIButton(type: .custom)
        monitoringBtn.setImage(UIImage(named: "propertymongijan"), for: .normal)
        monitoringBtn.isSkeletonable = true
        return monitoringBtn
    }()
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = .init(cssStr: "#F2F8FF")
        coverView.layer.cornerRadius = 2
        coverView.layer.masksToBounds = true
        coverView.isSkeletonable = true
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
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textColor = .init(cssStr: "#3F96FF")
        numLabel.textAlignment = .left
        numLabel.font = .regularFontOfSize(size: 13)
        return numLabel
    }()
    
    lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textColor = .init(cssStr: "#3F96FF")
        moneyLabel.textAlignment = .left
        moneyLabel.font = .regularFontOfSize(size: 13)
        return moneyLabel
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(PropertyLineListViewCell.self, forCellWithReuseIdentifier: "PropertyLineListViewCell")
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isSkeletonable = true
        return collectionView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        lineView.isSkeletonable = true
        return lineView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isSkeletonable = true
        contentView.addSubview(logoImageView)
        contentView.addSubview(namelabel)
        contentView.addSubview(monitoringBtn)
        contentView.addSubview(coverView)
        coverView.addSubview(desclabel)
        coverView.addSubview(numLabel)
        coverView.addSubview(moneyLabel)
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
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(desclabel.snp.right).offset(2)
            make.height.equalTo(18.5)
        }
        moneyLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(numLabel.snp.right).offset(2)
            make.height.equalTo(18.5)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(coverView.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview()
            make.height.equalTo(0)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(5)
            make.bottom.equalToSuperview()
        }
        
        monitoringBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.monitoringBlock?()
        }).disposed(by: disposeBag)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: DataModel? {
        didSet {
            guard let model = model else { return }
            
            self.collectionView.reloadData()
            
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
            
            numLabel.attributedText = GetRedStrConfig.getRedStr(from: "0", fullText: "当前财产线索0条,", colorStr: "#FF4D4F", font: UIFont.regularFontOfSize(size: 13))
            moneyLabel.attributedText = GetRedStrConfig.getRedStr(from: "0", fullText: "预估价值0万元", colorStr: "#FF4D4F", font: UIFont.regularFontOfSize(size: 13))
            
            let cluesDataList = model.cluesDataList ?? []
            if cluesDataList.isEmpty {
                collectionView.snp.updateConstraints { make in
                    make.top.equalTo(coverView.snp.bottom)
                    make.height.equalTo(0)
                }
            }else {
                collectionView.snp.updateConstraints { make in
                    make.top.equalTo(coverView.snp.bottom).offset(8)
                    make.height.equalTo(80)
                }
            }
        }
    }
    
}

extension PropertyListViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.model?.cluesDataList?.count ?? 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PropertyLineListViewCell", for: indexPath) as! PropertyLineListViewCell
        let model = self.model?.cluesDataList?[indexPath.row]
        cell.model = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 80)
    }
    
}
