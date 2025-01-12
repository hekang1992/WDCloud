//
//  CompanyDetailViewController.swift
//  问道云
//
//  Created by 何康 on 2025/1/12.
//  企业详情

import UIKit

class CompanyDetailViewController: WDBaseViewController {
    
    var enityId: String = ""
    
    lazy var companyDetailView: CompanyDetailView = {
        let companyDetailView = CompanyDetailView()
        companyDetailView.backgroundColor = .white
        return companyDetailView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(companyDetailView)
        companyDetailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        //获取企业详情item菜单
        getCompanyDetailItemInfo()
        //获取角标
        getCompanyRightCountInfo()
    }
    
    @objc func handleButtonTap(_ sender: UIButton) {
        let sectionIndex = sender.tag
        
        // 获取指定 section 的 header 的布局属性
        if let headerAttributes = companyDetailView.collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: sectionIndex)) {
            
            // 计算 header 的顶部位置
            let headerTop = headerAttributes.frame.minY
            
            // 调整 contentOffset，确保 header 完全可见
            var offset = headerTop - companyDetailView.collectionView.contentInset.top
            offset = max(offset, 0) // 确保 offset 不小于 0
            
            // 滚动到指定位置
            companyDetailView.collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
        }
    }
    
}


extension CompanyDetailViewController {
    
    private func getCompanyDetailItemInfo() {
        let dict = ["moduleType": "2", "entityId": enityId] as [String: Any]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/operation/customermenu/customerMenuTree",
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    self.companyDetailView.model.accept(model)
                    self.companyDetailView.collectionView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    private func getCompanyRightCountInfo() {
        let dict = ["entityName": "2", "entityId": enityId] as [String: Any]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/operatingstate/getprestatistics",
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
