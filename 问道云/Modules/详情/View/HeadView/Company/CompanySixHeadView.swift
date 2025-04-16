//
//  CompanySixHeadView.swift
//  问道云
//
//  Created by Andrew on 2025/1/13.
//  企业详情常用服务

import UIKit
import SwiftyJSON

class CompanySixHeadView: BaseView {
    
    //常用服务
    var oneItems: [childrenModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //问道图谱
    var twoItems: [childrenModel]? {
        didSet {
            pcollectionView.reloadData()
        }
    }
    
    var dataModel: DataModel?

    lazy var oneView: UIView = {
        let oneView = UIView()
        return oneView
    }()
    
    lazy var twoView: UIView = {
        let twoView = UIView()
        return twoView
    }()
    
    //常用服务
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CompanyDetailCommonServiceCell.self, forCellWithReuseIdentifier: "CompanyDetailCommonServiceCell")
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    //问道图谱
    lazy var pcollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 4
        let pcollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        pcollectionView.delegate = self
        pcollectionView.dataSource = self
        pcollectionView.showsVerticalScrollIndicator = false
        pcollectionView.register(CompanyDetailCommonServiceCell.self, forCellWithReuseIdentifier: "CompanyDetailCommonPicCell")
        pcollectionView.showsHorizontalScrollIndicator = false
        return pcollectionView
    }()
    
    lazy var oneImageView: UIImageView = {
        let oneImageView = UIImageView()
        oneImageView.image = UIImage(named: "commonseicon")
        return oneImageView
    }()
    
    lazy var twoImageView: UIImageView = {
        let twoImageView = UIImageView()
        twoImageView.image = UIImage(named: "wenpuicon")
        return twoImageView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(oneView)
        oneView.addSubview(oneImageView)
        oneView.addSubview(collectionView)
        
        addSubview(twoView)
        twoView.addSubview(twoImageView)
        twoView.addSubview(pcollectionView)
        
        addSubview(lineView)
        
        oneView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(73)
        }
        oneImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 17, height: 61))
            make.left.equalToSuperview().offset(12)
        }
        collectionView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(oneImageView.snp.right).offset(4)
            make.height.equalTo(60)
            make.right.equalToSuperview().offset(-10)
        }
        
        twoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(oneView.snp.bottom)
            make.height.equalTo(73)
        }
        twoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 17, height: 60))
            make.left.equalToSuperview().offset(12)
        }
        pcollectionView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(twoImageView.snp.right).offset(4)
            make.height.equalTo(60)
            make.right.equalToSuperview().offset(-10)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(twoView.snp.bottom)
            make.height.equalTo(4)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CompanySixHeadView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.pcollectionView {
            return twoItems?.count ?? 0
        }else {
            return oneItems?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.pcollectionView {
            let model = self.twoItems?[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompanyDetailCommonPicCell", for: indexPath) as? CompanyDetailCommonServiceCell
            let icon = model?.iconGrey ?? ""
            cell?.bgImageView.kf.setImage(with: URL(string: icon))
            return cell ?? UICollectionViewCell()
        }else {
            let model = self.oneItems?[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompanyDetailCommonServiceCell", for: indexPath) as? CompanyDetailCommonServiceCell
            let icon = model?.iconGrey ?? ""
            cell?.bgImageView.kf.setImage(with: URL(string: icon))
            return cell ?? UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ViewControllerUtils.findViewController(from: self)
        if collectionView == self.pcollectionView {//图谱
            let model = self.twoItems?[indexPath.row]
            let pageUrl = base_url + "\(model?.path ?? "")"
            let dict = ["entityId": dataModel?.basicInfo?.orgId ?? ""]
            if pageUrl.contains("entityId") {
                vc?.pushWebPage(from: pageUrl)
            }else {
                let webUrl = URLQueryAppender.appendQueryParameters(to: pageUrl, parameters: dict) ?? ""
                vc?.pushWebPage(from: webUrl)
            }
        }else {//常用服务
            let model = self.oneItems?[indexPath.row]
            let menuId = model?.menuId ?? ""
            if menuId == "60030" {//财产线索
                let bothVc = PropertyLineBothViewController()
                let enityId = dataModel?.basicInfo?.orgId ?? ""
                let companyName = dataModel?.basicInfo?.orgName ?? ""
                bothVc.enityId.accept(enityId)
                bothVc.companyName.accept(companyName)
                bothVc.entityType = 1
                bothVc.logoUrl = dataModel?.basicInfo?.logo ?? ""
                vc?.navigationController?.pushViewController(bothVc, animated: true)
            }else if menuId == "60040" {//一键报告
                let oneRpVc = OneReportViewController()
                let orgId = dataModel?.basicInfo?.orgId ?? ""
                let orgName = dataModel?.basicInfo?.orgName ?? ""
                let json: JSON = ["orgId": orgId,
                                  "orgName": orgName]
                let orgInfo = orgInfoModel(json: json)
                oneRpVc.orgInfo = orgInfo
                vc?.navigationController?.pushViewController(oneRpVc, animated: true)
            }else {
                let pageUrl = base_url + "\(model?.path ?? "")"
                let dict = ["entityId": dataModel?.basicInfo?.orgId ?? ""]
                if pageUrl.contains("entityId") {
                    vc?.pushWebPage(from: pageUrl)
                }else {
                    let webUrl = URLQueryAppender.appendQueryParameters(to: pageUrl, parameters: dict) ?? ""
                    vc?.pushWebPage(from: webUrl)
                }
                vc?.pushWebPage(from: pageUrl)
            }
            
        }
    }
    
}
