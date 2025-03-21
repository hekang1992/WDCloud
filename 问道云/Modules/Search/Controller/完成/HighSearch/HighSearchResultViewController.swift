//
//  HighSearchResultViewController.swift
//  问道云
//
//  Created by Andrew on 2025/3/3.
//

import UIKit
import MJRefresh
import SkeletonView

class HighSearchResultViewController: WDBaseViewController {
    
    //总数
    var allArray: [pageDataModel] = []
    
    var dataModel: DataModel?
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "搜索结果"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .white
        headView.oneBtn.setImage(UIImage(named: "rightHeadLogo"), for: .normal)
        return headView
    }()
    
    //搜索条件
    var searchConditionArray: [String]? {
        didSet {
            guard let searchConditionArray = searchConditionArray else { return }
            numLabel.text = "已选 \(searchConditionArray.count)"
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(HighSearchViewCell.self,
                           forCellReuseIdentifier: "HighSearchViewCell")
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
    
    //参数
    var pageIndex: Int = 1
    var dict = [String: Any]()
    //关键词
    var keyword: [String: String]?
    //精准度
    var matchType: [String: Any]?
    //行业
    var industryType: [String: String]?
    //地区
    var region:[String: Any]?
    //登记状态
    var regStatusVec: [String: [Int]]?
    //成立年限
    var incDateTypeVec: [String: [Int]]?
    //自定义时间
    var incDateRange: [String: String]?
    //注册资本
    var regCapLevelVec: [String: [Int]]?
    //自定义资本
    var regCapRange: [String: String]?
    //机构类型
    var econTypeVec: [String: [Int]]?
    //企业类型
    var categoryVec: [String: [Int]]?
    //参保人数
    var sipCountLevelVec: [String: [Int]]?
    //自定义参保人数
    var sipCountRange: [String: String]?
    //上市状态
    var listStatusVec: [String: [Int]]?
    //上市板块
    var listingSectorVec: [String: [Int]]?
    //邮箱
    var hasEmail: [String: Bool]?
    
    lazy var numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.textColor = .init(cssStr: "#333333")
        numLabel.textAlignment = .left
        numLabel.font = .mediumFontOfSize(size: 12)
        return numLabel
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        addHeadView(from: headView)
        view.backgroundColor = .white
        view.addSubview(numLabel)
        view.addSubview(scrollView)
        numLabel.snp.makeConstraints { make in
            make.height.equalTo(16.5)
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(headView.snp.bottom).offset(13.5)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.right.equalToSuperview()
            make.left.equalTo(numLabel.snp.right).offset(12)
            make.height.equalTo(44)
        }
        createButtons(from: searchConditionArray ?? [])
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(1)
            make.left.right.bottom.equalToSuperview()
        }
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            pageIndex = 1
            getHighSearchInfo()
        })
        
        //添加上拉加载更多
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getHighSearchInfo()
        })
        getHighSearchInfo()
        tableView.isSkeletonable = true
        tableView.showAnimatedGradientSkeleton()
    }
    
    private func getHighSearchInfo() {
        let man = RequestManager()
        dict = ["pageSize": 20, "pageIndex": pageIndex]
        if let keyword = keyword {
            dict.merge(keyword, uniquingKeysWith: { (current, new) in
                return current
            })
        }
        if let matchType = matchType {
            dict.merge(matchType, uniquingKeysWith: { (current, new) in
                return current
            })
        }
        if let industryType = industryType {
            dict.merge(industryType, uniquingKeysWith: { (current, new) in
                return current
            })
        }
        if let region = region {
            dict.merge(region, uniquingKeysWith: { (current, new) in
                return current
            })
        }
        if let regStatusVec = regStatusVec {
            dict.merge(regStatusVec, uniquingKeysWith: { (current, new) in
                return current
            })
        }
        if let incDateTypeVec = incDateTypeVec {
            dict.merge(incDateTypeVec, uniquingKeysWith: { (current, new) in
                return current
            })
        }
        if let incDateRange = incDateRange {
            dict.merge(incDateRange, uniquingKeysWith: { (current, new) in
                return current
            })
        }
        if let regCapLevelVec = regCapLevelVec {
            dict.merge(regCapLevelVec, uniquingKeysWith: { (current, new) in
                return current
            })
        }
        if let regCapRange = regCapRange {
            dict.merge(regCapRange, uniquingKeysWith: { (current, new) in
                return current
            })
        }
        if let categoryVec = categoryVec {
            dict.merge(categoryVec, uniquingKeysWith: { (current, new) in
                return current
            })
        }
        if let econTypeVec = econTypeVec {
            dict.merge(econTypeVec, uniquingKeysWith: { (current, new) in
                return current
            })
        }
        if let sipCountLevelVec = sipCountLevelVec {
            dict.merge(sipCountLevelVec, uniquingKeysWith: { (current, new) in
                return current
            })
        }
        if let sipCountRange = sipCountRange {
            dict.merge(sipCountRange, uniquingKeysWith: { (current, new) in
                return current
            })
        }
        if let listStatusVec = listStatusVec {
            dict.merge(listStatusVec, uniquingKeysWith: { (current, new) in
                return current
            })
        }
        if let listingSectorVec = listingSectorVec {
            dict.merge(listingSectorVec, uniquingKeysWith: { (current, new) in
                return current
            })
        }
        if let hasEmail = hasEmail {
            dict.merge(hasEmail, uniquingKeysWith: { (current, new) in
                return current
            })
        }
        man.requestAPI(params: dict,
                       pageUrl: "/entity/v2/org-list/search",
                       method: .post) { [weak self] result in
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let self = self,
                   let model = success.data,
                   let total = model.pageMeta?.totalNum {
                    self.dataModel = model
                    if self.pageIndex == 1 {
                        self.pageIndex = 1
                        self.allArray.removeAll()
                    }
                    self.pageIndex += 1
                    let pageData = model.pageData ?? []
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
                    DispatchQueue.main.asyncAfter(delay: 0.15) {
                        self.tableView.hideSkeleton()
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

extension HighSearchResultViewController {
    
    func createButtons(from titles: [String]) {
        var previousButton: UIButton? = nil
        for (_, title) in titles.enumerated() {
            let iconImageView = UIImageView()
            iconImageView.image = UIImage(named: "highselimage")
            let button = UIButton(type: .custom)
            button.setTitle(title, for: .normal)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.init(cssStr: "#547AFF")?.cgColor
            button.backgroundColor = .init(cssStr: "#547AFF")?.withAlphaComponent(0.05)
            button.setTitleColor(.init(cssStr: "#547AFF"), for: .normal)
            button.titleLabel?.font = .regularFontOfSize(size: 12)
            scrollView.addSubview(button)
            button.addSubview(iconImageView)
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            button.snp.makeConstraints { make in
                make.height.equalTo(25.pix())
                make.centerY.equalToSuperview()
                if let previousButton = previousButton {
                    make.left.equalTo(previousButton.snp.right).offset(10)
                } else {
                    make.left.equalToSuperview().offset(10)
                }
            }
            iconImageView.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 9.pix(), height: 9.pix()))
                make.bottom.equalToSuperview().offset(-1.5)
                make.right.equalToSuperview().offset(-1.5)
            }
            previousButton = button
        }
        
        if let lastButton = previousButton {
            scrollView.snp.makeConstraints { make in
                make.right.equalTo(lastButton.snp.right).offset(10)
            }
        }
    }
    
}

extension HighSearchResultViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "HighSearchViewCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
}

