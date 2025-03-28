//
//  PropertyThreePeopleViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/20.
//

import UIKit
import RxSwift
import RxRelay
import MJRefresh
import DropMenuBar
import SkeletonView

class PropertyThreePeopleViewController: WDBaseViewController {
    
    private let man = RequestManager()
    
    weak var navController: UINavigationController?
    
    var groupList = BehaviorRelay<[rowsModel]>(value: [])
    
    //参数
    var groupId: String = ""
    var monitorTime: String = ""
    var monitorTimeBegin: String = ""
    var monitorTimeEnd: String = ""
    var registerCapital: String = ""
    var entityName: String = ""
    var pageNum: Int = 1
    var allArray: [itemsModel] = []//加载更多
    var dataModel: DataModel?
    
    lazy var searchView: HomeItemSearchView = {
        let searchView = HomeItemSearchView()
        let attrString = NSMutableAttributedString(string: "请输入企业、人员名", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#999999") as Any,
            .font: UIFont.mediumFontOfSize(size: 14)
        ])
        searchView.searchTx.attributedPlaceholder = attrString
        searchView.backgroundColor = .white
        return searchView
    }()
    
    lazy var moreView: PropertyMoreLineView = {
        let moreView = PropertyMoreLineView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 150))
        return moreView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(PropertMonitoringListViewCell.self, forCellReuseIdentifier: "PropertMonitoringListViewCell")
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
        view.addSubview(searchView)
        searchView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalToSuperview().offset(0.5)
            make.height.equalTo(45)
        }
        
        //搜索
        self.searchView.searchTx
            .rx
            .controlEvent(.editingChanged)
            .withLatestFrom(self.searchView.searchTx.rx.text.orEmpty)
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] keywords in
                guard let self = self else { return }
                if self.containsOnlyChinese(keywords) == true {
                    self.pageNum = 1
                    self.entityName = keywords
                    getListInfo()
                }else if self.containsPinyin(keywords) == true {
                    // 拼音不打印，什么都不做
                }
            }).disposed(by: disposeBag)
        
        let oneMenu = MenuAction(title: "类型", style: .typeList)!
        self.groupList.asObservable().subscribe(onNext: { [weak self] modelArray in
            guard let self = self else { return }
            oneMenu.listDataSource = getPropertyLineGroupMenuInfo(from: modelArray)
        }).disposed(by: disposeBag)
        oneMenu.didSelectedMenuResult = { [weak self] index, model, granted in
            self?.groupId = model?.currentID ?? ""
            self?.pageNum = 1
            self?.getListInfo()
        }
        
        let twoMenu = MenuAction(title: "时间", style: .typeCustom)!
        var modelArray = getListTime(from: true)
        twoMenu.displayCustomWithMenu = { [weak self] in
            let timeView = TimeDownView()
            timeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 315)
            //点击全部,今天,近一周等
            timeView.block = { model in
                self?.pageNum = 1
                self?.monitorTime = model.currentID ?? ""
                self?.monitorTimeBegin = ""
                self?.monitorTimeEnd = ""
                if model.displayText != "全部" {
                    twoMenu.adjustTitle(model.displayText ?? "", textColor: UIColor.init(cssStr: "#547AFF"))
                }else {
                    twoMenu.adjustTitle("时间", textColor: UIColor.init(cssStr: "#666666"))
                }
                self?.getListInfo()
            }
            //点击开始时间
            timeView.startTimeBlock = { [weak self] btn in
                self?.getPopTimeDatePicker(completion: { time in
                    self?.monitorTimeBegin = time ?? ""
                    btn.setTitle(time, for: .normal)
                    btn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
                    if ((self?.monitorTimeBegin.isEmpty) != nil) && ((self?.monitorTimeEnd.isEmpty) != nil) {
                        timeView.btn?.isEnabled = true
                        timeView.btn?.backgroundColor = UIColor.init(cssStr: "#307CFF")
                    }
                })
            }
            //点击结束时间
            timeView.endTimeBlock = { [weak self] btn in
                self?.getPopTimeDatePicker(completion: { time in
                    self?.monitorTimeEnd = time ?? ""
                    btn.setTitle(time, for: .normal)
                    btn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
                    if ((self?.monitorTimeBegin.isEmpty) != nil) && ((self?.monitorTimeEnd.isEmpty) != nil) {
                        timeView.btn?.isEnabled = true
                        timeView.btn?.backgroundColor = UIColor.init(cssStr: "#307CFF")
                    }
                })
            }
            //点击确认
            timeView.sureTimeBlock = { [weak self] btn in
                self?.pageNum = 1
                self?.monitorTime = ""
                let startTime = self?.monitorTimeEnd ?? ""
                let endTime = self?.monitorTimeBegin ?? ""
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if let startDate = dateFormatter.date(from: startTime),
                   let endDate = dateFormatter.date(from: endTime) {
                    if startDate > endDate {
                        ToastViewConfig.showToast(message: "时间格式不正确")
                        return
                    }
                } else {
                    ToastViewConfig.showToast(message: "时间格式不正确")
                    return
                }
                twoMenu.adjustTitle(startTime + "|" + endTime, textColor: UIColor.init(cssStr: "#547AFF"))
                modelArray = self?.getListTime(from: false) ?? []
                self?.getListInfo()
            }
            timeView.modelArray = modelArray
            timeView.tableView.reloadData()
            return timeView
        }
        
        let menuView = DropMenuBar(action: [oneMenu, twoMenu])!
        menuView.backgroundColor = .white
        view.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(32)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.top.equalTo(menuView.snp.bottom).offset(1)
        }
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            pageNum = 1
            getListInfo()
        })
        
        //添加上拉加载更多
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getListInfo()
        })
        //获取分组信息
        getGroupInfo()
        //获取列表信息
        getListInfo()
    }
    
}

