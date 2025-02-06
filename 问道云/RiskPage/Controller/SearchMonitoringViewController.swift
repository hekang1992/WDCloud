//
//  SearchMonitoringViewController.swift
//  问道云
//
//  Created by 何康 on 2025/2/6.
//  搜索监控列表

import UIKit
import SnapKit
import MJRefresh

class SearchMonitoringViewController: WDBaseViewController {
    
    var pageNum: Int = 1
    var pageSize: Int = 20
    var allArray: [itemsModel] = []
    
    lazy var headView: HeadView = {
        let headView = HeadView(frame: .zero, typeEnum: .oneBtn)
        headView.titlelabel.text = "搜索监控企业"
        headView.titlelabel.textColor = .black
        headView.bgView.backgroundColor = .clear
        headView.oneBtn.setImage(UIImage(named: "headrightoneicon"), for: .normal)
        return headView
    }()
    
    lazy var cycleView: UIView = {
        let cycleView = UIView()
        cycleView.layer.cornerRadius = 4
        cycleView.layer.borderWidth = 1
        cycleView.layer.borderColor = UIColor.init(cssStr: "#DCDCDC")?.cgColor
        return cycleView
    }()
    
    lazy var ctImageView: UIImageView = {
        let ctImageView = UIImageView()
        ctImageView.image = UIImage(named: "searchiconf")
        return ctImageView
    }()
    
    lazy var descImageView: UIImageView = {
        let descImageView = UIImageView()
        descImageView.image = UIImage(named: "miaoshiuriskomn")
        return descImageView
    }()
    
    lazy var searchTx: UITextField = {
        let searchTx = UITextField()
        let attrString = NSMutableAttributedString(string: "请输入你需要监控的企业名称", attributes: [
            .foregroundColor: UIColor.init(cssStr: "#DCDCDC") as Any,
            .font: UIFont.mediumFontOfSize(size: 14)
        ])
        searchTx.attributedPlaceholder = attrString
        searchTx.font = UIFont.mediumFontOfSize(size: 14)
        searchTx.textColor = UIColor.init(cssStr: "#333333")
        searchTx.clearButtonMode = .whileEditing
        searchTx.delegate = self
        return searchTx
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(SearchMonitoringViewCell.self, forCellReuseIdentifier: "SearchMonitoringViewCell")
        tableView.estimatedRowHeight = 80
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        addHeadView(from: headView)
        view.addSubview(cycleView)
        cycleView.addSubview(ctImageView)
        cycleView.addSubview(searchTx)
        view.addSubview(descImageView)
        view.addSubview(tableView)
        cycleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(headView.snp.bottom).offset(4)
            make.height.equalTo(40)
        }
        ctImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 17, height: 17))
            make.left.equalToSuperview().offset(10)
        }
        searchTx.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.right.equalToSuperview().offset(-4)
            make.left.equalTo(ctImageView.snp.right).offset(10)
        }
        descImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-17)
            make.size.equalTo(CGSize(width: 337, height: 79))
        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(cycleView.snp.bottom).offset(2)
            make.bottom.equalTo(descImageView.snp.top).offset(-2)
        }
        
        self.tableView.mj_header = WDRefreshHeader(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            pageNum = 1
            getSearchListInfo(from: self.searchTx.text ?? "")
        })
        
        //添加上拉加载更多
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let self = self else { return }
            getSearchListInfo(from: self.searchTx.text ?? "")
        })
        
    }

}

extension SearchMonitoringViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("搜索文字:\(textField.text ?? "")")
        textField.resignFirstResponder()
        getSearchListInfo(from: textField.text ?? "")
        return true
    }
    
    private func getSearchListInfo(from targetStr: String) {
        ViewHud.addLoadView()
        let dict = ["firmname": targetStr,
                    "pageNum": pageNum,
                    "pageSize": pageSize] as [String : Any]
        let man = RequestManager()
        man.requestAPI(params: dict,
                       pageUrl: "riskmonitor/monitortarget/riskInquiryEnterprise",
                       method: .get) { [weak self] result in
            ViewHud.hideLoadView()
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.mj_footer?.endRefreshing()
            switch result {
            case .success(let success):
                if let self = self,
                   let model = success.data,
                   let code = success.code,
                   code == 200 /*let total = model.total*/ {
                    if pageNum == 1 {
                        pageNum = 1
                        self.allArray.removeAll()
                    }
                    pageNum += 1
                    let pageData = model.items ?? []
                    self.allArray.append(contentsOf: pageData)
//                    if total != 0 {
//                        self.emptyView.removeFromSuperview()
//                        self.noNetView.removeFromSuperview()
//                    }else {
//                        self.addNodataView(from: self.tableView)
//                    }
//                    if self.allArray.count != total {
//                        self.tableView.mj_footer?.isHidden = false
//                    }else {
//                        self.tableView.mj_footer?.isHidden = true
//                    }
                    self.tableView.reloadData()
                }
                break
            case .failure(let failure):
                break
            }
        }
    }
}

extension SearchMonitoringViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.allArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMonitoringViewCell", for: indexPath) as! SearchMonitoringViewCell
        cell.selectionStyle = .none
        cell.ctImageView.image = UIImage.imageOfText(model.entity_name ?? "", size: (24, 24), cornerRadius: 2)
        cell.namelabel.text = model.entity_name ?? ""
        return cell
    }

}
