//
//  SearchCompanyLawSuitViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/12.
//

import UIKit
import RxRelay
import MJRefresh
import DropMenuBar

class SearchCompanyLawSuitViewController: WDBaseViewController {
    
    //城市数据
    var regionModelArray = BehaviorRelay<[rowsModel]?>(value: [])
    var entityArea: String = ""//公司时候的地区
    
    var keyWords = BehaviorRelay<String>(value: "")
    var pageNum: Int = 1
    var pageSize: Int = 20
    var model: DataModel?
    var allArray: [itemsModel] = []
    var numBlock: ((DataModel) -> Void)?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .init(cssStr: "#F5F5F5")
        tableView.register(SearchCompanyDeadbeatCell.self, forCellReuseIdentifier: "SearchCompanyDeadbeatCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
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

        // Do any additional setup after loading the view.
        
        let regionMenu = MenuAction(title: "地区", style: .typeList)!
        self.regionModelArray.asObservable().asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            let regionArray = getThreeRegionInfo(from: modelArray ?? [])
            regionMenu.listDataSource = regionArray
        }).disposed(by: disposeBag)
        regionMenu.didSelectedMenuResult = { [weak self] index, model, grand in
            guard let self = self else { return }
            self.pageNum = 1
            self.entityArea = model?.currentID ?? ""
            self.getSearchPeopleInfo()
        }
        let menuView = DropMenuBar(action: [regionMenu])!
        menuView.backgroundColor = .white
        view.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(32)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalToSuperview().offset(32)
        }
        self.keyWords
            .asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] keyWords in
            guard let self = self else { return }
            if !keyWords.isEmpty {
                pageNum = 1
                getSearchPeopleInfo()
            }else {
                self.allArray.removeAll()
                self.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
        
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            pageNum = 1
            getSearchPeopleInfo()
        })
        
        //添加上拉加载更多
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getSearchPeopleInfo()
        })
    }
}

extension SearchCompanyLawSuitViewController {
    
    private func getSearchPeopleInfo() {
        let man = RequestManager()
        let dict = ["keywords": self.keyWords.value,
                    "type": "2",
                    "entityArea": entityArea]
        man.requestAPI(params: dict,
                       pageUrl: "/riskmonitor/cooperation/getLawsuit",
                       method: .get) { [weak self] result in
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let self = self,
                    let model = success.data,
                    let total = model.total {
                    self.model = model
                    if pageNum == 1 {
                        pageNum = 1
                        self.allArray.removeAll()
                    }
                    pageNum += 1
                    let pageData = model.items ?? []
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

extension SearchCompanyLawSuitViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let count = self.model?.total ?? 0
        let headView = UIView()
        let numLabel = UILabel()
        headView.backgroundColor = .init(cssStr: "#F8F9FB")
        numLabel.textColor = .init(cssStr: "#666666")
        numLabel.attributedText = GetRedStrConfig.getRedStr(from: "\(count)", fullText: "为你模糊匹配到\(count)条结果,请结合实际情况进行甄别", colorStr: "#FF0000")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCompanyDeadbeatCell", for: indexPath) as! SearchCompanyDeadbeatCell
        model.searchStr = self.keyWords.value
//        cell.model.accept(model)
        cell.selectionStyle = .none
        cell.cImageView.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
