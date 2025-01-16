//
//  CompanyDetailView.swift
//  问道云
//
//  Created by 何康 on 2025/1/12.
//

import UIKit
import RxRelay

class CompanyDetailView: BaseView {
    
    //返回cell的点击model
    var cellBlock: ((childrenModel) -> Void)?
    
    //item的数据模型
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    //头部的数据模型
    var headModel = BehaviorRelay<DataModel?>(value: nil)
    
    //风险模型
    var riskModel = BehaviorRelay<DataModel?>(value: nil)
    
    //返回当前在第几个section
    var intBlock: ((Double) -> Void)?
    
    // 用于存储所有按钮
    var buttons: [UIButton] = []
    
    //是否点击了按钮
    var isClickBtnGrand: Bool = false
    //点击了哪一个按钮
    var isClickBtnSelectIndex: Int = 0
    
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
        //注册head标题样式
        collectionView.register(MyCollectionSpecialReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyCollectionSpecialReusableView.identifier)
        return collectionView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.alpha = 0
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var onelineView: UIView = {
        let onelineView = UIView()
        onelineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return onelineView
    }()
    
    lazy var twolineView: UIView = {
        let twolineView = UIView()
        twolineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return twolineView
    }()
    
    lazy var footerView: CompanyDerailFooterView = {
        let footerView = CompanyDerailFooterView()
        return footerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        addSubview(scrollView)
        addSubview(footerView)
        scrollView.addSubview(onelineView)
        scrollView.addSubview(twolineView)
        collectionView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.bottom.equalToSuperview().offset(-90)
        }
        footerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(90)
        }
        scrollView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(40)
        }
        onelineView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(1)
        }
        twolineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        self.model.subscribe(onNext: { [weak self] dataModel in
            guard let self = self, let dataModel = dataModel else { return }
            if let items = dataModel.items?.first?.children {
                var previousButton: UIButton?
                
                for (index, model) in items.enumerated() {
                    // 创建按钮
                    let button = UIButton(type: .custom)
                    button.setTitle(model.menuName, for: .normal)
                    button.setTitleColor(.init(cssStr: "#666666"), for: .normal)
                    button.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.3)
                    button.titleLabel?.font = .regularFontOfSize(size: 12)
                    button.layer.cornerRadius = 2
                    scrollView.addSubview(button)
                    button.tag = index + 10 // 设置 tag 以便区分按钮
                    button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside) // 添加点击事件
                    buttons.append(button) // 将按钮添加到数组中
                    // 设置按钮的约束
                    button.snp.makeConstraints { make in
                        make.top.bottom.equalToSuperview().inset(5)
                        make.width.equalTo(65)
                        if let previousButton = previousButton {
                            make.left.equalTo(previousButton.snp.right).offset(9)
                        } else {
                            make.left.equalToSuperview().offset(9)
                        }
                    }
                    previousButton = button
                    if index == items.count - 1 {
                        button.snp.makeConstraints { make in
                            make.right.equalToSuperview().offset(-5)
                        }
                    }
                }
            }
        }).disposed(by: disposeBag)

    }
    
    //按钮点击方法
    @objc func buttonTapped(_ sender: UIButton) {
        // 恢复所有按钮的默认样式
        isClickBtnGrand = true
        for button in buttons {
            button.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.2)
            button.setTitleColor(.init(cssStr: "#666666"), for: .normal)
        }
        // 设置被点击按钮的样式
        sender.backgroundColor = .init(cssStr: "#547AFF")
        sender.setTitleColor(.white, for: .normal)
        // 可以根据 tag 获取点击的按钮索引
        let index = sender.tag
        self.isClickBtnSelectIndex = index
        scrollToSectionHeader(section: index - 9)
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
        if let items = self.model.value?.items?.first, let count = items.children?.count {
            return count + 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }else {
            if let items = self.model.value?.items?.first {
                return items.children?[section - 1].children?.count ?? 0
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompanyCollectionCell", for: indexPath) as! CompanyCollectionCell
            if let items = self.model.value?.items?.first, let item = items.children?[indexPath.section - 1] {
                let model = item.children?[indexPath.row]
                cell.model.accept(model)
            }
            return cell
        }
    }
    
    //点击cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            if let items = self.model.value?.items?.first, let item = items.children?[indexPath.section - 1], let model = item.children?[indexPath.row] {
                print("model=======\(model.menuName ?? "")")
                self.cellBlock?(model)
            }
        }
    }
    
    //返回头部
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected element kind")
        }
        if indexPath.section == 0 {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyCollectionSpecialReusableView.identifier, for: indexPath) as! MyCollectionSpecialReusableView
