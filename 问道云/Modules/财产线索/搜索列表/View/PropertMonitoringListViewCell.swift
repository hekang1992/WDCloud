//
//  PropertMonitoringListViewCell.swift
//  问道云
//
//  Created by Andrew on 2025/3/22.
//

import UIKit
import SkeletonView

class PropertMonitoringListViewCell: BaseViewCell {
    
    var cellBlock: (() -> Void)?

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
        namelabel.numberOfLines = 0
        namelabel.isSkeletonable = true
        return namelabel
    }()
    
    lazy var monitoringBtn: UIButton = {
        let monitoringBtn = UIButton(type: .custom)
        monitoringBtn.isSkeletonable = true
        monitoringBtn.setImage(UIImage(named: "moreniacion"), for: .normal)
        return monitoringBtn
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textColor = .init(cssStr: "#666666")
        numLabel.textAlignment = .left
        numLabel.font = .regularFontOfSize(size: 13)
        return numLabel
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
        lineView.isSkeletonable = true
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isSkeletonable = true
        contentView.addSubview(logoImageView)
        contentView.addSubview(namelabel)
        contentView.addSubview(monitoringBtn)
        contentView.addSubview(numLabel)
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
            make.right.equalToSuperview().offset(-50)
        }
        monitoringBtn.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView.snp.centerY)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        numLabel.snp.makeConstraints { make in
            make.top.equalTo(namelabel.snp.bottom).offset(4)
            make.left.equalTo(namelabel.snp.left)
            make.height.equalTo(18)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(numLabel.snp.bottom)
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(SCREEN_WIDTH - 10)
            make.height.equalTo(0)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(5)
            make.bottom.equalToSuperview()
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: itemsModel? {
        didSet {
            guard let model = model else { return }
            
            self.collectionView.reloadData()
            
            let companyName = model.entityName ?? ""
            
            let logoUrl = model.logo ?? ""
            
            logoImageView.kf.setImage(with: URL(string: logoUrl), placeholder: UIImage.imageOfText(companyName, size: (30, 30)))
            
            let searchStr = model.searchStr ?? ""
            
            namelabel.attributedText = GetRedStrConfig.getRedStr(from: searchStr, fullText: companyName)
            
            let count = model.clueNum ?? ""
            numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "财产线索:\(count)条", font: UIFont.regularFontOfSize(size: 13))
            
            let cluesDataList = model.cluesDataList ?? []
            if cluesDataList.isEmpty {
                collectionView.snp.updateConstraints { make in
                    make.top.equalTo(numLabel.snp.bottom)
                    make.height.equalTo(0)
                }
            }else {
                collectionView.snp.updateConstraints { make in
                    make.top.equalTo(numLabel.snp.bottom).offset(4)
                    make.height.equalTo(80)
                }
            }
            
        }
    }
    
}

extension PropertMonitoringListViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
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
        return CGSize(width: 102.pix(), height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.cellBlock?()
    }
    
}
