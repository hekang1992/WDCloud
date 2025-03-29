//
//  MySelfRiskDetailViewController.swift
//  问道云
//
//  Created by Andrew on 2025/1/17.
//  自身风险

import UIKit
import JXPagingView
import DropMenuBar
import RxRelay
import TYAlertController

class MySelfRiskDetailViewController: WDBaseViewController {
    
    var enityId: String = ""
    var name: String = ""
    var logo: String = ""
    
    var functionType: String = "1"
    var dateType: String = ""
    var itemtype: String = "1"
    var allArray: [itemDtoListModel]?
    //主头部信息
    var mainHeadView: CompanyRiskDetailHeadView?
    
    var listViewDidScrollCallback: ((UIScrollView) -> Void)?
    
    var monitoringTime: String = ""
    var groupName: String = ""
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        return whiteView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(RiskDetailViewCell.self, forCellReuseIdentifier: "RiskDetailViewCell")
        return tableView
    }()
    
    //法律风险
    lazy var lawView: CompanyLawListView = {
        let lawView = CompanyLawListView()
        lawView.backgroundColor = .white
        lawView.isHidden = true
        lawView.oneBlock = { model1, model2 in
            let riskSecondVc = ComanyRiskMoreDetailViewController()
            riskSecondVc.itemsModel.accept(model1)
            riskSecondVc.listmodel.accept(model2)
            riskSecondVc.dateType = self.dateType
            riskSecondVc.logo = self.logo
            riskSecondVc.name = self.name
            riskSecondVc.orgId = self.enityId
            self.navigationController?.pushViewController(riskSecondVc, animated: true)
        }
        
        lawView.block = { model in
            let riskSecondVc = ComanyRiskMoreDetailViewController()
            riskSecondVc.itemsModel.accept(model)
            riskSecondVc.dateType = self.dateType
            riskSecondVc.logo = self.logo
            riskSecondVc.name = self.name
            riskSecondVc.orgId = self.enityId
            self.navigationController?.pushViewController(riskSecondVc, animated: true)
        }
        return lawView
    }()
    
    //经营风险
    lazy var onelabel: PaddedLabel = {
        let onelabel = PaddedLabel()
        onelabel.text = "经营风险"
        onelabel.backgroundColor = .init(cssStr: "#547AFF")
        onelabel.textColor = .white
        onelabel.font = .mediumFontOfSize(size: 13)
        onelabel.isUserInteractionEnabled = true
        onelabel.layer.cornerRadius = 4
        onelabel.layer.masksToBounds = true
        onelabel.padding = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        onelabel.layer.borderWidth = 1
        onelabel.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        onelabel.textAlignment = .center
        return onelabel
    }()
    
    //法律风险
    lazy var twolabel: PaddedLabel = {
        let twolabel = PaddedLabel()
        twolabel.text = "法律风险"
        twolabel.backgroundColor = .white
        twolabel.textColor = .init(cssStr: "#547AFF")
        twolabel.font = .mediumFontOfSize(size: 13)
        twolabel.isUserInteractionEnabled = true
        twolabel.layer.cornerRadius = 4
        twolabel.layer.masksToBounds = true
        twolabel.padding = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        twolabel.layer.borderWidth = 1
        twolabel.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        twolabel.textAlignment = .center
        return twolabel
    }()
    
    //财务风险
    lazy var threelabel: PaddedLabel = {
        let threelabel = PaddedLabel()
        threelabel.text = "财务风险"
        threelabel.backgroundColor = .white
        threelabel.textColor = .init(cssStr: "#547AFF")
        threelabel.font = .mediumFontOfSize(size: 13)
        threelabel.isUserInteractionEnabled = true
        threelabel.layer.cornerRadius = 4
        threelabel.layer.masksToBounds = true
        threelabel.textAlignment = .center
        threelabel.padding = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        threelabel.layer.borderWidth = 1
        threelabel.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        return threelabel
    }()
    
    //舆情风险
    lazy var fourlabel: PaddedLabel = {
        let fourlabel = PaddedLabel()
        fourlabel.text = "舆情风险"
        fourlabel.textAlignment = .center
        fourlabel.backgroundColor = .white
        fourlabel.textColor = .init(cssStr: "#547AFF")
        fourlabel.font = .mediumFontOfSize(size: 13)
        fourlabel.isUserInteractionEnabled = true
        fourlabel.layer.cornerRadius = 4
        fourlabel.layer.masksToBounds = true
        fourlabel.padding = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        fourlabel.layer.borderWidth = 1
        fourlabel.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        return fourlabel
    }()
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textAlignment = .left
        numLabel.font = .regularFontOfSize(size: 12)
        numLabel.textColor = .init(cssStr: "#333333")
        return numLabel
    }()
    
    lazy var highNumLabel: UILabel = {
        let highNumLabel = UILabel()
        highNumLabel.textAlignment = .left
        highNumLabel.font = .regularFontOfSize(size: 12)
        highNumLabel.textColor = .init(cssStr: "#333333")
        return highNumLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.text = "时间"
        timeLabel.font = .regularFontOfSize(size: 12)
        timeLabel.textColor = .init(cssStr: "#9FA4AD")
        timeLabel.textAlignment = .left
        return timeLabel
    }()
    
    lazy var maskView: UIView = {
        let maskView = UIView()
        maskView.layer.borderWidth = 1
        maskView.layer.borderColor = UIColor.init(cssStr: "#FF0000")?.cgColor
        maskView.backgroundColor = .init(cssStr: "#FFF7F7")
        return maskView
    }()
    
    lazy var totalItemView: RiskNumView = {
        let totalItemView = RiskNumView()
        totalItemView.nameLabel.text = "风险数"
        totalItemView.numLabel.textColor = .init(cssStr: "#FF0000")
        totalItemView.numLabel.font = .mediumFontOfSize(size: 14)
        return totalItemView
    }()
    
    lazy var oneItemView: RiskNumView = {
        let oneItemView = RiskNumView()
        oneItemView.nameLabel.text = "高风险"
        oneItemView.numLabel.textColor = .init(cssStr: "#FF0000")
        oneItemView.numLabel.font = .mediumFontOfSize(size: 14)
        return oneItemView
    }()
    
    lazy var twoItemView: RiskNumView = {
        let twoItemView = RiskNumView()
        twoItemView.nameLabel.text = "低风险"
        twoItemView.numLabel.textColor = .init(cssStr: "#333333")
        twoItemView.numLabel.font = .mediumFontOfSize(size: 14)
        return twoItemView
    }()
    
    lazy var threeItemView: RiskNumView = {
        let threeItemView = RiskNumView()
        threeItemView.nameLabel.text = "提示信息"
        threeItemView.numLabel.textColor = .init(cssStr: "#FF0000")
        threeItemView.numLabel.font = .mediumFontOfSize(size: 14)
        return threeItemView
    }()
    
    var startDateRelay = BehaviorRelay<String?>(value: nil)//开始时间
    
    var endDateRelay = BehaviorRelay<String?>(value: nil)//结束时间
    
    var startTime: String = ""//开始时间
    
    var endTime: String = ""//结束时间
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(numLabel)
        view.addSubview(highNumLabel)
        view.addSubview(timeLabel)
        view.addSubview(whiteView)
        whiteView.addSubview(onelabel)
        whiteView.addSubview(twolabel)
        whiteView.addSubview(threelabel)
        whiteView.addSubview(fourlabel)
        view.addSubview(maskView)
        maskView.addSubview(totalItemView)
        maskView.addSubview(oneItemView)
        maskView.addSubview(twoItemView)
        maskView.addSubview(threeItemView)
        view.addSubview(tableView)
        view.addSubview(lawView)
        
        numLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.left.equalToSuperview().offset(22)
            make.height.equalTo(25)
        }
        highNumLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.left.equalTo(numLabel.snp.right).offset(1)
            make.height.equalTo(25)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.right.equalToSuperview().offset(-60)
            make.height.equalTo(25)
        }
        whiteView.snp.makeConstraints { make in
            make.top.equalTo(numLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(48)
        }
        maskView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.top.equalTo(whiteView.snp.bottom)
            make.height.equalTo(61.5)
        }
        
        let labelWidth = (SCREEN_WIDTH - 57) * 0.25
        onelabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(26)
            make.width.equalTo(labelWidth)
        }
        twolabel.snp.makeConstraints { make in
            make.centerY.equalTo(onelabel.snp.centerY)
            make.left.equalTo(onelabel.snp.right).offset(11)
            make.height.equalTo(26)
            make.width.equalTo(labelWidth)
        }
        threelabel.snp.makeConstraints { make in
            make.centerY.equalTo(onelabel.snp.centerY)
            make.left.equalTo(twolabel.snp.right).offset(11)
            make.height.equalTo(26)
            make.width.equalTo(labelWidth)
        }
        fourlabel.snp.makeConstraints { make in
            make.centerY.equalTo(onelabel.snp.centerY)
            make.left.equalTo(threelabel.snp.right).offset(11)
            make.height.equalTo(26)
            make.width.equalTo(labelWidth)
        }
        totalItemView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalTo((SCREEN_WIDTH - 24) * 0.25)
        }
        oneItemView.snp.makeConstraints { make in
            make.left.equalTo(totalItemView.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo((SCREEN_WIDTH - 24) * 0.25)
        }
        twoItemView.snp.makeConstraints { make in
            make.left.equalTo(oneItemView.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo((SCREEN_WIDTH - 24) * 0.25)
        }
        threeItemView.snp.makeConstraints { make in
            make.left.equalTo(twoItemView.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo((SCREEN_WIDTH - 24) * 0.25)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(maskView.snp.bottom)
        }
        lawView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(maskView.snp.bottom)
        }
        // 绑定 onelabel 的点击事件
        onelabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.hideLawOrTableView(form: "")
                self?.updateSelectedLabel(self?.onelabel)
                self?.itemtype = "1"
                self?.getRiskDetailInfo()
            })
            .disposed(by: disposeBag)
        
        // 绑定 twolabel 的点击事件
        twolabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.hideLawOrTableView(form: "2")
                self?.updateSelectedLabel(self?.twolabel)
                self?.itemtype = "2"
                self?.getRiskDetailInfo()
            })
            .disposed(by: disposeBag)
        
        // 绑定 threelabel 的点击事件
        threelabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.hideLawOrTableView(form: "")
                self?.updateSelectedLabel(self?.threelabel)
                self?.itemtype = "3"
                self?.getRiskDetailInfo()
            })
            .disposed(by: disposeBag)
        
        // 绑定 fourlabel 的点击事件
        fourlabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.hideLawOrTableView(form: "")
                self?.updateSelectedLabel(self?.fourlabel)
                self?.itemtype = "4"
                self?.getRiskDetailInfo()
            })
            .disposed(by: disposeBag)
        
        
        let timeMenu = MenuAction(title: "全部", style: .typeCustom)!
        var modelArray = getListTime(from: true)
        let menuView = DropMenuBar(action: [timeMenu])!
        view.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.right.equalToSuperview().offset(-2)
            make.size.equalTo(CGSize(width: 60, height: 25))
        }
        timeMenu.displayCustomWithMenu = { [weak self] in
            let timeView = TimeDownView()
            if ((self?.startDateRelay.value?.isEmpty) != nil) && ((self?.endDateRelay.value?.isEmpty) != nil) {
                timeView.startDateRelay.accept(self?.startDateRelay.value)
                timeView.endDateRelay.accept(self?.endDateRelay.value)
            }
            timeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 315)
            
            timeView.block = { model in
                self?.dateType = model.currentID ?? ""
                self?.startTime = ""
                self?.endTime = ""
                self?.startDateRelay.accept("")
                self?.endDateRelay.accept("")
                //根据时间去筛选
                if self?.itemtype == "2" {
                    self?.getRiskDetailInfo()
                }else {
                    self?.getRiskDetailInfo()
                }
                if model.displayText != "全部" {
                    timeMenu.adjustTitle(model.displayText ?? "", textColor: UIColor.init(cssStr: "#547AFF"))
                }else {
                    timeMenu.adjustTitle("全部", textColor: UIColor.init(cssStr: "#666666"))
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
                self?.dateType = startTime + "|" + endTime
                timeMenu.adjustTitle(startTime + "|" + endTime, textColor: UIColor.init(cssStr: "#547AFF"))
                modelArray = self?.getListTime(from: false) ?? []
                //根据时间去筛选
                if self?.itemtype == "2" {
                    self?.getRiskDetailInfo()
                }else {
                    self?.getRiskDetailInfo()
                }
            }
            timeView.modelArray = modelArray
            timeView.tableView.reloadData()
            return timeView
        }
        getRiskDetailInfo()
        
    }
    
    private func updateSelectedLabel(_ selectedLabel: PaddedLabel?) {
        // 重置所有 label 的背景颜色
        resetLabelBackgroundColors()
        // 设置被点击的 label 的背景颜色
        selectedLabel?.backgroundColor = .init(cssStr: "#547AFF")
        selectedLabel?.textColor = .white
        selectedLabel?.layer.borderWidth = 1
        selectedLabel?.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
    }
    
    private func resetLabelBackgroundColors() {
        [onelabel, twolabel, threelabel, fourlabel].forEach { label in
            label.backgroundColor = .white
            label.textColor = .init(cssStr: "#547AFF")
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("===================")
    }
    
}

