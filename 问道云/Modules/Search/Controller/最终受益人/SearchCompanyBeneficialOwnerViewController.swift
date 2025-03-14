//
//  SearchCompanyBeneficialOwnerViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/12.
//

import UIKit
import RxRelay
import MJRefresh

class SearchCompanyBeneficialOwnerViewController: WDBaseViewController {
    
    var keyWords = BehaviorRelay<String>(value: "")
    var pageNum: Int = 1
    var pageSize: Int = 20
    var model: DataModel?
    var allArray: [rowsModel] = []
    var numBlock: ((DataModel) -> Void)?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .init(cssStr: "#F5F5F5")
        tableView.register(SearchCompanyShareholderCell.self, forCellReuseIdentifier: "SearchCompanyShareholderCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            pageNum = 1
            getSearchCompanyInfo()
        })
        
        //添加上拉加载更多
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getSearchCompanyInfo()
        })
        
        self.keyWords
            .asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] keyWords in
            guard let self = self else { return }
            if !keyWords.isEmpty {
                pageNum = 1
                getSearchCompanyInfo()
            }else {
                self.allArray.removeAll()
                self.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
        
    }

}

extension SearchCompanyBeneficialOwnerViewController {
    
    //搜索股东===公司
    private func getSearchCompanyInfo() {
        
        let man = RequestManager()
        let dict = ["firmname": self.keyWords.value,
                    "pageNum": pageNum,
                    "pageSize": 20] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/basicinformation/getactualcontroller",
                       method: .get) { [weak self] result in
            
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let self = self,
                    let model = success.data,
                    let total = model.total {
                    self.model = model
                    self.numBlock?(model)
                    if pageNum == 1 {
                        pageNum = 1
                        self.allArray.removeAll()
                    }
                    pageNum += 1
                    let pageData = model.data ?? []
                    self.allArray.append(contentsOf: pageData)
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
                    }else {
                        self.addNodataView(from: self.tableView)
                    }
                    if self.allArray.count != total {
                        self.tableView.mj_footer?.isHidden = false
                    }else {
                        self.tableView.mj_footer?.isHidden = true
                    }
                    self.tableView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
}

extension SearchCompanyBeneficialOwnerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let count = self.model?.total ?? 0
        let headView = UIView()
        let numLabel = UILabel()
        headView.backgroundColor = .init(cssStr: "#F8F9FB")
        numLabel.textColor = .init(cssStr: "#666666")
        numLabel.attributedText = GetRedStrConfig.getRedStr(from: "\(count)", fullText: "搜到到\(count)条结果", colorStr: "#FF0000")
        numLabel.textAlignment = .left
        numLabel.font = .regularFontOfSize(size: 12)
        headView.addSubview(numLabel)
        numLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12.5)
        }
        return headView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.allArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCompanyShareholderCell", for: indexPath) as! SearchCompanyShareholderCell
        cell.backgroundColor = .white
        cell.model.accept(model)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.allArray[indexPath.row]
        let pageUrl = "\(base_url)/personal-information/shareholder-situation"
        let dict = ["firmname": model.entityName ?? "",
                    "entityId": model.entityId ?? "",
                    "isPerson": "0"]
        let webUrl = URLQueryAppender.appendQueryParameters(to: pageUrl, parameters: dict) ?? ""
        self.pushWebPage(from: webUrl)
    }
    
}
