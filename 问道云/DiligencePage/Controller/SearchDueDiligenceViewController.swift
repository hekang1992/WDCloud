//
//  SearchDueDiligenceViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/18.
//

import UIKit
import RxSwift
import MJRefresh

class SearchDueDiligenceViewController: WDBaseViewController {
    
    //参数
    var pageIndex: Int = 1
    var keywords: String = ""
    var dataModel: DataModel?
    
    var allArray: [pageDataModel] = []
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .none)
        headView.titlelabel.text = "尽职调查"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        return headView
    }()
    
    lazy var searchView: HomeItemSearchView = {
        let searchView = HomeItemSearchView()
        let attrString = NSMutableAttributedString(string: "请输入企业名称", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#999999") as Any,
            .font: UIFont.mediumFontOfSize(size: 14)
        ])
        searchView.searchTx.attributedPlaceholder = attrString
        searchView.backgroundColor = .white
        return searchView
    }()
    
    lazy var bgView: SearchDueDiligenceView = {
        let bgView = SearchDueDiligenceView()
        return bgView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(DueDiligenceCell.self,
                           forCellReuseIdentifier: "DueDiligenceCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        addHeadView(from: headView)
        view.addSubview(searchView)
        view.addSubview(bgView)
        view.addSubview(tableView)
        searchView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(13)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        bgView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(120)
            make.left.right.bottom.equalToSuperview()
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
        
        bgView.twoImageView
            .rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let memVc = MembershipCenterViewController()
                self?.navigationController?.pushViewController(memVc, animated: true)
        }).disposed(by: disposeBag)
        
        self.searchView.searchTx
            .rx
            .controlEvent(.editingChanged)
            .withLatestFrom(self.searchView.searchTx.rx.text.orEmpty)
            .distinctUntilChanged()
            .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] keywords in
                guard let self = self else { return }
                if keywords.isEmpty {
                    bgView.isHidden = false
                }else {
                    bgView.isHidden = true
                }
                self.pageIndex = 1
                self.keywords = keywords
                getDueListInfo()
            }).disposed(by: disposeBag)
        
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            pageIndex = 1
            getDueListInfo()
        })
        
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getDueListInfo()
        })
        
    }

}

extension SearchDueDiligenceViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func getDueListInfo() {
        ViewHud.addLoadView()
        let dict = ["pageIndex": pageIndex,
                    "pageSize": 20,
                    "keyword": keywords,
                    "matchType": 1] as [String : Any]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/company/search",
                       method: .post) { [weak self] result in
            ViewHud.hideLoadView()
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self, let model = success.data, let total = model.pageMeta?.totalNum {
                        self.dataModel = model
                        if pageIndex == 1 {
                            pageIndex = 1
                            self.allArray.removeAll()
                        }
                        pageIndex += 1
                        let pageData = model.pageData ?? []
                        self.allArray.append(contentsOf: pageData)
                        if total != 0 {
                            self.bgView.isHidden = true
                            self.tableView.isHidden = false
                            self.emptyView.removeFromSuperview()
                        }else {
                            self.bgView.isHidden = false
                            self.tableView.isHidden = true
                            self.addNodataView(from: self.tableView)
                        }
                        if self.allArray.count != total {
                            self.tableView.mj_footer?.isHidden = false
                        }else {
                            self.tableView.mj_footer?.isHidden = true
                        }
                        self.tableView.reloadData()
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = .init(cssStr: "#F5F5F5")
        let numLabel = UILabel()
        let count = String(self.dataModel?.pageMeta?.totalNum ?? 0)
        numLabel.textColor = .init(cssStr: "#333333")
        numLabel.font = .regularFontOfSize(size: 14)
        numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "根据企业名称及曾用名，找到\(count)条相似结果", font: .regularFontOfSize(size: 14))
        headView.addSubview(numLabel)
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(17)
            make.height.equalTo(26)
        }
        return headView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.allArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DueDiligenceCell", for: indexPath) as! DueDiligenceCell
        cell.model.accept(model)
        cell.selectionStyle = .none
        return cell
    }
    
    
}