/** 网络数据请求 */
extension MySelfRiskDetailViewController {
    
    //显示和隐藏
    private func hideLawOrTableView(form type: String) {
//        if type == "2" {
//            self.lawView.isHidden = false
//            self.tableView.isHidden = true
//        }else {
//            self.lawView.isHidden = true
//            self.tableView.isHidden = false
//        }
    }
    
    //获取风险信息
    private func getRiskDetailInfo() {
        let man = RequestManager()
        let dict = ["orgId": enityId,
                    "functionType": functionType,
                    "itemType": itemtype,
                    "dateType": dateType]
        man.requestAPI(params: dict,
                       pageUrl: "/entity/risk-monitor/statisticOrgRisk",
                       method: .get) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if let model = success.data {
                    let modelArray = model.notRelevaRiskDto?.itemDtoList ?? []
                    self.allArray = modelArray
                    self.tableView.reloadData()
                    self.refreshUI(from: model)
                    self.emptyView.removeFromSuperview()
                    if modelArray.isEmpty {
                        self.addNodataView(from: self.tableView)
                    }
                }
                break
            case .failure(_):
                self.addNodataView(from: self.tableView)
                break
            }
        }
    }
    
    //数据刷新
    func refreshUI(from model: DataModel) {
        let count = String(model.totalRiskCnt ?? 0)
        let highcount = String(model.highLevelCnt ?? 0)
        self.numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "累计风险\(count)条/", colorStr: "#FF0000", font: UIFont.regularFontOfSize(size: 12))
        self.highNumLabel.attributedText = GetRedStrConfig.getRedStr(from: highcount, fullText: "高风险\(highcount)条", colorStr: "#FF0000", font: UIFont.regularFontOfSize(size: 12))
        self.totalItemView.numLabel.text = String(model.notRelevaRiskDto?.totalRiskCnt ?? 0)
        self.oneItemView.numLabel.text = String(model.notRelevaRiskDto?.highLevelCnt ?? 0)
        self.twoItemView.numLabel.text = String(model.notRelevaRiskDto?.lowLevelCnt ?? 0)
        self.threeItemView.numLabel.text = String(model.notRelevaRiskDto?.tipLevelCnt ?? 0)
        let startTime = model.monitorStartDate ?? ""
        let endTime = model.monitorEndDate ?? ""
        let monitorFlag = model.monitorFlag ?? 0
        let groupName = model.groupName ?? ""
        showOrHideMonitoringInfo(from: monitorFlag, startTime: startTime, endTime: endTime, groupName: groupName)
    }
    
    //刷新头部监控按钮信息
    private func showOrHideMonitoringInfo(from monitorFlag: Int, startTime: String, endTime: String, groupName: String) {
        //头部信息
        if monitorFlag != 0 {
            let allTime = "监控周期:\(startTime) - \(endTime)"
            mainHeadView?.timeLabel.text = allTime
            mainHeadView?.tagLabel.text = groupName
            mainHeadView?.tagLabel.isHidden = false
            self.monitoringTime = allTime
            self.groupName = groupName
            mainHeadView?.monitoringBtn.isHidden = true
        }else {
            mainHeadView?.timeLabel.text = ""
            mainHeadView?.tagLabel.isHidden = true
            mainHeadView?.monitoringBtn.isHidden = false
        }
    }
}

