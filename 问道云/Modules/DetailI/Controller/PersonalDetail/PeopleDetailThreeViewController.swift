//
//  PeopleDetailThreeViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/15.
//

import UIKit
import JXPagingView
import RxRelay
import TYAlertController

class PeopleDetailThreeViewController: WDBaseViewController {
    
    var personId: String = ""
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    
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
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        //item
        collectionView.register(CompanyCollectionCell.self, forCellWithReuseIdentifier: "CompanyCollectionCell")
        //注册title标题样式
        collectionView.register(MyCollectionNormalReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MyCollectionNormalReusableView.identifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - StatusHeightManager.navigationBarHeight - 40 - 70)
        view.addSubview(collectionView)
        //获取个人详情item菜单
        getPeopleDetailItemInfo()
    }
   
    private func getPeopleDetailItemInfo() {
        let dict = ["moduleType": "3",
                    "entityId": personId,
                    "entityType": "2"] as [String: Any]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/operation/customermenu/customerMenuTree",
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    self.model.accept(model)
                    self.collectionView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }

}

extension PeopleDetailThreeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let modelArray = self.model.value?.items?.first?.children ?? []
        let lastElementSlice = modelArray.suffix(1) // 获取最后一个元素的 ArraySlice
        let newArray = Array(lastElementSlice)
        return newArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let modelArray = self.model.value?.items?.first?.children ?? []
        
        let lastElementSlice = modelArray.suffix(1) // 获取最后一个元素的 ArraySlice
        let newArray = Array(lastElementSlice)
        return newArray[section].children?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompanyCollectionCell", for: indexPath) as! CompanyCollectionCell
        let modelArray = self.model.value?.items?.first?.children ?? []
        let newArray = Array(modelArray.suffix(1))[indexPath.section]
        let model = newArray.children?[indexPath.row]
        cell.model.accept(model)
        return cell
    }
    
    
    //返回头部
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected element kind")
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyCollectionNormalReusableView.identifier, for: indexPath) as! MyCollectionNormalReusableView
        let modelArray = self.model.value?.items?.first?.children ?? []
        let lastElementSlice = modelArray.suffix(1) // 获取最后一个元素的 ArraySlice
        let model = Array(lastElementSlice)[indexPath.section]
        headerView.namelabel.text = "\(model.menuName ?? "")"
        return headerView
    }
    
    //头部的title高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 41)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let modelArray = self.model.value?.items?.first?.children ?? []
        let newArray = Array(modelArray.dropLast())[indexPath.section]
        let model = newArray.children?[indexPath.row]
        
        let markCount = model?.markCount ?? 0
        let markFlag = model?.markFlag ?? 0
        let clickFlag = model?.clickFlag ?? 0
        if markCount == 0 && markFlag != 0 {
            ToastViewConfig.showToast(message: "暂无信息")
            return
        }
        //弹窗去购买会员
        if clickFlag != 0 {
            let popView = PopOnlyBuyVipView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 300))
            let alertVc = TYAlertController(alert: popView, preferredStyle: .alert)!
            self.present(alertVc, animated: true)
            popView.cancelBlock = { [weak self] in
                self?.dismiss(animated: true)
            }
            popView.sureBlock = { [weak self] in
                self?.dismiss(animated: true) {
                    let menVc = MembershipCenterViewController()
                    self?.navigationController?.pushViewController(menVc, animated: true)
                    menVc.payBlock = {
                        self?.getPeopleDetailItemInfo()
                    }
                }
            }
            return
        }

        let pageUrl = base_url + (model?.path ?? "")
        let webVc = WebPageViewController()
        webVc.pageUrl.accept(pageUrl)
        self.navigationController?.pushViewController(webVc, animated: true)
    }
    
}

extension PeopleDetailThreeViewController: JXPagingViewListViewDelegate {
    
    func listView() -> UIView {
        return view
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }
    
    func listScrollView() -> UIScrollView { tableView }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
    
}
