//
//  PropertyTwoViewController.swift
//  问道云
//
//  Created by Andrew on 2025/2/20.
//

import UIKit
import DropMenuBar
import RxRelay
import MJRefresh
import SkeletonView

class PropertyTwoViewController: WDBaseViewController {
    
    //所有数据
    var allArray: [pageItemsModel] = []
    var model = BehaviorRelay<DataModel?>(value: nil)
    
    private let man = RequestManager()
    //参数
    var directionType: String = ""
    var clueModel: String = ""
    var clueClassification: String = ""
    var updateTime: String = ""
    var pageNum: Int = 1
    
    var backBlock: (() -> Void)?
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "财产线索监控"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setImage(UIImage(named: "rightHeadLogo"), for: .normal)
        return headView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(PropertyLineTwoCell.self, forCellReuseIdentifier: "PropertyLineTwoCell")
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
    
    lazy var moreView: PropertyLineOnlyTimeView = {
        let moreView = PropertyLineOnlyTimeView()
        return moreView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addHeadView(from: headView)
        headView.backBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.backBlock?()
        }).disposed(by: disposeBag)
        
        let oneMenu = MenuAction(title: "线索分类", style: .typeList)!
        let twoMenu = MenuAction(title: "线索类型", style: .typeList)!
        let threeMenu = MenuAction(title: "线索类型", style: .typeList)!
        let fourMenu = MenuAction(title: "更多筛选", style: .typeCustom)!
        
        
        //线索分类
        self.model.asObservable()
            .map { $0?.conditionVO?.cueObject ?? [] }
            .subscribe(onNext: { [weak self] modelArray in
                guard let self = self else { return }
                let modelArray = getThreePropertyLineInfo(from: modelArray)
                oneMenu.listDataSource = modelArray
        }).disposed(by: disposeBag)
        oneMenu.didSelectedMenuResult = { [weak self] index, model, granted in
            self?.pageNum = 1
            self?.clueClassification = model?.currentID ?? ""
            self?.getListInfo()
        }
        
        //财产留向
        self.model.asObservable()
            .map { $0?.conditionVO?.propertyDirection ?? [] }
            .subscribe(onNext: { [weak self] modelArray in
                guard let self = self else { return }
                let modelArray = getTwoPropertyLineInfo(from: modelArray)
                twoMenu.listDataSource = modelArray
        }).disposed(by: disposeBag)
        twoMenu.didSelectedMenuResult = { [weak self] index, model, granted in
            self?.pageNum = 1
            self?.directionType = model?.currentID ?? ""
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
            self?.pageNum = 1
            self?.clueModel = model?.currentID ?? ""
            self?.getListInfo()
        }
        
        //更多筛选条件
        fourMenu.displayCustomWithMenu = { [weak self] in
            guard let self = self else { return UIView() }
            moreView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 250)
            moreView.sureBlock = { oneStr, twoStr in
                if oneStr.contains("-") {
                    fourMenu.adjustTitle(oneStr, textColor: UIColor.init(cssStr: "#547AFF"))
                }else {
                    fourMenu.adjustTitle(twoStr, textColor: UIColor.init(cssStr: "#547AFF"))
                }
                self.pageNum = 1
                self.updateTime = oneStr
                self.getListInfo()
            }
            return moreView
        }
        
        
        let menuView = DropMenuBar(action: [oneMenu, twoMenu, threeMenu, fourMenu])!
        menuView.backgroundColor = .white
        view.addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(32)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(menuView.snp.bottom).offset(1)
            make.left.bottom.right.equalToSuperview()
        }
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.pageNum = 1
            getListInfo()
        })
        
        //添加上拉加载更多
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.getListInfo()
        })
        //获取列表数据信息
        getListInfo()
    }
    
}

extension PropertyTwoViewController {
    
    private func getListInfo() {
        ViewHud.addLoadView()
        let dict = ["clueClassification": clueClassification,
                    "directionType": directionType,
                    "clueModel": clueModel,
                    "updateTime": updateTime,
                    "pageNum": pageNum,
                    "pageSize": 20] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/clue-monitor",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    if let self = self, let model = success.data, let total = model.total {
                        self.model.accept(success.data)
                        if pageNum == 1 {
                            self.allArray.removeAll()
                        }
                        pageNum += 1
                        let pageData = model.pitems ?? []
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
                        DispatchQueue.main.asyncAfter(delay: 0.25) {
                            self.tableView.hideSkeleton()
                            self.tableView.reloadData()
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

extension PropertyTwoViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        let count1 = String(self.model.value?.total ?? 0)
        let count2 = self.model.value?.amount ?? ""
        let count3 = self.model.value?.amountUnit ?? ""
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyLineTwoCell", for: indexPath) as! PropertyLineTwoCell
        cell.selectionStyle = .none
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
