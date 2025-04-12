//
//  NoticeAllViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/10.
//  公告大全页面

import UIKit
import DropMenuBar
import MJRefresh
import RxRelay
import RxSwift

class NoticeAllViewController: WDBaseViewController {
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "公告大全"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setImage(UIImage(named: "rightHeadLogo"), for: .normal)
        return headView
    }()
    
    lazy var searchView: HomeItemSearchView = {
        let searchView = HomeItemSearchView()
        let attrString = NSMutableAttributedString(string: "请输入股票名称、代码", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#999999") as Any,
            .font: UIFont.mediumFontOfSize(size: 14)
        ])
        searchView.searchTx.attributedPlaceholder = attrString
        searchView.backgroundColor = .white
        return searchView
    }()
    
    lazy var covreView: UIView = {
        let covreView = UIView()
        covreView.backgroundColor = .init(cssStr: "#F3F3F3")
        return covreView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    var items: [String] = ["全部", "上交所", "深交所", "北交所", "港交所", "其他"]
    
    var buttons: [UIButton] = []
    
    var previousButton: UIButton?
    
    private let man = RequestManager()
    
    //请求参数
    var startDateRelay = BehaviorRelay<String?>(value: nil)//开始时间
    var endDateRelay = BehaviorRelay<String?>(value: nil)//结束时间
    var startTime: String = ""//开始时间
    var endTime: String = ""//结束时间
    var isChoiceDate: String = ""
    var shareSearchKey: String = ""
    var pageNum: Int = 1
    var allArray: [rowsModel] = []
    var tradingMarket: String = ""
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(HomeNoticeListCell.self, forCellReuseIdentifier: "HomeNoticeListCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        addHeadView(from: headView)
        view.addSubview(searchView)
        view.addSubview(covreView)
        covreView.addSubview(scrollView)
        searchView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headView.snp.bottom).offset(1)
            make.height.equalTo(50)
        }
        covreView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
            make.height.equalTo(40)
        }
        scrollView.snp.makeConstraints { make in
            make.center.equalTo(covreView)
            make.left.equalToSuperview().offset(2)
            make.top.equalToSuperview().offset(2.5)
            make.height.equalTo(35)
        }
        self.searchView.searchTx
            .rx
            .controlEvent(.editingChanged)
            .withLatestFrom(self.searchView.searchTx.rx.text.orEmpty)
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] keywords in
                self?.pageNum = 1
                self?.shareSearchKey = keywords
                self?.getNoticeListInfo()
        }).disposed(by: disposeBag)
        
        for (index, menuName) in items.enumerated() {
            // 创建按钮
            let button = UIButton(type: .custom)
            button.setTitle(menuName, for: .normal)
            button.setTitleColor(.init(cssStr: "#666666"), for: .normal)
            button.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.3)
            button.titleLabel?.font = .regularFontOfSize(size: 12)
            button.layer.cornerRadius = 2
            button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
            scrollView.addSubview(button)
            button.tag = index + 10 // 设置 tag 以便区分按钮
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside) // 添加点击事件
            buttons.append(button) // 将按钮添加到数组中
            // 设置按钮的约束
            button.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.equalTo(25)
                if let previousButton = previousButton {
                    make.left.equalTo(previousButton.snp.right).offset(9)
                } else {
                    make.left.equalToSuperview().offset(9)
                }
            }
            previousButton = button
            if index == items.count - 1 {
                button.snp.makeConstraints { make in
                    make.right.equalToSuperview().offset(-5)
                }
            }
        }
        if let firstBtn = buttons.first {
            buttonTapped(firstBtn)
        }
        
        let timeMenu = MenuAction(title: "时间", style: .typeCustom)!
        let menuView = DropMenuBar(action: [timeMenu])!
        menuView.backgroundColor = .white
        view.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.height.equalTo(34)
            make.top.equalTo(covreView.snp.bottom)
            make.width.equalTo(SCREEN_WIDTH)
        }
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
                self?.startTime = ""
                self?.endTime = ""
                self?.startDateRelay.accept("")
                self?.endDateRelay.accept("")
                self?.getNoticeListInfo()
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
                self?.pageNum = 1
                self?.getNoticeListInfo()
            }
            timeView.modelArray = modelArray
            timeView.tableView.reloadData()
            return timeView
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
        
        getNoticeListInfo()
    }
    
    //按钮点击方法
    @objc func buttonTapped(_ sender: UIButton) {
        // 恢复所有按钮的默认样式
        for button in buttons {
            button.backgroundColor = .init(cssStr: "#C8C8C8")?.withAlphaComponent(0.2)
            button.setTitleColor(.init(cssStr: "#666666"), for: .normal)
        }
        // 设置被点击按钮的样式
        sender.backgroundColor = .init(cssStr: "#547AFF")
        sender.setTitleColor(.white, for: .normal)
        let title = sender.titleLabel?.text ?? ""
        if title == "全部" {
            self.tradingMarket = ""
        }else if title == "上交所" {
            self.tradingMarket = "SSE"
        }else if title == "深交所" {
            self.tradingMarket = "SZ"
        }else if title == "北交所" {
            self.tradingMarket = "BSE"
        }else if title == "港交所" {
            self.tradingMarket = "HKEX"
        }else if title == "其他" {
            self.tradingMarket = "OTHER"
        }
        self.pageNum = 1
        self.getNoticeListInfo()
    }

}

extension NoticeAllViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNoticeListCell", for: indexPath) as! HomeNoticeListCell
        let model = self.allArray[indexPath.row]
        cell.model = model
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.allArray[indexPath.row]
        let pageUrl = model.announcementLink ?? ""
        self.pushWebPage(from: pageUrl)
    }
    
}

/** 网络数据请求 */
extension NoticeAllViewController {
    
    //获取公告信息
    private func getNoticeListInfo() {
        ViewHud.addLoadView()
        let dict = ["pageNum": pageNum,
                    "pageSize": 20,
                    "keywords": shareSearchKey,
                    "tradingMarket": tradingMarket,
                    "publishTime": isChoiceDate] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/v2/listing/ipo-anno/es",
                       method: .get) { [weak self] result in
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let self = self, let model = success.data, let total = model.total {
                    if pageNum == 1 {
                        pageNum = 1
                        self.allArray.removeAll()
                    }
                    pageNum += 1
                    let pageData = model.rows ?? []
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
                ViewHud.hideLoadView()
                break
            case .failure(_):
                ViewHud.hideLoadView()
                break
            }
        }
    }
    
}
