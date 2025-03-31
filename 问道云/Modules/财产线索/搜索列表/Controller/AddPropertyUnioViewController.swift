//
//  AddPropertyUnioViewController.swift
//  问道云
//
//  Created by Andrew on 2025/3/28.
//  添加财产关联方

import UIKit
import RxSwift
import MJRefresh

class AddPropertyUnioViewController: WDBaseViewController {
    
    //搜索的关联方
    var modelArray: [rowsModel] = []
    
    //已经添加的数据
    var itemsArray: [itemsModel] = []
    
    private let man = RequestManager()
    
    var entityId: String = ""
    //名字
    var entityName: String = ""
    
    var keyWords: String = ""
    
    var pageNum: Int = 1
    
    var addPageNum: Int = 1
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "添加财产关联方"
        headView.oneBtn.setImage(UIImage(named: "rightHeadLogo"), for: .normal)
        return headView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        return ctImageView
    }()
    
    lazy var mlabel: UILabel = {
        let mlabel = UILabel()
        mlabel.textColor = UIColor.init(cssStr: "#333333")
        mlabel.textAlignment = .left
        mlabel.font = .mediumFontOfSize(size: 16)
        return mlabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.text = "添加自定义财产关联方"
        descLabel.textColor = .init(cssStr: "#333333")
        descLabel.font = .mediumFontOfSize(size: 14)
        return descLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView
    }()
    
    lazy var lineView1: UIView = {
        let lineView1 = UIView()
        lineView1.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView1
    }()
    
    lazy var searchTx: UITextField = {
        let searchTx = UITextField()
        let attrString = NSMutableAttributedString(string: "请输入企业、人员名称等关键词", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#999999") as Any,
            .font: UIFont.regularFontOfSize(size: 12)
        ])
        searchTx.attributedPlaceholder = attrString
        searchTx.font = UIFont.mediumFontOfSize(size: 14)
        searchTx.textColor = UIColor.init(cssStr: "#333333")
        searchTx.clearButtonMode = .whileEditing
        searchTx.layer.cornerRadius = 5
        searchTx.backgroundColor = .init(cssStr: "#F3F3F3")
        searchTx.leftView = UIView(frame: CGRectMake(0, 0, 15, 15))
        searchTx.leftViewMode = .always
        return searchTx
    }()
    
    lazy var lineView2: UIView = {
        let lineView2 = UIView()
        lineView2.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView2
    }()
    
    lazy var descLabel1: UILabel = {
        let descLabel1 = UILabel()
        descLabel1.text = "已添加自定义财产关联方"
        descLabel1.textColor = .init(cssStr: "#333333")
        descLabel1.font = .mediumFontOfSize(size: 14)
        return descLabel1
    }()
    
    lazy var lineView3: UIView = {
        let lineView3 = UIView()
        lineView3.backgroundColor = .init(cssStr: "#F5F5F5")
        return lineView3
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(AddPropertyUnioCell.self, forCellReuseIdentifier: "AddPropertyUnioCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
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
    
    lazy var addTableView: UITableView = {
        let addTableView = UITableView(frame: .zero, style: .plain)
        addTableView.separatorStyle = .none
        addTableView.backgroundColor = .clear
        addTableView.register(PropertyAddCustomerViewCell.self, forCellReuseIdentifier: "PropertyAddCustomerViewCell")
        addTableView.estimatedRowHeight = 80
        addTableView.showsVerticalScrollIndicator = false
        addTableView.contentInsetAdjustmentBehavior = .never
        addTableView.rowHeight = UITableView.automaticDimension
        addTableView.delegate = self
        addTableView.dataSource = self
        if #available(iOS 15.0, *) {
            addTableView.sectionHeaderTopPadding = 0
        }
        return addTableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        addHeadView(from: headView)
        view.addSubview(ctImageView)
        view.addSubview(mlabel)
        ctImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 35, height: 35))
            make.top.equalTo(headView.snp.bottom).offset(9.5)
            make.left.equalToSuperview().offset(10)
        }
        mlabel.snp.makeConstraints { make in
            make.centerY.equalTo(ctImageView.snp.centerY)
            make.left.equalTo(ctImageView.snp.right).offset(5)
            make.height.equalTo(25)
        }
        ctImageView.image = UIImage.imageOfText(entityName, size: (35, 35))
        mlabel.text = entityName
        
        view.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(5)
            make.top.equalTo(ctImageView.snp.bottom).offset(9.5)
        }
        
        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(lineView.snp.bottom).offset(14.5)
        }
        
        view.addSubview(lineView1)
        lineView1.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(descLabel.snp.bottom).offset(14)
        }
        
        view.addSubview(searchTx)
        searchTx.snp.makeConstraints { make in
            make.height.equalTo(40.pix())
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView1.snp.bottom).offset(10)
        }
        
        view.addSubview(lineView2)
        lineView2.snp.makeConstraints { make in
            make.top.equalTo(searchTx.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(5)
        }
        
        view.addSubview(descLabel1)
        view.addSubview(lineView3)
        descLabel1.snp.makeConstraints { make in
            make.left.equalTo(descLabel.snp.left)
            make.height.equalTo(25)
            make.top.equalTo(lineView2.snp.bottom).offset(14.5)
        }
        lineView3.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(descLabel1.snp.bottom).offset(14)
            make.height.equalTo(1)
        }
        //搜索的tableview
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(lineView2.snp.bottom)
        }
        
        //已经添加的tableview
        view.addSubview(addTableView)
        addTableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(lineView3.snp.bottom)
        }
        
        self.searchTx
            .rx
            .controlEvent(.editingChanged)
            .withLatestFrom(self.searchTx.rx.text.orEmpty)
            .distinctUntilChanged()
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] keywords in
                self?.keyWords = keywords
                self?.pageNum = 1
                self?.searchInfo()
        }).disposed(by: disposeBag)
        
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            pageNum = 1
            searchInfo()
        })
        
        //添加上拉加载更多
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            self.searchInfo()
        })
        
        self.addTableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            addPageNum = 1
            addUnioInfo()
        })
        
        self.addTableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            addUnioInfo()
        })
        
        addUnioInfo()
    }
    
}

