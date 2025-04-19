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
        oneImageView.contentMode = .scaleAspectFit
        oneImageView.image = UIImage(named: "gudongicon")
        return oneImageView
    }()
    
    lazy var onenumlabel: UILabel = {
        let onenumlabel = UILabel()
        onenumlabel.textColor = UIColor.init(cssStr: "#58408B")
        onenumlabel.textAlignment = .center
        onenumlabel.font = .mediumFontOfSize(size: 10)
        return onenumlabel
    }()
    
    lazy var twoNumlabel: UILabel = {
        let twoNumlabel = UILabel()
        twoNumlabel.textColor = UIColor.init(cssStr: "#58408B")
        twoNumlabel.textAlignment = .center
        twoNumlabel.font = .mediumFontOfSize(size: 10)
        return twoNumlabel
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.contentMode = .scaleAspectFit
        twoImageView.image = UIImage(named: "rnoemapeopicon")
        return twoImageView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var oneView: UIView = {
        let oneView = UIView()
        oneView.backgroundColor = .init(cssStr: "#F7F8FC")
        oneView.layer.cornerRadius = 2
        return oneView
    }()
    
    lazy var twoView: UIView = {
        let twoView = UIView()
        twoView.backgroundColor = .init(cssStr: "#F7F8FC")
        twoView.layer.cornerRadius = 2
        return twoView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(shareholderView)
        shareholderView.addSubview(oneView)
        oneView.addSubview(oneImageView)
        oneImageView.addSubview(onenumlabel)
        shareholderView.addSubview(collectionView)
        
        addSubview(peopleView)
        peopleView.addSubview(twoView)
        twoView.addSubview(twoImageView)
        twoImageView.addSubview(twoNumlabel)
        peopleView.addSubview(pcollectionView)
        
        addSubview(lineView)
        
        //主要股东
        shareholderView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(86)
        }
        oneView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(7)
            make.width.equalTo(17)
        }
        oneImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 17, height: 26))
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
            make.top.equalTo(oneImageView.snp.bottom).offset(2)
        }
        
        //主要人员
        peopleView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(shareholderView.snp.bottom)
            make.height.equalTo(68)
        }
        twoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.width.equalTo(17)
        }
        twoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8.5)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 17, height: 27))
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
            make.top.equalTo(twoImageView.snp.bottom).offset(2)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(4)
            make.bottom.equalToSuperview()
        }
        
        dataModel.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model else { return }
            let shareHolders = model.shareHolders ?? []
            let srMgmtInfos = model.srMgmtInfos ?? []
            shareholderView.isHidden = shareHolders.isEmpty
            peopleView.isHidden = srMgmtInfos.isEmpty
            if shareHolders.isEmpty {
                shareholderView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
            }else {
                shareholderView.snp.updateConstraints { make in
                    make.height.equalTo(86)
                }
            }
            
            if srMgmtInfos.isEmpty {
                peopleView.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
            }else {
                peopleView.snp.updateConstraints { make in
                    make.height.equalTo(70)
                }
            }
            
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CompanyThreeHeadView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let model = self.dataModel.value
        if collectionView == self.pcollectionView {
            return model?.srMgmtInfos?.count ?? 0
        }else {
            return model?.shareHolders?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.dataModel.value
        if collectionView == self.pcollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailPeopleInfoCell", for: indexPath) as? DetailPeopleInfoCell
            if let staffInfosModel = model?.srMgmtInfos?[indexPath.row] {
                cell?.model.accept(staffInfosModel)
                self.twoNumlabel.text = String(model?.srMgmtInfos?.count ?? 0)
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
            return CGSize(width: 100.pix(), height: 57)
        }else {
            return CGSize(width: 100.pix(), height: 70)
        }
    }
    
    //点击cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataModel.value
        if collectionView == self.pcollectionView {
            if let staffInfosModel = model?.srMgmtInfos?[indexPath.row] {
                self.staffInfosBlock?(staffInfosModel)
            }
        }else {
            if let shareHolders = model?.shareHolders?[indexPath.row] {
                self.shareHoldersBlock?(shareHolders)
            }
        }
    }
    
}
