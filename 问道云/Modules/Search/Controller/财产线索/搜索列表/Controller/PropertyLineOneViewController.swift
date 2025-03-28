//
//  PropertyLineOneViewController.swift
//  问道云
//
//  Created by 何康 on 2025/3/21.
//

import UIKit
import RxRelay
import MJRefresh
import DropMenuBar
import SevenSwitch
import SkeletonView
import TYAlertController

class PropertyLineOneViewController: WDBaseViewController {
    
    var model = BehaviorRelay<DataModel?>(value: nil)
    //ID
    var entityId: String = ""
    //名字
    var entityName: String = ""
    //是否被监控
    var monitor: Bool = false
    //logourl
    var logoUrl: String = ""
    //参数
    var subjectId: String = ""//企业ID
    var subjectType: String = ""//类型1企业 2个人
    var pageIndex: Int = 1
    var conditionCode: String = ""//线索对象
    var clueDirection: String = ""//流入流出
    var clueModel: String = ""//线索类型
    var predictValue: String = ""//金额
    var updateTime: String = ""//时间
    
    //是否显示了下拉框
    var isShowListImage: Bool = false
    
    //所有数据
    var allArray: [pageItemsModel] = []
    
    var leftTitles: [String] = []
    var rightTitles: [String] = []
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = .init(cssStr: "#333333")
        nameLabel.font = .regularFontOfSize(size: 16)
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
        nameLabel.text = entityName
        return nameLabel
    }()
    
    lazy var oneBtn: UIButton = {
        let oneBtn = UIButton(type: .custom)
        oneBtn.setImage(UIImage(named: "scbaogaimge"), for: .normal)
        return oneBtn
    }()
    
    lazy var twoBtn: UIButton = {
        let twoBtn = UIButton(type: .custom)
        twoBtn.setImage(UIImage(named: "jianknogiamge"), for: .normal)
        twoBtn.setImage(UIImage(named: "yijingjiagnkongimagea"), for: .selected)
        return twoBtn
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .init(cssStr: "#ECF5FF")
        bgView.layer.cornerRadius = 2
        return bgView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    lazy var leftBtn: UIButton = {
        let leftBtn = UIButton(type: .custom)
        leftBtn.isSelected = true
        leftBtn.setImage(UIImage(named: "leftiamge_nor"), for: .normal)
        leftBtn.setImage(UIImage(named: "leftimge_sel"), for: .selected)
        return leftBtn
    }()
    
    lazy var rightBtn: UIButton = {
        let rightBtn = UIButton(type: .custom)
        rightBtn.setImage(UIImage(named: "rightimge_nor"), for: .normal)
        rightBtn.setImage(UIImage(named: "rightigmge_sel"), for: .selected)
        return rightBtn
    }()
    
    lazy var oneSwitch: SevenSwitch = {
        let oneSwitch = SevenSwitch()
        oneSwitch.on = true
        oneSwitch.onTintColor = .init(cssStr: "#547AFF")!
        oneSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: UIControl.Event.valueChanged)
        return oneSwitch
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.text = "线索解析"
        descLabel.textAlignment = .center
        descLabel.font = .regularFontOfSize(size: 10)
        descLabel.textColor = .init(cssStr: "#333333")
        return descLabel
    }()
    
    lazy var coverView: UIView = {
        let coverView = UIView()
        return coverView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(PropertyLineOneViewCell.self, forCellReuseIdentifier: "PropertyLineOneViewCell")
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
    
    lazy var moreView: PropertyLineSearchMoreView = {
        let moreView = PropertyLineSearchMoreView()
        return moreView
    }()
    
    lazy var listImageView: PropertyMonitoringListView = {
        let listImageView = PropertyMonitoringListView()
        return listImageView
    }()
    
    lazy var moreClueView: PropertyMonitoringClueListView = {
        let moreClueView = PropertyMonitoringClueListView()
        return moreClueView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(logoImageView)
        view.addSubview(nameLabel)
        logoImageView.kf.setImage(with: URL(string: self.logoUrl), placeholder: UIImage.imageOfText(self.entityName, size: (29, 29)))
        logoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 29, height: 29))
        }
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImageView.snp.centerY)
            make.left.equalTo(logoImageView.snp.right).offset(6)
            make.width.equalTo(SCREEN_WIDTH - 40)
        }
        twoBtn.isSelected = monitor
        view.addSubview(oneBtn)
        view.addSubview(twoBtn)
        
        oneBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(logoImageView.snp.bottom).offset(5)
            make.size.equalTo(CGSize(width: 175.pix(), height: 23.pix()))
        }
        
        twoBtn.snp.makeConstraints { make in
            make.left.equalTo(SCREEN_WIDTH - 175.pix() - 10)
            make.top.equalTo(logoImageView.snp.bottom).offset(5)
            make.size.equalTo(CGSize(width: 175.pix(), height: 23.pix()))
        }
        
        //点击
        twoBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if twoBtn.isSelected {
                if !isShowListImage {
                    view.addSubview(listImageView)
                    listImageView.snp.makeConstraints { make in
                        make.top.equalTo(self.twoBtn.snp.bottom).offset(1)
                        make.centerX.equalTo(self.twoBtn.snp.centerX)
                        make.size.equalTo(CGSize(width: 99.5.pix(), height: 133.pix()))
                    }
                    // Prepare for animation
                    listImageView.alpha = 0
                    listImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    // Animate
                    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                        self.listImageView.alpha = 1
                        self.listImageView.transform = .identity
                    })
                    isShowListImage = true
                }else {
                    listImageView.removeFromSuperview()
                    isShowListImage = false
                }
            }else {
                //根据权限判断是否可以监控
                let entityType = "1"
                let man = RequestManager()
                let dict = ["entityId": self.entityId,
                            "entityName": self.entityName,
                            "entityType": entityType]
                man.requestAPI(params: dict,
                               pageUrl: "/firminfo/monitor/cancel",
                               method: .post) { [weak self] result in
                    switch result {
                    case .success(let success):
                        guard let self = self else { return }
                        if success.code == 200 {
                            twoBtn.isSelected = true
                            ToastViewConfig.showToast(message: "监控成功")
                            self.addUnioInfo(form: entityId, name: entityName)
                        }else if success.code == 702 {
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
                                    let oneVc = BuyOnePropertyLineViewController()
                                    oneVc.entityType = 1
                                    oneVc.entityId = self.entityId
                                    oneVc.entityName = self.entityName
                                    //刷新列表
                                    oneVc.refreshBlock = {
                                        self.twoBtn.isSelected = true
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
                        break
                    case .failure(_):
                        break
                    }
                }
            }
        }).disposed(by: disposeBag)
        
        listImageView.oneBlock = { [weak self] in
            self?.isShowListImage = false
            self?.listImageView.removeFromSuperview()
            NotificationCenter.default.post(name: NSNotification.Name(ROOT_VC_PROPERYTY), object: nil)
        }
        
        listImageView.twoBlock = { [weak self] in
            guard let self = self else { return }
            self.isShowListImage = false
            self.listImageView.removeFromSuperview()
            ShowAlertManager.showAlert(title: "取消监控", message: "是否取消监控?", confirmAction: {
                let entityType = "1"
                let man = RequestManager()
                let dict = ["entityId": self.entityId,
                            "entityName": self.entityName,
                            "entityType": entityType]
                man.requestAPI(params: dict,
                               pageUrl: "/firminfo/monitor/cancel",
                               method: .post) { [weak self] result in
                    switch result {
                    case .success(let success):
                        guard let self = self else { return }
                        if success.code == 200 {
                            twoBtn.isSelected = false
                            ToastViewConfig.showToast(message: "取消监控成功")
                        }else if success.code == 702 {
                            
                        }
                        break
                    case .failure(_):
                        break
                    }
                }
            })
        }
        
        listImageView.threeBlock = { [weak self] in
            //设置分组
            self?.isShowListImage = false
            self?.listImageView.removeFromSuperview()
            self?.getGroupInfo()
        }
        
        listImageView.fourBlock = { [weak self] in
            self?.isShowListImage = false
            self?.listImageView.removeFromSuperview()
            let checkVc = MyCheckSettingViewController()
            self?.navigationController?.pushViewController(checkVc, animated: true)
        }
        
        view.addSubview(bgView)
        bgView.addSubview(leftBtn)
        bgView.addSubview(rightBtn)
        bgView.addSubview(stackView)
        
        bgView.snp.makeConstraints { make in
            make.top.equalTo(oneBtn.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(SCREEN_WIDTH - 20)
        }
        
        leftBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(6)
            make.top.equalToSuperview().offset(8.5)
            make.width.equalTo(84)
            make.height.equalTo(27.5)
        }
        
        rightBtn.snp.makeConstraints { make in
            make.left.equalTo(leftBtn.snp.right).offset(10)
            make.top.equalToSuperview().offset(8.5)
            make.width.equalTo(84)
            make.height.equalTo(27.5)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(leftBtn.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(3.5)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-6)
        }
        
        leftBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            leftBtn.isSelected = true
            rightBtn.isSelected = false
            configure(with: leftTitles)
        }).disposed(by: disposeBag)
        
        rightBtn.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            leftBtn.isSelected = false
            rightBtn.isSelected = true
            configure(with: rightTitles)
        }).disposed(by: disposeBag)
        
        let oneMenu = MenuAction(title: "线索对象", style: .typeCustom)!
        let twoMenu = MenuAction(title: "财产流向", style: .typeList)!
        let threeMenu = MenuAction(title: "线索类型", style: .typeList)!
        let fourMenu = MenuAction(title: "更多", style: .typeCustom)!
        let menuView = DropMenuBar(action: [oneMenu, twoMenu, threeMenu, fourMenu])!
        view.addSubview(coverView)
        coverView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
        }
        
        coverView.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(35)
            make.width.equalTo(SCREEN_WIDTH - 40)
        }
        //线索对象
        self.model.asObservable()
            .map { $0?.conditionVO?.cueObject ?? [] }
            .subscribe(onNext: { [weak self] modelArray in
                guard let self = self else { return }
                oneMenu.displayCustomWithMenu = { [weak self] in
                    guard let self = self else { return UIView() }
                    moreClueView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200)
                    moreClueView.listModelArray = modelArray
                    moreClueView.tableView1.reloadData()
                    return moreClueView
                }
                moreClueView.modelBlock = { [weak self] model in
                    oneMenu.adjustTitle(model.key ?? "", textColor: UIColor.init(cssStr: "#547AFF"))
                    self?.pageIndex = 1
                    self?.conditionCode = model.value ?? ""
                    self?.getListInfo()
                }
                moreClueView.addBtnBlock = { [weak self] in
                    let customRelationFlag = self?.model.value?.conditionVO?.customRelationFlag ?? 0
                    if customRelationFlag == 0 {
                        //可以跳转
                    }else {
                        //弹窗购买会员
                    }
                    oneMenu.dismiss()
                }
            }).disposed(by: disposeBag)
        
        //财产留向
        self.model.asObservable()
            .map { $0?.conditionVO?.propertyDirection ?? [] }
            .subscribe(onNext: { [weak self] modelArray in
                guard let self = self else { return }
                let modelArray = getTwoPropertyLineInfo(from: modelArray)
                twoMenu.listDataSource = modelArray
            }).disposed(by: disposeBag)
        twoMenu.didSelectedMenuResult = { [weak self] index, model, granted in
            self?.pageIndex = 1
            self?.clueDirection = model?.currentID ?? ""
            self?.getListInfo()
        }
        
        //线索类型
        self.model.asObservable()
            .map { $0?.conditionVO?.cueType ?? [] }
            .subscribe(onNext: { [weak self] modelArray in
                guard let self = self else { return }
                let modelArray = getTwoPropertyLineInfo(from: modelArray)
                threeMenu.listDataSource = modelArray
            }).disposed(by: disposeBag)
        threeMenu.didSelectedMenuResult = { [weak self] index, model, granted in
            self?.pageIndex = 1
            self?.clueModel = model?.currentID ?? ""
            self?.getListInfo()
        }
        
        //更多筛选条件
        fourMenu.displayCustomWithMenu = { [weak self] in
            guard let self = self else { return UIView() }
            moreView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 250)
            moreView.sureBlock = { oneStr, twoStr, threeStr in
                fourMenu.adjustTitle(threeStr, textColor: UIColor.init(cssStr: "#547AFF"))
                self.pageIndex = 1
                self.predictValue = oneStr
                self.updateTime = twoStr
                self.getListInfo()
            }
            return moreView
        }
        
        coverView.addSubview(oneSwitch)
        oneSwitch.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.size.equalTo(CGSize(width: 25, height: 12.5))
            make.left.equalTo(menuView.snp.right)
        }
        coverView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(oneSwitch.snp.bottom).offset(2)
            make.centerX.equalTo(oneSwitch.snp.centerX)
            make.height.equalTo(14)
        }
        
        coverView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(SCREEN_WIDTH)
            make.top.equalTo(menuView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.pageIndex = 1
            getListInfo()
        })
        
        //添加上拉加载更多
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.getListInfo()
        })
        //获取列表数据信息
        getListInfo()
        getPropertyInfo()
        getZhuiZongInfo()
    }
    
    @objc func switchChanged(_ sender: SevenSwitch) {
        print("Changed value to: \(sender.on)")
        self.model.value?.pageableData?.isShowLine = sender.on
        self.tableView.reloadData()
    }
    
}

