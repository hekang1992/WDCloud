//
//  AddPropertyUnioViewController.swift
//  问道云
//
//  Created by 何康 on 2025/3/28.
//  添加财产关联方

import UIKit
import RxSwift
import MJRefresh

class AddPropertyUnioViewController: WDBaseViewController {
    
    var modelArray: [rowsModel]?
    
    private let man = RequestManager()
    
    var entityId: String = ""
    //名字
    var entityName: String = ""
    
    var keyWords: String = ""
    
    var pageNum: Int = 1
    
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
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(lineView3.snp.bottom)
        }
        
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
        
        
        self.searchTx
            .rx
            .controlEvent(.editingChanged)
            .withLatestFrom(self.searchTx.rx.text.orEmpty)
            .distinctUntilChanged()
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] keywords in
                self?.keyWords = keywords
                self?.searchInfo()
        }).disposed(by: disposeBag)
    }
    
}

extension AddPropertyUnioViewController {
    
    private func searchInfo() {
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
            switch result {
            case .success(let success):
                if success.code == 200 {
                    self?.tableView.isHidden = false
                    let modelArray = success.data?.data ?? []
                    self?.modelArray = modelArray
                    self?.tableView.reloadData()
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
}

extension AddPropertyUnioViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.modelArray?[indexPath.row]
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

/** 网络数据请求 */
extension AddPropertyUnioViewController {
    
    private func companyUnioInfo(from model: rowsModel) {
        
    }
    
    private func peopleUnioInfo(from model: rowsModel) {
        
    }
    
}
