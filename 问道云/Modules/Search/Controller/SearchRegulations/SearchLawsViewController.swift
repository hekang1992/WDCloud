//
//  SearchLawsViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/10.
//  

import UIKit
import RxSwift
import DropMenuBar
import MJRefresh
import RxRelay
import SwiftyJSON

class SearchLawsViewController: WDBaseViewController {

    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "法律法规"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setImage(UIImage(named: "headrightoneicon"), for: .normal)
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
    
    lazy var oneView: OneCompanyView = {
        let oneView = OneCompanyView()
        return oneView
    }()
    
    //请求参数
    var pageNum: Int = 1
    var pageSize: Int = 20
    var allArray: [itemsModel] = []
    var shareSearchKey: String = ""
    var model: DataModel?
    var lawNature: String = ""
    var timeliness: String = ""
    
    var oneItemArray = BehaviorRelay<[lawNatureListModel]?>(value: nil)
    var twoItemArray = BehaviorRelay<[lawNatureListModel]?>(value: nil)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.isHidden = true
        tableView.register(HomeLawsViewCell.self,
                           forCellReuseIdentifier: "HomeLawsViewCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
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
        searchView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(1)
            make.height.equalTo(50)
        }
        self.searchView.searchTx
            .rx
            .controlEvent(.editingChanged)
            .withLatestFrom(self.searchView.searchTx.rx.text.orEmpty)
            .distinctUntilChanged()
            .debounce(.milliseconds(1000), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] keywords in
                if !keywords.isEmpty {
                    self?.pageNum = 1
                    self?.shareSearchKey = keywords
                    self?.getNoticeListInfo()
                }
        }).disposed(by: disposeBag)
        
        
        let oneMenu = MenuAction(title: "效力位阶", style: .typeList)!
        let twoMenu = MenuAction(title: "时效性", style: .typeList)!
        let menuView = DropMenuBar(action: [oneMenu, twoMenu])!
        menuView.backgroundColor = .white
        view.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(34)
            make.top.equalTo(searchView.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH)
        }
        
        oneItemArray.asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self, let modelArray = modelArray else { return }
            let regionArray = getLawGroupMenuInfo(from: modelArray)
            oneMenu.listDataSource = regionArray
        }).disposed(by: disposeBag)
        
        
        twoItemArray.asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self, let modelArray = modelArray else { return }
            let regionArray = getLawGroupMenuInfo(from: modelArray)
            twoMenu.listDataSource = regionArray
        }).disposed(by: disposeBag)
        
        oneMenu.didSelectedMenuResult = { [weak self] index, model, grand in
            guard let self = self else { return }
            self.pageNum = 1
            self.lawNature = model?.currentID ?? ""
            self.getNoticeListInfo()
        }
        twoMenu.didSelectedMenuResult = { [weak self] index, model, grand in
            guard let self = self else { return }
            self.pageNum = 1
            self.timeliness = model?.currentID ?? ""
            self.getNoticeListInfo()
        }
        
        //oneview
        view.addSubview(oneView)
        oneView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.searchView.snp.bottom)
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(menuView.snp.bottom)
        }
        
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            pageNum = 1
            getNoticeListInfo()
        })
        
        //添加上拉加载更多
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getNoticeListInfo()
        })
        self.addNodataView(from: self.tableView)
        
        //删除最近搜索
        self.oneView.searchView.deleteBtn
            .rx
            .tap.subscribe(onNext: { [weak self] in
                self?.deleteSearchInfo()
            }).disposed(by: disposeBag)
        
        //删除浏览历史
        self.oneView.historyView.deleteBtn
            .rx
            .tap.subscribe(onNext: { [weak self] in
                self?.deleteHistoryInfo()
            }).disposed(by: disposeBag)
        
        //点击最近搜索
        self.oneView.lastSearchTextBlock = { [weak self] keywords in
            self?.searchView.searchTx.text = keywords
            if !keywords.isEmpty {
                self?.oneView.isHidden = false
                //最近搜索
                self?.getlastSearch()
                //浏览历史
                self?.getBrowsingHistory()
                //热搜
                self?.getHotWords()
                self?.pageNum = 1
                self?.getNoticeListInfo()
            }else {
                self?.oneView.isHidden = true
            }
        }
        
        //最近搜索
        self.getlastSearch()
        //浏览历史
        self.getBrowsingHistory()
        //热搜
        self.getHotWords()
        
    }

}

