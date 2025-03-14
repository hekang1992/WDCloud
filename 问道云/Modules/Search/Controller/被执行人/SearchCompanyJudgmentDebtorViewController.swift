//
//  SearchCompanyJudgmentDebtorViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/12.
//

import UIKit
import RxRelay
import MJRefresh
import DropMenuBar

class SearchCompanyJudgmentDebtorViewController: WDBaseViewController {
    
    var startDateRelay = BehaviorRelay<String?>(value: nil)//开始时间
    var endDateRelay = BehaviorRelay<String?>(value: nil)//结束时间
    var startTime: String = ""//开始时间
    var endTime: String = ""//结束时间
    var isChoiceDate: String = ""
    
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
        
        let timeMenu = MenuAction(title: "时间", style: .typeCustom)!
        var modelArray = getListTime(from: true)
        timeMenu.displayCustomWithMenu = { [weak self] in
            let timeView = TimeDownView()
            if ((self?.startDateRelay.value?.isEmpty) != nil) && ((self?.endDateRelay.value?.isEmpty) != nil) {
                timeView.startDateRelay.accept(self?.startDateRelay.value)
                timeView.endDateRelay.accept(self?.endDateRelay.value)
            }
            timeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 315)
            //点击全部,今天,近一周等
            timeView.block = { model in
                self?.pageNum = 1
                self?.isChoiceDate = model.currentID ?? ""
                self?.getSearchPeopleInfo()
                self?.startTime = ""
                self?.endTime = ""
                self?.startDateRelay.accept("")
                self?.endDateRelay.accept("")
                if model.displayText != "全部" {
                    timeMenu.adjustTitle(model.displayText ?? "", textColor: UIColor.init(cssStr: "#547AFF"))
                }else {
                    timeMenu.adjustTitle("时间", textColor: UIColor.init(cssStr: "#666666"))
                }
            }
            //点击开始时间
            timeView.startTimeBlock = { [weak self] btn in
                self?.getPopTimeDatePicker(completion: { time in
                    self?.startTime = time ?? ""
                    btn.setTitle(time, for: .normal)
                    btn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
                    if ((self?.startTime.isEmpty) != nil) && ((self?.endTime.isEmpty) != nil) {
                        timeView.btn?.isEnabled = true
                        timeView.btn?.backgroundColor = UIColor.init(cssStr: "#307CFF")
                    }
                })
            }
            //点击结束时间
            timeView.endTimeBlock = { [weak self] btn in
                self?.getPopTimeDatePicker(completion: { time in
                    self?.endTime = time ?? ""
                    btn.setTitle(time, for: .normal)
                    btn.setTitleColor(UIColor.init(cssStr: "#547AFF"), for: .normal)
                    if ((self?.startTime.isEmpty) != nil) && ((self?.endTime.isEmpty) != nil) {
                        timeView.btn?.isEnabled = true
                        timeView.btn?.backgroundColor = UIColor.init(cssStr: "#307CFF")
                    }
                })
            }
            //点击确认
            timeView.sureTimeBlock = { [weak self] btn in
                let startTime = self?.startTime ?? ""
                let endTime = self?.endTime ?? ""
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
                self?.startDateRelay.accept(self?.startTime)
                self?.endDateRelay.accept(self?.endTime)
                self?.isChoiceDate = startTime + "|" + endTime
                timeMenu.adjustTitle(startTime + "|" + endTime, textColor: UIColor.init(cssStr: "#547AFF"))
                modelArray = self?.getListTime(from: false) ?? []
                self?.getSearchPeopleInfo()
            }
            timeView.modelArray = modelArray
            timeView.tableView.reloadData()
            return timeView
        }
        
        let menuView = DropMenuBar(action: [regionMenu, timeMenu])!
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

extension SearchCompanyJudgmentDebtorViewController {
    
    private func getSearchPeopleInfo() {
        
        let man = RequestManager()
        let dict = ["keywords": self.keyWords.value,
                    "type": "2",
                    "entityArea": entityArea,
                    "publishDate": isChoiceDate]
        man.requestAPI(params: dict,
                       pageUrl: "/riskmonitor/cooperation/getPersonAgainst",
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

extension SearchCompanyJudgmentDebtorViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        model.navHeadTitleStr = "被执行人"
        model.searchStr = self.keyWords.value
        cell.model.accept(model)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.allArray[indexPath.row]
        let detailVc = SearchCompanyDeadbeatDetailViewController()
        detailVc.model = model
        detailVc.nameTitle = "被执行人记录列表"
        detailVc.pageUrl = "/riskmonitor/cooperation/getPersonAgainstDetail"
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
    
}