extension PropertyLineOneViewController {
    
    func configure(with dynamiccontent: [String]) {
        // 清空之前的 labels
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        // 创建新的 labels
        for name in dynamiccontent {
            let infoView = PropertyLineInfoView()
            if let attributedText = name.htmlToAttributedString {
                infoView.nameLabel.attributedText = attributedText
            } else {
                infoView.nameLabel.text = "Failed to parse HTML."
            }
            infoView.setContentHuggingPriority(.defaultLow, for: .vertical)
            stackView.addArrangedSubview(infoView)
        }
    }
    
}

extension PropertyLineOneViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        let numLabel = UILabel()
        numLabel.textColor = .init(cssStr: "#666666")
        numLabel.font = .regularFontOfSize(size: 12)
        numLabel.textAlignment = .left
        headView.addSubview(numLabel)
        headView.backgroundColor = .init(cssStr: "#F5F5F5")
        let moneyLabel = UILabel()
        moneyLabel.textColor = .init(cssStr: "#666666")
        moneyLabel.font = .regularFontOfSize(size: 12)
        moneyLabel.textAlignment = .left
        headView.addSubview(moneyLabel)
        
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(30)
        }
        
        moneyLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(numLabel.snp.right).offset(1)
            make.height.equalTo(30)
        }
        let count1 = String(self.model.value?.pageableData?.totalElements ?? 0)
        let count2 = self.model.value?.pageableData?.totalValue ?? ""
        let count3 = self.model.value?.pageableData?.valueUnit ?? ""
        let moneyStr = "\(count2)\(count3)"
        numLabel.attributedText = GetRedStrConfig.getRedStr(from: count1, fullText: "共\(count1)条线索,", font: UIFont.regularFontOfSize(size: 12))
        moneyLabel.attributedText = GetRedStrConfig.getRedStr(from: count2, fullText: "预估价值\(moneyStr)", font: UIFont.regularFontOfSize(size: 12))
        
        return headView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.allArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyLineOneViewCell", for: indexPath) as! PropertyLineOneViewCell
        cell.selectionStyle = .none
        model.isShowLine = self.oneSwitch.on
        cell.model = model
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.allArray[indexPath.row]
        let pageUrl = base_url + "\(model.detailUrl ?? "")"
        let webVc = WebPageViewController()
        webVc.pageUrl.accept(pageUrl)
        self.navigationController?.pushViewController(webVc, animated: true)
    }
    
}