#warning("待定======点击小标签刷新头部高度")
            headerView.headView.moreClickBlcok = { model in
                
            }
            if let headModel = self.headModel.value {
                headerView.model.accept(headModel)
                headerView.headView.threeHeadView.collectionView.reloadData()
                headerView.headView.threeHeadView.pcollectionView.reloadData()
            }
            if let riskModel = self.riskModel.value {
                headerView.riskModel.accept(riskModel)
            }
            return headerView
        }else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyCollectionNormalReusableView.identifier, for: indexPath) as! MyCollectionNormalReusableView
            if let items = self.model.value?.items?.first {
                let item = items.children?[indexPath.section - 1]
                headerView.namelabel.text = "\(item?.menuName ?? "")"
            }
            return headerView
        }
    }
    
    //头部的title高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            if let headModel = self.headModel.value, let stockModel = headModel.stockInfo?.first, let key = stockModel.key, !key.isEmpty {
                return CGSize(width: collectionView.bounds.width, height: 906)
            }else {
                return CGSize(width: collectionView.bounds.width, height: 686)
            }
        }else {
            return CGSize(width: collectionView.bounds.width, height: 41)
        }
    }
    
    // 处理滚动结束后的逻辑
    private func handleScrollEnd() {
        let sectionIndex = getTopVisibleSection() ?? 0
        if isClickBtnGrand == true {
            for button in buttons {
                button.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.2)
                button.setTitleColor(.init(cssStr: "#666666"), for: .normal)
            }
            let button = buttons[self.isClickBtnSelectIndex - 10]
            button.backgroundColor = .init(cssStr: "#547AFF")
            button.setTitleColor(.white, for: .normal)
        }else {
            for button in buttons {
                button.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.2)
                button.setTitleColor(.init(cssStr: "#666666"), for: .normal)
            }
            if let button = self.scrollView.viewWithTag(sectionIndex + 9) as? UIButton {
                button.backgroundColor = .init(cssStr: "#547AFF")
                button.setTitleColor(.white, for: .normal)
            }
        }
        
    }
    
    // 滚动时调用，计算当前最上方的 Section
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.intBlock?(scrollView.contentOffset.y)
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
            return
        }
        if scrollView.contentOffset.y > 300 {
            UIView.animate(withDuration: 0.25) {
                self.scrollView.alpha = 1
            }
        }else {
            UIView.animate(withDuration: 0.25) {
                self.scrollView.alpha = 0
            }
        }
        handleScrollEnd()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.isClickBtnGrand = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.isClickBtnGrand = false
    }
    
    func getTopVisibleSection() -> Int? {
        // 获取当前 collectionView 的可见区域
        let visibleRect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
        
        // 获取所有可见的 indexPath
        let visibleIndexPaths = self.collectionView.indexPathsForVisibleItems
        
        // 初始化一个变量来存储最顶部的 section
        var topSection: Int?
        var minY: CGFloat = .greatestFiniteMagnitude
        
        // 遍历可见的 indexPath，找到最顶部的 section
        for indexPath in visibleIndexPaths {
            // 获取对应 indexPath 的布局属性
            if let attributes = self.collectionView.layoutAttributesForItem(at: indexPath) {
                // 判断该 cell 是否在可见区域内
                if visibleRect.intersects(attributes.frame) {
                    // 如果当前 cell 的 y 值更小（更靠上）
                    if attributes.frame.origin.y < minY {
                        minY = attributes.frame.origin.y
                        topSection = indexPath.section
                    }
                }
            }
        }
        
        // 返回最顶部的 section
        return topSection
    }
    
    func scrollToSectionHeader(section: Int) {
        // 确保 section 索引有效
        guard section >= 0, section < collectionView.numberOfSections else {
            print("无效的 section 索引")
            return
        }
        // 获取 section 头部的布局属性
        let indexPath = IndexPath(item: 0, section: section)
        if let attributes = collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
            // 滚动到 section 头部
            collectionView.setContentOffset(CGPoint(x: 0, y: attributes.frame.origin.y - 38), animated: true)
        }
    }
    
}

