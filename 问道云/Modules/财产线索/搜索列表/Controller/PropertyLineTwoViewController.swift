//
//  PropertyLineTwoViewController.swift
//  问道云
//
//  Created by Andrew on 2025/3/21.
//  财产状况

import UIKit

class PropertyLineTwoViewController: WDBaseViewController {
    
    //ID
    var entityId: String = ""
    //名字
    var entityName: String = ""
    //是否被监控
    var monitor: Bool = false
    //logourl
    var logoUrl: String = ""
    //是否是企业
    var entityType: Int = 1
    var modelArray: [childrenModel]?
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .mediumFontOfSize(size: 16)
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.textAlignment = .left
        nameLabel.text = entityName
        return nameLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: SCREEN_WIDTH * 0.25, height: 80)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        //item
        collectionView.register(CompanyCollectionCell.self, forCellWithReuseIdentifier: "CompanyCollectionCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        //注册title标题样式
        collectionView.register(MyCollectionNormalReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyCollectionNormalReusableView.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(logoImageView)
        view.addSubview(nameLabel)
        view.addSubview(lineView)
        view.addSubview(collectionView)
        logoImageView.kf.setImage(with: URL(string: self.logoUrl), placeholder: UIImage.imageOfText(self.entityName, size: (29, 29)))
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 29, height: 29))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView.snp.centerY)
            make.left.equalTo(logoImageView.snp.right).offset(6)
            make.width.equalTo(SCREEN_WIDTH - 40)
        }
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(4)
            make.top.equalTo(nameLabel.snp.bottom).offset(11.5)
        }
        collectionView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom)
        }
        //获取列表信息
        getListInfo()
    }
    
}

extension PropertyLineTwoViewController {
    
    //获取列表信息
    private func getListInfo() {
        ViewHud.addLoadView()
        let man = RequestManager()
        let dict = ["moduleType": "8",
                    "entityType": entityType,
                    "entityId": entityId] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/customermenu/customerMenuTree",
                       method: .get) { result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let modelArray = success.data?.items?.first?.children {
                        self.modelArray = modelArray
                        self.collectionView.reloadData()
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
}

extension PropertyLineTwoViewController: UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = self.modelArray?.count ?? 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.modelArray?[section].children?.count ?? 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompanyCollectionCell", for: indexPath) as! CompanyCollectionCell
        let model = self.modelArray?[indexPath.section].children?[indexPath.row]
        cell.model.accept(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.modelArray?[indexPath.section].children?[indexPath.row]
        let pageUrl = model?.path ?? ""
        var dict = [String: String]()
        if entityType == 1 {
            dict = ["entityId": entityId, "entityName": entityName, "entityType": String(entityType)]
        }else {
            dict = ["personId": entityId, "personName": entityName, "entityType": String(entityType)]
        }
        let webUrl = URLQueryAppender.appendQueryParameters(to: base_url + pageUrl, parameters: dict) ?? ""
        let webVc = WebPageViewController()
        webVc.pageUrl.accept(webUrl)
        self.navigationController?.pushViewController(webVc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "MyCollectionNormalReusableView",
                for: indexPath) as! MyCollectionNormalReusableView
            let model = self.modelArray?[indexPath.section]
            header.namelabel.text = model?.menuName ?? ""
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 35)
    }
    
}