/** 网络数据请求 */
extension PropertyLineOneViewController {
    
    //获取财产评估信息
    private func getPropertyInfo() {
        let man = RequestManager()
        let dict = ["subjectId": entityId]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/property/clues/search/findPropertyAssessmentData",
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self, let modelArray = success.datasss {
                        let titles = modelArray.joined(separator: ",").components(separatedBy: ",")
                        configure(with: titles)
                        self.leftTitles = titles
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取财产追踪
    private func getZhuiZongInfo() {
        let man = RequestManager()
        let dict = ["subjectId": entityId,
                    "type": "1"]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/property/clues/search/findDebtCluesDiscoveredData",
                       method: .get) { [weak self] result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self, let modelArray = success.datasss {
                        let titles = modelArray.joined(separator: ",").components(separatedBy: ",")
                        self.rightTitles = titles
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //获取财产线索列表信息
    private func getListInfo() {
        let subjectId = entityId
        let subjectType = "1"
        let dict = ["subjectId": subjectId,
                    "subjectType": subjectType,
                    "conditionCode": conditionCode,
                    "clueDirection": clueDirection,
                    "clueModel": clueModel,
                    "predictValue": predictValue,
                    "updateTime": updateTime,
                    "pageIndex": pageIndex,
                    "pageSize": 10] as [String : Any]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/property/clues/search/findCluePageList",
                       method: .post) { [weak self] result in
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self, let model = success.data?.pageableData, let total = model.totalElements {
                        self.model.accept(success.data)
                        if pageIndex == 1 {
                            self.allArray.removeAll()
                        }
                        pageIndex += 1
                        let pageData = model.pageItems ?? []
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
    
    //获取分组
    private func getGroupInfo() {
        let man = RequestManager()
        let dict = [String: String]()
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/monitor/group",
                       method: .get) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let modelArray = success.data?.groupList {
                        let groupView = FocusCompanyPopGroupView()
                        groupView.frame = self.view.superview!.frame
                        groupView.model.accept(modelArray)
                        let alertVc = TYAlertController(alert: groupView, preferredStyle: .alert)!
                        self.present(alertVc, animated: true)
                        groupView.cblock = { [weak self] in
                            self?.dismiss(animated: true)
                        }
                        groupView.sblock = { [weak self] model in
                            self?.dismiss(animated: true, completion: {
                                let monitorListId = self?.entityId
                                let groupId = model.eid ?? ""
                                let dict = ["monitorListId": monitorListId, "groupId": groupId]
                                man.requestAPI(params: dict as [String : Any],
                                               pageUrl: "/firminfo/monitor/group/set-group",
                                               method: .post) { result in
                                    switch result {
                                    case .success(let success):
                                        if success.code == 200 {
                                            ToastViewConfig.showToast(message: "设置成功")
                                        }
                                        break
                                    case .failure(_):
                                        break
                                    }
                                }
                            })
                        }
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //添加关联方信息
    func addUnioInfo(form entityId: String, name: String) {
        let man = RequestManager()
        let dict = ["entityId": entityId,
                    "entityType": "1"]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/monitor/relation",
                       method: .get) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let modelArray = success.data?.monitorRelationVOList {
                        let popView = PropertyAlertView(frame: CGRectMake(0, StatusHeightManager.navigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - StatusHeightManager.navigationBarHeight))
                        popView.ctImageView.image = UIImage.imageOfText(name, size: (30, 30))
                        popView.nameLabel.text = name
                        popView.modelArray = modelArray
                        popView.tableView.reloadData()
                        UIView.animate(withDuration: 0.25) {
                            keyWindow?.addSubview(popView)
                        }
                    }
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}


