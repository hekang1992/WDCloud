//
//  CompanyDetailView.swift
//  问道云
//
//  Created by 何康 on 2025/1/12.
//

import UIKit
import RxRelay

class CompanyDetailView: BaseView {
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    
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
        //注册title标题样式
        collectionView.register(MyCollectionNormalReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyCollectionNormalReusableView.identifier)
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.bottom.equalToSuperview().offset(-90)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CompanyDetailView: UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //section之间的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let items = self.model.value?.items?.first {
            return items.children?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let items = self.model.value?.items?.first {
            return items.children?[section].children?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompanyCollectionCell", for: indexPath) as! CompanyCollectionCell
        cell.backgroundColor = .white
        if let items = self.model.value?.items?.first, let item = items.children?[indexPath.section], let model = item.children?[indexPath.row] {
            cell.model.accept(model)
        }
        return cell
    }
    
    //返回头部
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected element kind")
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyCollectionNormalReusableView.identifier, for: indexPath) as! MyCollectionNormalReusableView
        
        if let items = self.model.value?.items?.first {
            let item = items.children?[indexPath.section]
            headerView.namelabel.text = "\(item?.menuName ?? "")"
        }
        return headerView
        
    }
    
    //头部的title高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 41)
    }
    
    func getTopVisibleHeaderSectionIndex() -> Int? {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        var topHeaderIndexPath: IndexPath? = nil
        
        // 获取当前可见的布局属性
        if let attributes = collectionView.collectionViewLayout.layoutAttributesForElements(in: visibleRect) {
            for attribute in attributes {
                // 如果是 section header
                if attribute.representedElementKind == UICollectionView.elementKindSectionHeader {
                    // 如果当前 header 的 y 坐标比之前记录的更小（即更靠上），则更新
                    if topHeaderIndexPath == nil || attribute.frame.minY < collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: topHeaderIndexPath!)!.frame.minY {
                        topHeaderIndexPath = attribute.indexPath
                    }
                }
            }
        }
        
        // 返回最上面的 section header 的 section 索引
        return topHeaderIndexPath?.section
    }
    
    // 滚动时调用，计算当前最上方的 Section
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let sectionIndex = getTopVisibleHeaderSectionIndex() {
            print("当前最上面的 section header 的索引是: \(sectionIndex)")
        }
    }
    
}