extension MySelfRiskDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RiskDetailViewCell", for: indexPath) as? RiskDetailViewCell else { return UITableViewCell() }
        let model = self.allArray?[indexPath.row]
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.model.accept(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.allArray?[indexPath.row] {
            checkClickInfo(form: model)
        }
    }
    
}

/** 网络数据请求 */
extension MySelfRiskDetailViewController {
    
    //判断是否有权限点击
    private func checkClickInfo(form model: itemDtoListModel) {
        let itemId = model.itemId ?? ""
        let entityId = self.enityId
        let entityName = self.name
        let man = RequestManager()
        let dict = ["entityType": "1",
                    "itemId": itemId,
                    "entityId": entityId,
                    "entityName": entityName]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/equity-risk/check",
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                guard let self = self else { return }
                if success.code == 200 {
                    let riskSecondVc = ComanyRiskMoreDetailViewController()
                    riskSecondVc.dateType = self.dateType
                    riskSecondVc.logo = self.logo
                    riskSecondVc.name = self.name
                    riskSecondVc.orgId = self.enityId
                    riskSecondVc.itemId = itemId
                    riskSecondVc.historyFlag = "0"
                    riskSecondVc.monitoringTime = self.monitoringTime
                    riskSecondVc.groupName = self.groupName
                    self.navigationController?.pushViewController(riskSecondVc, animated: true)
                }else if success.code == 702 {
                    self.buyOneVipInfo()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}

extension MySelfRiskDetailViewController {
    
    private func buyOneVipInfo() {
        let buyVipView = PopBuyVipView(frame: CGRectMake(0, 0, SCREEN_WIDTH, 400))
        buyVipView.bgImageView.image = UIImage(named: "poponereportimge")
        let alertVc = TYAlertController(alert: buyVipView, preferredStyle: .alert)!
        buyVipView.cancelBlock = {
            self.dismiss(animated: true)
        }
        buyVipView.buyOneBlock = { [weak self] in
            guard let self = self else { return }
            //跳转购买单次会员
            self.dismiss(animated: true, completion: {
                let oneVc = BuyMonitoringOneVipViewController()
                oneVc.entityType = 1
                oneVc.entityId = self.enityId
                oneVc.entityName = self.name
                //刷新列表
                oneVc.refreshBlock = { startTime, endTime in
                    //刷新头部消息
                    let allTime = "监控周期:\(startTime) - \(endTime)"
                    self.mainHeadView?.timeLabel.text = allTime
                    self.mainHeadView?.tagLabel.text = "默认分钟"
                    self.mainHeadView?.tagLabel.isHidden = false
                    self.mainHeadView?.monitoringBtn.isHidden = true
                }
                self.navigationController?.pushViewController(oneVc, animated: true)
            })
        }
        buyVipView.buyVipBlock = {
            //跳转购买会员
            self.dismiss(animated: true, completion: {
                let memVc = MembershipCenterViewController()
                self.navigationController?.pushViewController(memVc, animated: true)
            })
        }
        self.present(alertVc, animated: true)
    }
    
}

extension MySelfRiskDetailViewController: JXPagingViewListViewDelegate {
    
    func listView() -> UIView {
        return view
    }
    
    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }
    
    func listScrollView() -> UIScrollView { tableView }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        listViewDidScrollCallback?(scrollView)
    }
    
}
