//
//  TwoRiskListPeopleCell.swift
//  问道云
//
//  Created by Andrew on 2025/1/11.
//

import UIKit
import RxRelay

class TwoRiskListPeopleCell: BaseViewCell {
    
    var modelArray = BehaviorRelay<[itemsModel]?>(value: nil)
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        return bgView
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
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TwoRiskListPeopleCollectionViewCell.self, forCellWithReuseIdentifier: "TwoRiskListPeopleCollectionViewCell")
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bgView)
        bgView.addSubview(collectionView)
        bgView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(110)
            make.bottom.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        modelArray.asObservable().subscribe(onNext: { [weak self] model in
            guard let self = self, let model = model, !model.isEmpty else { return }
            self.collectionView.reloadData()
        }).disposed(by: disposeBag)
        
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TwoRiskListPeopleCell: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 161, height: 88)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modelArray.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TwoRiskListPeopleCollectionViewCell", for: indexPath) as! TwoRiskListPeopleCollectionViewCell
        let model = self.modelArray.value?[indexPath.row]
        cell.model.accept(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ViewControllerUtils.findViewController(from: self)
        let model = self.modelArray.value?[indexPath.row]
        let riskDetailVc = PeopleRiskDetailViewController()
        riskDetailVc.name = model?.personName ?? ""
        riskDetailVc.personId = model?.personId ?? ""
        vc?.navigationController?.pushViewController(riskDetailVc, animated: true)
    }
    
}
