//
//  HomeLawsViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/10.
//  

import UIKit
import RxSwift
import DropMenuBar
import MJRefresh
import RxRelay
import SwiftyJSON

class HomeLawsViewController: WDBaseViewController {

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
    
    //请求参数
    var pageNum: Int = 1
    var pageSize: Int = 20
    var allArray: [itemsModel] = []
    var shareSearchKey: String = ""
    var model: DataModel?
    
    var oneItemArray = BehaviorRelay<[itemsModel]>(value: [])
    var twoItemArray = BehaviorRelay<[itemsModel]>(value: [])
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(HomeLawsViewCell.self, forCellReuseIdentifier: "HomeLawsViewCell")
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
        
        
        let oneMenu = MenuAction(title: "效力位阶", style: .typeCustom)!
        let twoMenu = MenuAction(title: "时效性", style: .typeCustom)!
        
        let menuView = DropMenuBar(action: [oneMenu, twoMenu])!
        menuView.backgroundColor = .white
        view.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(34)
            make.top.equalTo(searchView.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH)
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
        getOneMenuInfo()
        getTwoMenuInfo()
    }

}

extension HomeLawsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        nameLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "搜索到\(count)条法律法规信息")
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
                    "title": shareSearchKey] as [String : Any]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.allArray[indexPath.row]
        let pageUrl = model.ossUrl ?? ""
        self.pushWebPage(from: pageUrl)
    }
    
}

extension HomeLawsViewController {
    
    //效力
    private func getOneMenuInfo() {
        let man = RequestManager()
        let dict = ["code": "ztbgglx"]
        man.requestAPI(params: dict, pageUrl: "/firminfo/intellectualpropertys/getcategoryofworks", method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if let self = self {
                    
                }
                break
            case .failure(let failure):
                break
            }
        }
    }
    
    //时效性
    private func getTwoMenuInfo() {
        let man = RequestManager()
        let dict = ["code": "ztbzbfs"]
        man.requestAPI(params: dict, pageUrl: "/firminfo/intellectualpropertys/getcategoryofworks", method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                
                break
            case .failure(let failure):
                break
            }
        }
    }
}
