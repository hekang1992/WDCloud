//
//  CompanyDetailViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/12.
//  企业详情

import UIKit
import RxRelay
import SwiftyJSON

class CompanyDetailViewController: WDBaseViewController {
    
    var enityId: String = ""
    
    var intBlock: ((Double) -> Void)?
    
    //头部的数据模型
    var headModel = BehaviorRelay<DataModel?>(value: nil)
    
    var childrenArrayModel = BehaviorRelay<[childrenModel]?>(value: nil)
    
    //是否刷新上一个页面
    var refreshBlock: ((Int) -> Void)?
    
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
        
        //回到首页
        companyDetailView.footerView.backBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }).disposed(by: disposeBag)
        
        //一键报告
        companyDetailView.footerView.backBtn1.rx.tap.subscribe(onNext: { [weak self] in
            let oneRpVc = OneReportViewController()
            if let model = self?.headModel.value?.basicInfo {
                let orgId = model.orgId ?? ""
                let orgName = model.orgName ?? ""
                let json: JSON = ["orgId": orgId,
                                  "orgName": orgName]
                let orgInfo = orgInfoModel(json: json)
                oneRpVc.orgInfo = orgInfo
            }
            self?.navigationController?.pushViewController(oneRpVc, animated: true)
        }).disposed(by: disposeBag)
        
        //添加监控 0 未监控; 1 已监控
        companyDetailView.footerView.backBtn2.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self, let model = self.headModel.value else { return }
            let monitorStatus = model.monitorInfo?.monitorStatus ?? 0
            if monitorStatus == 0 {//未监控->去监控
                self.addMonitoring(from: model)
            }else {//已监控->取消监控
                self.cancelMonitoring(from: model)
            }
        }).disposed(by: disposeBag)
        
        //关注
        companyDetailView.footerView.backBtn3.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self, let model = self.headModel.value else { return }
            let followStatus = model.followInfo?.followStatus ?? 0
            if followStatus == 1 || followStatus == 3 {
                //添加关注
                addFocus(from: model)
            }else {
                //取消关注
                cancelFocus(from: model)
            }
        }).disposed(by: disposeBag)
        
        //获取企业详情item菜单
        getCompanyDetailItemInfo()
        //获取角标
        getCompanyRightCountInfo()
        //获取企业详情头部信息
        getCompanyHeadInfo()
        //获取风险动态
        getCompanyRiskInfo()
        //获取常用服务
        getCommonServiceInfo()
        //获取图谱
        getAtlasInfo()
    }
    
}

/** 网络数据请求 */
extension CompanyDetailViewController {
    
