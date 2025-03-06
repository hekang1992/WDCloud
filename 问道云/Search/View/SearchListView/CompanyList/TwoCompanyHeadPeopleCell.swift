//
//  TwoCompanyHeadPeopleCell.swift
//  问道云
//
//  Created by Andrew on 2025/1/9.
//

import UIKit

class TwoCompanyHeadPeopleCell: UITableViewCell {
    
    var modelArray: [itemsModel]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CompanySearchPeopleViewCell.self, forCellWithReuseIdentifier: "CompanySearchPeopleViewCell")
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(100)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TwoCompanyHeadPeopleCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 153.pix(), height: 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modelArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompanySearchPeopleViewCell", for: indexPath) as! CompanySearchPeopleViewCell
        let model = self.modelArray?[indexPath.row]
        cell.model = model
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.modelArray?[indexPath.row]
        let personId = model?.personId ?? ""
        let name = model?.name ?? ""
        let vc = ViewControllerUtils.findViewController(from: self)
        let peopleDetailVc = PeopleBothViewController()
        peopleDetailVc.enityId.accept(personId)
        peopleDetailVc.peopleName.accept(name)
        vc?.navigationController?.pushViewController(peopleDetailVc, animated: true)
    }
    
}
