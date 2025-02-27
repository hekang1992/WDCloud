//
//  CompanyThreeHeadView.swift
//  问道云
//
//  Created by Andrew on 2025/1/13.
//

import UIKit
import RxRelay

class CompanyThreeHeadView: BaseView {
    
    var dataModel = BehaviorRelay<DataModel?>(value: nil)
    
    var shareHolders = BehaviorRelay<[shareHoldersModel]>(value: [])
    
    //股东点击
    var shareHoldersBlock: ((shareHoldersModel) -> Void)?
    
    //人员点击
    var staffInfosBlock: ((staffInfosModel) -> Void)?
    
    //股东
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CompanyDetailGDCell.self, forCellWithReuseIdentifier: "CompanyDetailGDCell")
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    //人员
    lazy var pcollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        let pcollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        pcollectionView.delegate = self
        pcollectionView.dataSource = self
        pcollectionView.showsVerticalScrollIndicator = false
        pcollectionView.register(DetailPeopleInfoCell.self, forCellWithReuseIdentifier: "DetailPeopleInfoCell")
        pcollectionView.showsHorizontalScrollIndicator = false
        return pcollectionView
    }()
    
    //股东view
    lazy var shareholderView: UIView = {
        let shareholderView = UIView()
        return shareholderView
    }()

    //人员view
    lazy var peopleView: UIView = {
        let peopleView = UIView()
        return peopleView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "maingudongicon")
        return oneImageView
    }()
    
    lazy var onenumlabel: UILabel = {
        let onenumlabel = UILabel()
        onenumlabel.textColor = UIColor.init(cssStr: "#58408B")
        onenumlabel.textAlignment = .center
        onenumlabel.font = .mediumFontOfSize(size: 12)
        return onenumlabel
    }()
    
    lazy var twoNumlabel: UILabel = {
        let twoNumlabel = UILabel()
        twoNumlabel.textColor = UIColor.init(cssStr: "#58408B")
        twoNumlabel.textAlignment = .center
        twoNumlabel.font = .mediumFontOfSize(size: 12)
        return twoNumlabel
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "mainpeopicon")
        return twoImageView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(shareholderView)
        shareholderView.addSubview(oneImageView)
        oneImageView.addSubview(onenumlabel)
        shareholderView.addSubview(collectionView)
        
        addSubview(peopleView)
        peopleView.addSubview(twoImageView)
        twoImageView.addSubview(twoNumlabel)
        peopleView.addSubview(pcollectionView)
        
        addSubview(lineView)
        
        shareholderView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(86)
        }
        oneImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 17, height: 70))
            make.left.equalToSuperview().offset(12)
        }
        collectionView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(oneImageView.snp.right).offset(4)
            make.height.equalTo(70)
            make.right.equalToSuperview().offset(-10)
        }
        onenumlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 17, height: 14))
            make.bottom.equalToSuperview().offset(-4)
        }
        
        peopleView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(shareholderView.snp.bottom)
            make.height.equalTo(68)
        }
        twoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 17, height: 57))
            make.left.equalToSuperview().offset(12)
        }
        pcollectionView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(twoImageView.snp.right).offset(4)
            make.height.equalTo(57)
            make.right.equalToSuperview().offset(-10)
        }
        twoNumlabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 17, height: 14))
            make.bottom.equalToSuperview().offset(-0.5)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(4)
            make.top.equalTo(peopleView.snp.bottom).offset(6)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CompanyThreeHeadView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let model = self.dataModel.value
        if collectionView == self.pcollectionView {
            return model?.staffInfos?.count ?? 0
        }else {
            return model?.shareHolders?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.dataModel.value
        if collectionView == self.pcollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailPeopleInfoCell", for: indexPath) as? DetailPeopleInfoCell
            if let staffInfosModel = model?.staffInfos?[indexPath.row] {
                cell?.model.accept(staffInfosModel)
                self.twoNumlabel.text = String(model?.staffInfos?.count ?? 0)
            }
            return cell ?? UICollectionViewCell()
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompanyDetailGDCell", for: indexPath) as? CompanyDetailGDCell
            if let shareHolders = model?.shareHolders?[indexPath.row] {
                cell?.model.accept(shareHolders)
                self.onenumlabel.text = String(model?.shareHolders?.count ?? 0)
            }
            return cell ?? UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.pcollectionView {
            return CGSize(width: 100, height: 56.5)
        }else {
            return CGSize(width: 100, height: 69.5)
        }
    }
    
    //点击cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataModel.value
        if collectionView == self.pcollectionView {
            if let staffInfosModel = model?.staffInfos?[indexPath.row] {
                self.staffInfosBlock?(staffInfosModel)
            }
        }else {
            if let shareHolders = model?.shareHolders?[indexPath.row] {
                self.shareHoldersBlock?(shareHolders)
            }
        }
    }
    
}
