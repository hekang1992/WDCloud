//
//  CompanyDetailViewController.swift
//  问道云
//
//  Created by 何康 on 2025/1/12.
//  企业详情

import UIKit

class CompanyDetailViewController: WDBaseViewController {
    
    var enityId: String = ""
    
    var intBlock: ((Double) -> Void)?
    
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
        companyDetailView.intBlock = { [weak self] contentY in
            self?.intBlock?(contentY)
        }
        companyDetailView.cellBlock = { [weak self] model in
            guard let self = self else { return }
            var pageUrl: String = ""
            if let pathUrl = model.path {
                pageUrl = base_url + pathUrl + "?" + "entityId=\(enityId)"
            }
            self.pushWebPage(from: pageUrl)
        }
        //获取企业详情item菜单
        getCompanyDetailItemInfo()
        //获取角标
        getCompanyRightCountInfo()
        //获取企业详情头部信息
        getCompanyHeadInfo()
        //获取风险动态
        getCompanyRiskInfo()
    }
    
}


extension CompanyDetailViewController {
    
    //获取企业详情item
    private func getCompanyDetailItemInfo() {
        let dict = ["moduleType": "2",
                    "entityId": enityId] as [String: Any]
        let man = RequestManager()
        ViewHud.addLoadView()
        man.requestAPI(params: dict,
                       pageUrl: "/operation/customermenu/customerMenuTree",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
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
    
    //获取角标
    private func getCompanyRightCountInfo() {
        let dict = ["entityName": "2",
                    "entityId": enityId] as [String: Any]
        let man = RequestManager()
        ViewHud.addLoadView()
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/operatingstate/getprestatistics",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
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
    
    //获取企业详情头部信息
    private func getCompanyHeadInfo() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["entityId": enityId]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/company/overview",
                       method: .get) { result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if let model = success.data, let code = success.code, code == 200 {
                    self.companyDetailView.headModel.accept(model)
                    self.companyDetailView.collectionView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取风险详情数据
    private func getCompanyRiskInfo() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["entityId": enityId]
        man.requestAPI(params: dict,
                       pageUrl: "/riskmonitor/riskmonitoring/riskTrackingNew",
                       method: .get) { result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                if let model = success.data, let code = success.code, code == 200 {
                    self.companyDetailView.riskModel.accept(model)
                    self.companyDetailView.collectionView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}