extension HighSearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.pix()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView()
        let numLabel = UILabel()
        numLabel.textColor = .init(cssStr: "#999999")
        let count = String(self.dataModel?.pageMeta?.totalNum ?? 0)
        numLabel.attributedText = GetRedStrConfig.getRedStr(from: count, fullText: "搜索到: \(count)家企业")
        numLabel.textAlignment = .left
        numLabel.font = .regularFontOfSize(size: 12)
        headView.backgroundColor = .init(cssStr: "#F3F3F3")
        headView.addSubview(numLabel)
        numLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.bottom.right.equalToSuperview()
        }
        return headView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.allArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HighSearchViewCell", for: indexPath) as! HighSearchViewCell
        cell.selectionStyle = .none
        cell.model = model
        cell.focusBlock = { [weak self] in
            if let self = self {
                let followStatus = model.followStatus ?? ""
                if followStatus == "1" {
                    addFocusInfo(from: model, cell: cell)
                }else {
                    deleteFocusInfo(from: model, cell: cell)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.allArray[indexPath.row]
        let companyDetailVc = CompanyBothViewController()
        let enityId = model.orgInfo?.orgId ?? ""
        let companyName = model.orgInfo?.orgName ?? ""
        companyDetailVc.enityId.accept(enityId)
        companyDetailVc.companyName.accept(companyName)
        companyDetailVc.refreshBlock = { [weak self] index in
            self?.pageIndex = 1
            self?.getHighSearchInfo()
        }
        self.navigationController?.pushViewController(companyDetailVc, animated: true)
    }
    
}

/** 网络数据请求 */
extension HighSearchResultViewController {
    
    //添加关注
    private func addFocusInfo<T: BaseViewCell>(from model: pageDataModel, cell: T) {
        let man = RequestManager()
        let dict = ["entityId": model.orgInfo?.orgId ?? "",
                    "followTargetType": "1"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/follow/add-or-cancel",
                       method: .post) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    model.followStatus = "2"
                    if let specificCell = cell as? HighSearchViewCell {
                        specificCell.focusBtn.setImage(UIImage(named: "havefocusimage"), for: .normal)
                    }
                    ToastViewConfig.showToast(message: "关注成功")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //取消关注
    private func deleteFocusInfo<T: BaseViewCell>(from model: pageDataModel, cell: T) {
        let man = RequestManager()
        let dict = ["entityId": model.orgInfo?.orgId ?? "",
                    "followTargetType": "1"]
        man.requestAPI(params: dict,
                       pageUrl: "/operation/follow/add-or-cancel",
                       method: .post) { result in
            switch result {
            case .success(let success):
                if success.code == 200 {
                    model.followStatus = "1"
                    if let specificCell = cell as? HighSearchViewCell {
                        specificCell.focusBtn.setImage(UIImage(named: "addfocunimage"), for: .normal)
                    }
                    ToastViewConfig.showToast(message: "取消关注成功")
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