    //获取常用服务
    private func getCommonServiceInfo() {
        let man = RequestManager()
        let appleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let dict = ["moduleType": "6",
                    "appleVersion": appleVersion,
                    "appType": "apple"]
        man.requestAPI(params: dict, pageUrl: "/operation/customermenu/customerMenuTree", method: .get) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    self.companyDetailView.childrenArrayModel.accept(success.data?.items?.first?.children ?? [])
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取图谱
    private func getAtlasInfo() {
        let man = RequestManager()
        let appleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let dict = ["moduleType": "7",
                    "appleVersion": appleVersion,
                    "appType": "apple"]
        man.requestAPI(params: dict, pageUrl: "/operation/customermenu/customerMenuTree", method: .get) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if success.code == 200 {
                        self.companyDetailView.mapArrayModel.accept(success.data?.items?.first?.children?.first?.children ?? [])
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取企业详情item
    private func getCompanyDetailItemInfo() {
        let dict = ["moduleType": "2",
                    "entityId": enityId] as [String: Any]
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
    
    //获取角标
    private func getCompanyRightCountInfo() {
        let dict = ["entityName": "2",
                    "entityId": enityId] as [String: Any]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/operatingstate/getprestatistics",
                       method: .get) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    self.companyDetailView.numModel.accept(model)
                    self.companyDetailView.collectionView.reloadData()
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
        let dict = ["orgId": enityId]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/v2/org/overview",
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if let self = self,
                   let model = success.data,
                    let code = success.code,
                    code == 200 {
                    self.headModel.accept(model)
                    self.refreshFooterInfo(form: model)
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
        let dict = ["entityId": enityId, "entityCategory": "1"]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/risk/riskTracking",
                       method: .get) { result in
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
    
    //添加监控
    private func addMonitoring(from model: DataModel) {
        let man = RequestManager()
        let dict = ["orgId": model.basicInfo?.orgId ?? "",
                    "groupId": ""]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitor-org/addRiskMonitorOrg",
                       method: .post) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                let code = success.code ?? 0
                if code == 200 {
                    model.monitorInfo?.monitorStatus = 1
                    refreshFooterInfo(form: model)
                    ToastViewConfig.showToast(message: "监控成功")
                }else if code == 702 {
                    //弹窗提示购买会员
                    let entityid = model.basicInfo?.orgId ?? ""
                    let firmname = model.basicInfo?.orgName ?? ""
                    popVipView(from: 1, entityId: entityid, entityName: firmname, menuId: "") { [weak self] in
                        model.monitorInfo?.monitorStatus = 1
                        self?.refreshFooterInfo(form: model)
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //取消监控
    private func cancelMonitoring(from model: DataModel) {
        ShowAlertManager.showAlert(title: "取消监控", message: "是否取消监控?", confirmAction: {
            let man = RequestManager()
            let dict = ["orgId": model.basicInfo?.orgId ?? "",
                        "groupId": ""]
            man.requestAPI(params: dict,
                           pageUrl: "/entity/monitor-org/cancelRiskMonitorOrg",
                           method: .post) { [weak self] result in
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        if let self = self {
                            model.monitorInfo?.monitorStatus = 0
                            refreshFooterInfo(form: model)
                            ToastViewConfig.showToast(message: "取消监控成功")
                        }
                    }
                    break
                case .failure(_):
                    break
                }
            }
        })
    }
    
    //添加关注
    private func addFocus(from model: DataModel) {
        let man = RequestManager()
        let entityId = model.basicInfo?.orgId ?? ""
        let dict = ["entityId": entityId, "followTargetType": "1"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/follow/add-or-cancel",
                       method: .post) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self {
                        model.followInfo?.followStatus = 2
                        refreshFooterInfo(form: model)
                        self.refreshBlock?(2)
                        ToastViewConfig.showToast(message: "关注成功")
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //取消关注
    private func cancelFocus(from model: DataModel) {
        ShowAlertManager.showAlert(title: "取消关注", message: "是否取消关注?", confirmAction: {
            let man = RequestManager()
            let entityId = model.basicInfo?.orgId ?? ""
            let dict = ["entityId": entityId, "followTargetType": "1"]
            man.requestAPI(params: dict,
                           pageUrl: "/operation/follow/add-or-cancel",
                           method: .post) { [weak self] result in
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        if let self = self {
                            model.followInfo?.followStatus = 1
                            refreshFooterInfo(form: model)
                            self.refreshBlock?(1)
                            ToastViewConfig.showToast(message: "取消关注成功")
                        }
                    }
                    break
                case .failure(_):
                    break
                }
            }
        })
    }
    
    //刷新企业详情底部,是否监控 0 1, 是否关注 1 未关注；2 已关注；3 已取关
    private func refreshFooterInfo(form model: DataModel) {
        let monitorStatus = model.monitorInfo?.monitorStatus ?? 0
        let followStatus = model.followInfo?.followStatus ?? 0
        //监控
        if monitorStatus == 0 {
            companyDetailView.footerView.backBtn2.setTitle("添加监控", for: .normal)
            companyDetailView.footerView.backBtn2.setImage(UIImage(named: "添加监控"), for: .normal)
        }else {
            companyDetailView.footerView.backBtn2.setTitle("已监控", for: .normal)
            companyDetailView.footerView.backBtn2.setImage(UIImage(named: "addminjiakong"), for: .normal)
        }
        //关注
        if followStatus == 1 || followStatus == 3 {
            companyDetailView.footerView.backBtn3.setTitle("关注", for: .normal)
            companyDetailView.footerView.backBtn3.setImage(UIImage(named: "添加关注"), for: .normal)
            companyDetailView.footerView.backBtn3.backgroundColor = UIColor.init(cssStr: "#3F96FF")
            companyDetailView.footerView.backBtn3.setTitleColor(UIColor.init(cssStr: "#FFFFFF"), for: .normal)
        }else {
            companyDetailView.footerView.backBtn3.setTitle("已关注", for: .normal)
            companyDetailView.footerView.backBtn3.setImage(UIImage(named: "关注成功"), for: .normal)
            companyDetailView.footerView.backBtn3.backgroundColor = UIColor.init(cssStr: "#EAF1FF")
            companyDetailView.footerView.backBtn3.setTitleColor(UIColor.init(cssStr: "#3F96FF"), for: .normal)
        }
        
    }
}