/** 网络数据请求 */
extension PropertyThreePeopleViewController {
    
    //获取分组
    private func getGroupInfo() {
        let dict = [String: String]()
        let man = RequestManager()
        man.requestAPI(params: dict, pageUrl: "/firminfo/monitor/group", method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    self?.groupList.accept(success.data?.groupList ?? [])
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取监控列表信息
    private func getListInfo() {
        let dict = ["entityName": entityName,
                    "entityType": "2",
                    "groupId": groupId,
                    "monitorTime": monitorTime,
                    "monitorTimeBegin": monitorTimeBegin,
                    "monitorTimeEnd": monitorTimeEnd,
                    "registerCapital": registerCapital,
                    "pageNum": pageNum,
                    "pageSize": 20] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/monitor/list",
                       method: .get) { [weak self] result in
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self, let model = success.data, let total = model.total {
                        self.dataModel = model
                        if pageNum == 1 {
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
                }
                break
            case .failure(_):
                break
            }
        }
    }
}

//extension PropertyThreePeopleViewController: SkeletonTableViewDataSource {
//    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
//        return "PropertyListViewCell"
//    }
//
//    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 20
//    }
//}


extension PropertyThreePeopleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertMonitoringListViewCell", for: indexPath) as! PropertMonitoringListViewCell
        let model = self.allArray[indexPath.row]
        cell.selectionStyle = .none
        model.searchStr = self.searchView.searchTx.text ?? ""
        cell.model = model
        cell.cellBlock = { [weak self] in
            guard let self = self else { return }
            self.tableView(tableView, didSelectRowAt: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.allArray[indexPath.row]
        let bothVc = PropertyLineBothViewController()
        let enityId = model.entityId ?? ""
        let companyName = model.entityName ?? ""
        bothVc.enityId.accept(enityId)
        bothVc.companyName.accept(companyName)
        bothVc.logoUrl = model.logo ?? ""
        bothVc.monitor = true
        self.navigationController?.pushViewController(bothVc, animated: true)
    }
    
}
