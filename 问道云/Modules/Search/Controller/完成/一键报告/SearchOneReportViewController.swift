//
//  SearchOneReportViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/10.
//

import UIKit
import RxRelay
import RxSwift
import MJRefresh

class SearchOneReportViewController: WDBaseViewController {
    
    //参数
    var pageIndex: Int = 1
    var keywords: String = ""
    var dataModel: DataModel?
    var ddNumber: String = "1"
    var allArray: [pageDataModel] = []
    
    //浏览历史
    var historyArray: [rowsModel] = []
    //热门搜索
    var hotsArray: [rowsModel] = []
    //总数组
    var modelArray: [[rowsModel]] = []
    
    lazy var oneView: CommonHotsView = {
        let oneView = CommonHotsView()
        return oneView
    }()
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "一键报告"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setImage(UIImage(named: "rightHeadLogo"), for: .normal)
        return headView
    }()
    
    lazy var searchView: HomeItemSearchView = {
        let searchView = HomeItemSearchView()
        let attrString = NSMutableAttributedString(string: "请输入关键词", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#999999") as Any,
            .font: UIFont.mediumFontOfSize(size: 14)
        ])
        searchView.searchTx.attributedPlaceholder = attrString
        searchView.backgroundColor = .white
        return searchView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(SearchOneReportCell.self,
                           forCellReuseIdentifier: "SearchOneReportCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
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
        addHeadView(from: headView)
        view.addSubview(searchView)
        searchView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(1)
            make.height.equalTo(50)
        }
        //oneview
        view.addSubview(oneView)
        oneView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.searchView.snp.bottom)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }
        
        // 监听 UITextField 的文本变化
        self.searchView.searchTx
            .rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if self.containsOnlyChinese(text) == true {
                    if text.count < 2 {
                        oneView.isHidden = false
                        tableView.isHidden = true
                        //获取热搜等数据
                        getHotsSearchInfo()
                    }else {
                        oneView.isHidden = true
                        tableView.isHidden = false
                        self.pageIndex = 1
                        self.keywords = text
                        getOneReportInfo()
                    }
                }
                else if self.containsPinyin(text) == true {
                    // 拼音不打印，什么都不做
                }
            }).disposed(by: disposeBag)
        
        self.searchView.searchTx
            .rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(self.searchView.searchTx.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                if text.count < 2 {
                    oneView.isHidden = false
                    //获取热搜等数据
                    getHotsSearchInfo()
                }else {
                    oneView.isHidden = true
                    self.pageIndex = 1
                    self.keywords = text
                    getOneReportInfo()
                }
            }).disposed(by: disposeBag)

        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            pageIndex = 1
            getOneReportInfo()
        })
        
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getOneReportInfo()
        })
        
    }
    
}

/** 网络数据请求 */
extension SearchOneReportViewController {
    
    private func getOneReportInfo() {
        let dict = ["pageIndex": pageIndex,
                    "pageSize": 20,
                    "keyword": keywords,
                    "matchType": 1] as [String : Any]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/entity/v2/org-list",
                       method: .get) { [weak self] result in
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
                            self.oneView.isHidden = true
                            self.tableView.isHidden = false
                            self.emptyView.removeFromSuperview()
                        }else {
                            self.oneView.isHidden = false
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
                }else {
                    if let self = self {
                        self.oneView.isHidden = false
                        self.tableView.isHidden = true
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取最近搜索,浏览历史,热搜
    private func getHotsSearchInfo() {
        let group = DispatchGroup()
        ViewHud.addLoadView()
        group.enter()
        getLastSearchInfo(from: "09") { [weak self] modelArray in
            if !modelArray.isEmpty {
                self?.oneView.bgView.isHidden = false
                self?.oneView.bgView.snp.remakeConstraints({ make in
                    make.top.equalToSuperview().offset(1)
                    make.left.equalToSuperview()
                    make.width.equalTo(SCREEN_WIDTH)
                })
                self?.oneView.tagArray = modelArray.map { $0.searchContent ?? "" }
                self?.oneView.setupScrollView()
            }else {
                self?.oneView.bgView.isHidden = true
                self?.oneView.bgView.snp.remakeConstraints({ make in
                    make.top.equalToSuperview().offset(1)
                    make.left.equalToSuperview()
                    make.width.equalTo(SCREEN_WIDTH)
                    make.height.equalTo(0)
                })
            }
            group.leave()
        }
        
        group.enter()
        getLastHistroyInfo(from: "09") { [weak self] modelArray in
            self?.historyArray = modelArray
            group.leave()
        }
        
        group.enter()
        getLastHotsInfo(from: "09") { [weak self] modelArray in
            self?.hotsArray = modelArray
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.modelArray = [self.historyArray, self.hotsArray]
            self.oneView.modelArray = self.modelArray
            ViewHud.hideLoadView()
        }
        
        oneView.tagClickBlock = { [weak self] label in
            self?.searchView.searchTx.text = label.text ?? ""
        
        }
        
    }
    
}

extension SearchOneReportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = .init(cssStr: "#F5F5F5")
        let numLabel = UILabel()
        let count = String(self.dataModel?.pageMeta?.totalNum ?? 0)
        numLabel.textColor = .init(cssStr: "#333333")
        numLabel.font = .regularFontOfSize(size: 13)
        numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "搜索到\(count)条数据", font: .regularFontOfSize(size: 13))
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchOneReportCell", for: indexPath) as! SearchOneReportCell
        cell.model.accept(model)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.allArray[indexPath.row]
        let oneRpVc = OneReportViewController()
        if let orgInfo = model.orgInfo {
            oneRpVc.orgInfo = orgInfo
        }
        self.navigationController?.pushViewController(oneRpVc, animated: true)
    }
    
}