extension SearchLawsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeLawsViewCell", for: indexPath) as! HomeLawsViewCell
        let model = self.allArray[indexPath.row]
        cell.model = model
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        headView.backgroundColor = .init(cssStr: "#F8F9FB")
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.font = .regularFontOfSize(size: 12)
        nameLabel.textColor = .init(cssStr: "#666666")
        let count = String(self.model?.total ?? 0)
        nameLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "搜索到\(count)条法律法规信息", font: .regularFontOfSize(size: 12))
        headView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(11)
            make.height.equalTo(16.5)
        }
        return headView
    }
    
    //获取公告信息
    private func getNoticeListInfo() {
        ViewHud.addLoadView()
        let dict = ["pageNum": pageNum,
                    "pageSize": pageSize,
                    "title": self.searchView.searchTx.text ?? "",
                    "lawNature": lawNature,
                    "timeliness": timeliness] as [String : Any]
        let man = RequestManager()
        man.requestAPI(params: dict, pageUrl: "/firminfo/laws/list", method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let self = self, let model = success.data, let total = model.total {
                    self.model = model
                    if pageNum == 1 {
                        pageNum = 1
                        self.allArray.removeAll()
                    }
                    self.oneItemArray.accept(model.lawNatureList ?? [])
                    self.twoItemArray.accept(model.timelinessList ?? [])
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
                    if total > 0 {
                        self.oneView.isHidden = true
                        self.tableView.isHidden = false
                    }else {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.allArray[indexPath.row]
        let pageUrl = model.ossUrl ?? ""
        self.pushWebPage(from: pageUrl)
    }
    
}

extension SearchLawsViewController {
    
    //最近搜索
    private func getlastSearch() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["searchType": "",
                    "moduleId": "03"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/searchRecord/query",
                       method: .post) { [weak self] result in
            ViewHud.hideLoadView()
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let rows = success.data?.data {
                    reloadSearchUI(data: rows)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //最近搜索UI刷新
    func reloadSearchUI(data: [rowsModel]) {
        var strArray: [String] = []
        if data.count > 0 {
            for model in data {
                strArray.append(model.searchContent ?? "")
            }
            self.oneView.searchView.tagListView.removeAllTags()
            self.oneView.searchView.tagListView.addTags(strArray)
            self.oneView.searchView.isHidden = false
            self.oneView.layoutIfNeeded()
            let height = self.oneView.searchView.tagListView.frame.height
            self.oneView.searchView.snp.updateConstraints { make in
                make.height.equalTo(30 + height + 20)
            }
        } else {
            self.oneView.searchView.isHidden = true
            self.oneView.searchView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        self.oneView.layoutIfNeeded()
    }
    
    //浏览历史
    private func getBrowsingHistory() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
        let dict = ["customernumber": customernumber,
                    "viewrecordtype": "",
                    "moduleId": "03",
                    "pageNum": "1",
                    "pageSize": "20"]
        man.requestAPI(params: dict, pageUrl: "/operation/clientbrowsecb/selectBrowserecord", method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            switch result {
            case .success(let success):
                guard let self = self else { return }
                if let rows = success.data?.rows {
                    readHistoryUI(data: rows)
                }
                break
            case .failure(_):
                
                break
            }
        }
    }
    
    //UI刷新
    func readHistoryUI(data: [rowsModel]) {
        for (index, model) in data.enumerated() {
            let listView = CommonSearchListView()
            listView.block = { [weak self] in
                guard let self = self else { return }
                let pageUrl = "\(base_url)/personal-information/shareholder-situation"
                var dict: [String: String]
                let type = model.viewrecordtype ?? ""
                if type == "1" {
                    dict = ["firmname": model.firmname ?? "",
                            "entityId": model.firmnumber ?? "",
                            "isPerson": "0"]
                }else {
                    dict = ["personName": model.name ?? "",
                            "personNumber": model.eid ?? "",
                            "isPerson": "1"]
                }
                let webUrl = URLQueryAppender.appendQueryParameters(to: pageUrl, parameters: dict) ?? ""
                self.pushWebPage(from: webUrl)
            }
            listView.nameLabel.text = model.firmname ?? ""
            listView.timeLabel.text = model.createhourtime ?? ""
            listView.icon.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.firmname ?? "", size: (22, 22)))
            self.oneView.historyView.addSubview(listView)
            listView.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.width.equalTo(SCREEN_WIDTH)
                make.left.equalToSuperview()
                make.top.equalTo(self.oneView.historyView.lineView.snp.bottom).offset(40 * index)
            }
        }
        
        self.oneView.historyView.snp.updateConstraints { make in
            if data.count != 0 {
                self.oneView.historyView.isHidden = false
                make.height.equalTo((data.count) * 40 + 30)
            } else {
                self.oneView.historyView.isHidden = true
                make.height.equalTo(0)
            }
        }
        self.oneView.layoutIfNeeded()
    }
    
    //热搜
    private func getHotWords() {
        let man = RequestManager()
        ViewHud.addLoadView()
        let dict = ["moduleId": "03"]
        man.requestAPI(params: dict,
                       pageUrl: browser_hotwords,
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    hotsWordsUI(data: model.data ?? [])
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //UI刷新
    func hotsWordsUI(data: [rowsModel]) {
        for (index, model) in data.enumerated() {
            let listView = CommonSearchListView()
            listView.block = { [weak self] in
                guard let self = self else { return }
                let pageUrl = "\(base_url)/personal-information/shareholder-situation"
                var dict: [String: String]
                let type = model.type ?? ""
                if type == "1" {
                    dict = ["firmname": model.name ?? "",
                            "entityId": model.eid ?? "",
                            "isPerson": "0"]
                }else {
                    dict = ["personName": model.name ?? "",
                            "personNumber": model.eid ?? "",
                            "isPerson": "1"]
                }
                let webUrl = URLQueryAppender.appendQueryParameters(to: pageUrl, parameters: dict) ?? ""
                self.pushWebPage(from: webUrl)
            }
            listView.nameLabel.text = model.name ?? ""
            listView.icon.kf.setImage(with: URL(string: model.logo ?? ""), placeholder: UIImage.imageOfText(model.name ?? "", size: (22, 22)))
            self.oneView.hotWordsView.addSubview(listView)
            listView.snp.updateConstraints { make in
                make.height.equalTo(40)
                make.left.right.equalToSuperview()
                make.top.equalTo(self.oneView.hotWordsView.lineView.snp.bottom).offset(40 * index)
            }
        }
        
        self.oneView.hotWordsView.snp.updateConstraints { make in
            if data.count != 0 {
                self.oneView.hotWordsView.isHidden = false
                make.height.equalTo((data.count) * 40 + 30)
            } else {
                self.oneView.hotWordsView.isHidden = true
                make.height.equalTo(0)
            }
        }
        self.oneView.layoutIfNeeded()
    }
    
    //删除最近搜索
    private func deleteSearchInfo() {
        ShowAlertManager.showAlert(title: "删除", message: "是否需要删除最近搜索?", confirmAction: {
            let man = RequestManager()
            ViewHud.addLoadView()
            let dict = ["searchType": "",
                        "moduleId": "03"]
            man.requestAPI(params: dict,
                           pageUrl: "/operation/searchRecord/clear",
                           method: .post) { result in
                ViewHud.hideLoadView()
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        ToastViewConfig.showToast(message: "删除成功")
                        self.oneView.searchView.isHidden = true
                        self.oneView.searchView.snp.updateConstraints({ make in
                            make.height.equalTo(0)
                        })
                    }
                    break
                case .failure(_):
                    break
                }
            }
        })
    }
    
    //删除浏览历史
    private func deleteHistoryInfo() {
        ShowAlertManager.showAlert(title: "删除", message: "是否需要删除浏览历史?", confirmAction: {
            let man = RequestManager()
            ViewHud.addLoadView()
            let customernumber = GetSaveLoginInfoConfig.getCustomerNumber()
            let dict = ["customernumber": customernumber,
                        "moduleId": "03",
                        "viewrecordtype": ""]
            man.requestAPI(params: dict,
                           pageUrl: "/operation/clientbrowsecb/deleteBrowseRecord",
                           method: .get) { result in
                ViewHud.hideLoadView()
                switch result {
                case .success(let success):
                    if success.code == 200 {
                        ToastViewConfig.showToast(message: "删除成功")
                        self.oneView.historyView.isHidden = true
                        self.oneView.historyView.snp.updateConstraints({ make in
                            make.height.equalTo(0)
                        })
                    }
                    break
                case .failure(_):
                    break
                }
            }
        })
    }
    
}