extension AddPropertyUnioViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == addTableView {
            return self.itemsArray.count
        }else {
            return self.modelArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.addTableView {
            let model = self.itemsArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "PropertyAddCustomerViewCell", for: indexPath) as! PropertyAddCustomerViewCell
            cell.selectionStyle = .none
            cell.model = model
            return cell
        }else {
            let model = self.modelArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddPropertyUnioCell", for: indexPath) as! AddPropertyUnioCell
            cell.selectionStyle = .none
            cell.model = model
            cell.cellCompanyBlock = { [weak self] model in
                self?.companyUnioInfo(from: model)
            }
            cell.cellPeopleBlock = { [weak self] model in
                self?.peopleUnioInfo(from: model)
            }
            return cell
        }
    }
    
}

/** 网络数据请求 */
extension AddPropertyUnioViewController {
    
    private func companyUnioInfo(from model: rowsModel) {
        let companyVc = AddPropertyCompanyUnioViewController()
        companyVc.model = model
        companyVc.entityId = entityId
        companyVc.entityName = entityName
        self.navigationController?.pushViewController(companyVc, animated: true)
        companyVc.refreshBlock = { [weak self] in
            self?.addTableView.isHidden = false
            self?.tableView.isHidden = true
            self?.addPageNum = 1
            self?.pageNum = 1
            self?.addUnioInfo()
        }
    }
    
    private func peopleUnioInfo(from model: rowsModel) {
        let peopleVc = AddPropertyPeopleUnioViewController()
        peopleVc.model = model
        peopleVc.entityId = entityId
        peopleVc.entityName = entityName
        self.navigationController?.pushViewController(peopleVc, animated: true)
        peopleVc.refreshBlock = { [weak self] in
            self?.addTableView.isHidden = false
            self?.tableView.isHidden = true
            self?.addPageNum = 1
            self?.pageNum = 1
            self?.addUnioInfo()
        }
    }
    
    private func searchInfo() {
        ViewHud.addLoadView()
        let dict = ["keyWords": keyWords,
                    "subjectId": entityId,
                    "subjectType": "1",
                    "pageNum": pageNum,
                    "pageSize": 20] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/customer/relation/searchCompanyPageList",
                       method: .post) { [weak self] result in
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            ViewHud.hideLoadView()
            guard let self = self else { return }
            switch result {
            case .success(let success):
                if success.code == 200 {
                    let model = success.data
                    let total = model?.total ?? 0
                    if pageNum == 1 {
                        self.modelArray.removeAll()
                    }
                    pageNum += 1
                    let pageData = model?.data ?? []
                    self.modelArray.append(contentsOf: pageData)
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
                    }else {
                        self.addNodataView(from: self.tableView)
                    }
                    if self.itemsArray.count != total {
                        self.tableView.mj_footer?.isHidden = false
                    }else {
                        self.tableView.mj_footer?.isHidden = true
                    }
                    self.tableView.isHidden = false
                    self.addTableView.isHidden = true
                    self.tableView.reloadData()
                }else {
                    self.tableView.isHidden = true
                    self.addTableView.isHidden = false
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    //已经添加的自定义财产关联方
    private func addUnioInfo() {
        let man = RequestManager()
        let dict = ["pageNum": addPageNum,
                    "pageSize": 20,
                    "relationId": entityId] as [String : Any]
        man.requestAPI(params: dict,
                       pageUrl: "/firminfo/customer/relation/pageList",
                       method: .post) { [weak self] result in
            guard let self = self else { return }
            self.addTableView.mj_header?.endRefreshing()
            self.addTableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if success.code == 200 {
                    let model = success.data
                    let total = model?.total ?? 0
                    if addPageNum == 1 {
                        self.itemsArray.removeAll()
                    }
                    addPageNum += 1
                    let pageData = model?.items ?? []
                    self.itemsArray.append(contentsOf: pageData)
                    if total != 0 {
                        self.emptyView.removeFromSuperview()
                    }else {
                        self.addNodataView(from: self.tableView)
                    }
                    if self.itemsArray.count != total {
                        self.addTableView.mj_footer?.isHidden = false
                    }else {
                        self.addTableView.mj_footer?.isHidden = true
                    }
                    self.addTableView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}
