//
//  BothReportViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/7.
//  日报

import UIKit
import JXSegmentedView

class BothReportViewController: WDBaseViewController {
    
    let segmentedView = JXSegmentedView()
    
    let segmentedDataSource = JXSegmentedTitleDataSource()
    
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    lazy var noMonitoringView: RiskNoMonitoringView = {
        let noMonitoringView = RiskNoMonitoringView()
        noMonitoringView.backgroundColor = .white
        noMonitoringView.isHidden = true
        return noMonitoringView
    }()
    
    lazy var noLoginView: RiskNoLoginView = {
        let noLoginView = RiskNoLoginView()
        noLoginView.backgroundColor = .white
        noLoginView.isHidden = true
        return noLoginView
    }()
    
    lazy var companyVc: BothCompanyViewController = {
        let companyVc = BothCompanyViewController()
        return companyVc
    }()
    
    lazy var peopleVc: BothPeopleViewController = {
        let peopleVc = BothPeopleViewController()
        return peopleVc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        //配置数据源
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedDataSource.titles = ["企业", "个人"]
        
        //配置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = JXSegmentedViewAutomaticDimension
        indicator.lineStyle = .lengthen
        indicator.indicatorHeight = 2
        indicator.indicatorWidth = 15
        indicator.indicatorColor = UIColor.init(cssStr: "#3849F7")!
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedDataSource.titleSelectedColor = UIColor.init(cssStr: "#3849F7")!
        segmentedDataSource.titleNormalColor = UIColor.init(cssStr: "#333333")!.withAlphaComponent(0.6)
        segmentedDataSource.titleNormalFont = .mediumFontOfSize(size: 15)
        segmentedDataSource.titleSelectedFont = .mediumFontOfSize(size: 15)
        
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedView.dataSource = segmentedDataSource
        segmentedView.indicators = [indicator]
        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 32)
        view.addSubview(segmentedView)
        
        segmentedView.listContainer = listContainerView
        listContainerView.isHidden = true
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(segmentedView.snp.bottom).offset(1)
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(noLoginView)
        noLoginView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalToSuperview().offset(1)
            make.bottom.equalToSuperview()
        }
        noLoginView.loginBlock = { [weak self] in
            self?.popLogin()
        }
        
        view.addSubview(noMonitoringView)
        noMonitoringView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalToSuperview().offset(1)
            make.bottom.equalToSuperview()
        }
        noMonitoringView.block = { [weak self] in
            let searchVc = SearchMonitoringViewController()
            self?.navigationController?.pushViewController(searchVc, animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if IS_LOGIN {
            //获取数字信息
            noLoginView.isHidden = true
            getNumInfo()
        }else {
            noLoginView.isHidden = false
        }
    }
    
}

extension BothReportViewController: JXSegmentedListContainerViewListDelegate, JXSegmentedListContainerViewDataSource {
    
    func listView() -> UIView {
        return view
    }
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            return self.companyVc
        }else {
            return self.peopleVc
        }
    }
    
}


extension BothReportViewController {
    
    private func getNumInfo() {
        let dict = [String: Any]()
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/entity/monitortarget/queryRiskMonitorEntity",
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self, let model = success.data {
                        showMonitoringView(from: model)
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func showMonitoringView(from model: DataModel) {
        let orgNum = model.orgNum ?? 0
        let personNum = model.personNum ?? 0
        let titles = ["企业\(orgNum)", "人员\(personNum)"]
        segmentedDataSource.titles = titles
        segmentedView.reloadData()
        
        if orgNum == 0 && personNum == 0 {
            listContainerView.isHidden = true
            self.noMonitoringView.isHidden = false
        }else {
            listContainerView.isHidden = false
            self.noMonitoringView.isHidden = true
        }
        
    }
    
}

